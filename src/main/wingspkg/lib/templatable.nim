from strutils import indent, isEmptyOrWhitespace, isSpaceAscii, join, removePrefix,
  removeSuffix, replace, split, splitLines, splitWhitespace, startsWith, unindent
import stones/genlib
import stones/cases
import stones/log
import stones/strlib
import sets
import tables
import ./tconfig, ./tempconst, ./winterface
import ../util/filename

type
  Templatable* = object
    replacements*: Table[string, string]
    fields*: seq[Table[string, string]]
    langBasedReps*: Table[string, Table[string, string]]
    langBasedMultireps*: Table[string, Table[string, HashSet[string]]]
    langBasedFields*: Table[string, seq[Table[string, string]]]

proc parseType(
  iwings: var IWings,
  s: string,
  langConfig: TConfig,
): Table[string, string]

proc processFunctions(s: string, ind: Indentation): string =
  var ci: string = ""
  var start: bool = false
  var cur: string = ""
  for c in s:
    if c == '\n':
      start = true
      if ci == "" or (cur.len() < ci.len() and cur.len() > 0):
        ci = cur
      cur = ""
    elif start and isSpaceAscii(c):
      cur &= c
    else:
      start = false

  if ci == "" or cur.len() < ci.len():
    ci = cur

  var strings: seq[string] = splitLines(s)

  for str in strings:
    var mutableStr: string = str
    if result.len() > 0:
      result &= "\n"
    if isEmptyOrWhitespace(str):
      continue
    var count: int = 0

    while mutableStr.startsWith(ci):
      mutableStr.removePrefix(ci)
      inc(count)

    for i in countup(1, count, 1):
      result &= ind.spacing

    result &= mutableStr
  if not ind.preIndent:
    result = result.unindent(1, ind.spacing)

proc processCustomType(
  wi: var IWings,
  s: string,
  ti: CustomTypeInterpreter,
  tc: TConfig,
): Table[string, string] =
  result = initTable[string, string]()
  var str: string = s
  str.removePrefix(ti.prefix)
  str.removeSuffix(ti.postfix)
  var types: seq[string] = newSeq[string](0)
  if ti.separators.len() > 0:
    types = split(str, '<', '>', ti.separators)
  else:
    types.add(str)
  if types.len() >= str.len():
    return initTable[string, string]()
  var ts: Table[string, string] = initTable[string, string]()
  var i: int = 1
  for t in types:
    ts[TYPE_PREFIX & $i & TYPE_POSTFIX] = parseType(wi, t, tc)[wrap(TK_TYPE)]
    inc(i)

  str = ti.targetType.replace(ts)
  let t: Table[Case, string] = allCases(str, Snake)
  for key in t.keys:
    result[wrap(TK_TYPE, $key)] = t[key]
  result[wrap(TK_TYPE)] = str
  result[wrap(TK_TYPE, TK_INIT)] = ti.targetInit.replace(ts)
  result[wrap(TK_TYPE, TK_PARSE)] = ti.targetParse.replace(ts)

proc parseType(
  iwings: var IWings,
  s: string,
  langConfig: TConfig,
): Table[string, string] =
  result = initTable[string, string]()
  let types: Table[Case, string] = allCases(s, Snake)
  var temp: Table[string, string] = initTable[string, string]()
  for key in types.keys:
    temp[wrap(TK_TYPE, $key)] = types[key]

  var hit: bool = false
  let typesImported: Table[string, ImportedWingsType] =
    iwings.typesImported.getOrDefault(langConfig.filetype)

  if typesImported.hasKey(s):
    result[wrap(TK_TYPE)] = typesImported[s].name
    result[wrap(TK_TYPE, TK_INIT)] = typesImported[s].init
    if typesImported[s].wingsType == WingsType.structw:
      result[wrap(TK_TYPE, TK_PARSE)] = langConfig.types[TYPE_IMPORTED].targetParse.replace(temp)
    elif typesImported[s].wingsType == WingsType.enumw:
      result[wrap(TK_TYPE, TK_PARSE)] = langConfig.parseFormat

  for key in langConfig.customTypes.keys:
    if key.len() > 0 and s.startsWith(key):
      let r: Table[string, string] = processCustomType(
        iwings,
        s,
        langConfig.customTypes[key],
        langConfig,
      )
      if not r.len() > 0:
        continue

      result.merge(r)
      if langConfig.customTypes[key].requiredImport.len() > 0:
        iwings.addImport(
          langConfig.customTypes[key].requiredImport,
          langConfig.filetype,
        )
      hit = true

  if not hit and langConfig.types.hasKey(s):
    result[wrap(TK_TYPE)] = langConfig.types[s].targetType
    if langConfig.types[s].requiredImport.len() > 0:
      iwings.addImport(
        langConfig.types[s].requiredImport,
        langConfig.filetype,
      )

    if langConfig.types[s].targetInit.len() > 0:
      result[wrap(TK_TYPE, TK_INIT)] = langConfig.types[s].targetInit
      result[wrap(TK_TYPE, TK_PARSE)] = langConfig.types[s].targetParse
    else:
      if langConfig.types.hasKey(TYPE_UNIMPORTED) and langConfig.types[TYPE_UNIMPORTED].targetInit.len() > 0:
        result[wrap(TK_TYPE, TK_INIT)] = langConfig.types[TYPE_UNIMPORTED].targetInit.replace(temp)
        result[wrap(TK_TYPE, TK_PARSE)] = langConfig.types[TYPE_UNIMPORTED].targetParse.replace(temp)
  elif not hit:
    result.add(
      wrap(TK_TYPE),
      langConfig.types[TYPE_UNIMPORTED].targetType.replace(temp),
    )
    result[wrap(TK_TYPE, TK_INIT)] = langConfig.types[TYPE_UNIMPORTED].targetInit.replace(temp)
    result.add(
      wrap(TK_TYPE, TK_PARSE),
      langConfig.types[TYPE_UNIMPORTED].targetParse.replace(temp),
    )

proc initTemplatable(): Templatable =
  result = Templatable()
  result.replacements = initTable[string, string]()
  result.langBasedReps = initTable[string, Table[string, string]]()
  result.langBasedMultireps = initTable[string, Table[string, HashSet[string]]]()
  result.fields = newSeq[Table[string, string]](0)

proc parseFields(iwings: var IWings, fs: seq[string], tconfig: TConfig): seq[Table[string, string]] =
  result = newSeq[Table[string, string]]()
  for row in fs:
    var variables: Table[string, string] = initTable[string, string]()
    let fields: seq[string] = row.splitWhitespace()
    if fields.len() < 2:
      LOG(ERROR, "Row '" & row & "' has less field than expected. Skipping...")

    variables[wrap(TK_VARNAME)] = fields[0]
    var varnames: Table[Case, string] = allCases(fields[0], Snake)
    variables[wrap(TK_VARNAME, TK_JSON)] = varnames[Snake]

    for key in varnames.keys:
      variables[wrap(TK_VARNAME, $key)] = varnames[key]

    variables.merge(
      parseType(iwings, fields[1], tconfig)
    )
    if fields.len() > 2:
      if iwings.wingsType == WingsType.loggerw:
        var keywords: seq[string] = newSeq[string]()
        for i in 2..(fields.len() - 1):
          if DBKeywords.contains(toLowerCase(fields[i])):
            keywords.add(toUpperCase(fields[i]))
          elif i == (fields.len() - 1):
            variables[wrap(TK_TYPE, TK_INIT)] = fields[2]
        variables[wrap(TK_TYPE, TK_DB_KEYWORDS)] = keywords.join()
      else:
        variables[wrap(TK_TYPE, TK_INIT)] = fields[2]
    result.add(variables)

proc parseFieldsList(fields: seq[Table[string, string]]): Table[string, string] =
  result = initTable[string, string]()
  for c in Case.low..Case.high:
    var vars = newSeq[string]()
    for f in fields:
      vars.add(f.getOrDefault(wrap(TK_VARNAME, $c)))
    result[wrap(TK_VARNAME, $c, TK_LIST)] = vars.join(", ")

  var l = newSeq[string]()
  var i = 1
  for f in fields:
    l.add("$" & $i)
    inc(i)
  result[wrap(TK_VARNAME, TK_COUNT, TK_LIST)] = l.join(", ")

proc parseAbstractFunc(
  iwings: var IWings,
  abstractFuncs: Table[string, AbstractFunction],
  tconfig: TConfig,
): seq[Table[string, string]] =
  result = newSeq[Table[string, string]]()
  for key in abstractFuncs.keys:
    let abstractFunc: AbstractFunction = abstractFuncs[key]
    var function: Table[string, string] = initTable[string, string]()
    function[wrap(TK_FUNCNAME)] = abstractFunc.name
    var funcName: Table[Case, string] = allCases(abstractFunc.name, Snake)
    for key in funcName.keys:
      function[wrap(TK_FUNCNAME, $key)] = funcName[key]

    var params: string = ""
    for (argName, argType) in abstractFunc.arguments.pairs:
      if params.len() > 0:
        params &= tconfig.interfaceConfig.paramJoiner
      params &= replace(
        tconfig.interfaceConfig.paramFormat, {
          wrap(TK_PARAM, TK_NAME): argName,
          wrap(TK_PARAM, TK_TYPE): parseType(iwings, argType, tconfig)[wrap(TK_TYPE)],
        }.toTable()
      )
    function[wrap(TK_PARAMS)] = params

    function.merge(
      parseType(iwings, abstractFunc.returnType, tconfig)
    )

    result.add(function)

proc wingsToTemplatable*(iwings: var IWings, tconfig: TConfig): Templatable =
  ## Convert IWings to TConfig.
  result = initTemplatable()
  if iwings.dependencies.len() > 0:
    LOG(
      FATAL,
      "Dependencies is not yet fulfilled for '" &
      iwings.name &
      "' when calling `wingsToTemplatable()`."
    )

  let lang: string = tconfig.filetype

  result.langBasedReps[lang] = initTable[string, string]()
  result.langBasedReps[lang][wrap(TK_FUNCTIONS)] = ""
  result.langBasedMultireps[lang] = initTable[string, HashSet[string]]()
  result.replacements[wrap(TK_COMMENT)] = iwings.comment
  result.replacements[wrap(TK_NAME)] = iwings.name

  var names: Table[Case, string] = allCases(iwings.name, Snake)
  for key in names.keys:
    result.replacements[wrap(TK_NAME, $key)] = names[key]

  var i: int = 1
  var words: seq[string] = tFilename(
    iwings.filename,
    iwings.filepath[lang],
  ).split('/')

  for w in words:
    var word: string = w
    if word != "." and word != "..":
      result.langBasedReps[lang][wrap($(words.len() - i))] = word
    inc(i)

  case iwings.wingsType
  of WingsType.interfacew:
    let winterface: WInterface = WInterface(iwings)
    if winterface.implement.hasKey(tconfig.filetype):
      result.langBasedReps[tconfig.filetype][wrap(TK_IMPLEMENT)] =
        replace(
          tconfig.implementFormat,
          wrap(TK_IMPLEMENT),
          winterface.implement[tconfig.filetype]
        )
    else:
      result.langBasedReps[tconfig.filetype][wrap(TK_IMPLEMENT)] = ""
    result.fields = parseAbstractFunc(iwings, winterface.abstractFunctions, tconfig)

    if winterface.functions.hasKey(lang):
      result.langBasedReps[lang][wrap(TK_FUNCTIONS)] =
        processFunctions(
          winterface.functions[lang], tconfig.indentation
        )
    else:
      result.langBasedReps[lang][wrap(TK_FUNCTIONS)] = ""

  of WingsType.structw:
    let wstruct: WStruct = WStruct(iwings)
    var implement: string = ""
    if wstruct.implement.hasKey(tconfig.filetype):
      implement = replace(
        tconfig.implementFormat,
        wrap(TK_IMPLEMENT),
        wstruct.implement[tconfig.filetype]
      )

    result.langBasedReps[tconfig.filetype][wrap(TK_IMPLEMENT)] = implement

    if wstruct.functions.hasKey(lang):
      result.langBasedReps[lang][wrap(TK_FUNCTIONS)] = processFunctions(
        wstruct.functions[lang], tconfig.indentation
      )
    else:
      result.langBasedReps[lang][wrap(TK_FUNCTIONS)] = ""

    result.fields = parseFields(iwings, wstruct.fields, tconfig)

  of WingsType.enumw:
    let wenum: WEnum = WEnum(iwings)
    for field in wenum.values:
      var variables: Table[string, string] = initTable[string, string]()
      variables[wrap(TK_VARNAME)] = field
      var varnames: Table[Case, string] = allCases(field, Snake)
      variables[wrap(TK_VARNAME, TK_JSON)] = varnames[Snake]
      for key in varnames.keys:
        variables[wrap(TK_VARNAME, $key)] = varnames[key]
      result.fields.add(variables)

  of WingsType.loggerw:
    let wlogger: WLogger = WLogger(iwings)
    result.fields = parseFields(iwings, wlogger.fields, tconfig)
    result.replacements.merge(parseFieldsList(result.fields))

    if wlogger.functions.hasKey(lang):
      result.langBasedReps[lang][wrap(TK_FUNCTIONS)] = processFunctions(
        wlogger.functions[lang], tconfig.indentation
      )
    else:
      result.langBasedReps[lang][wrap(TK_FUNCTIONS)] = ""

  of WingsType.default:
    LOG(FATAL, "Invalid `WingsType`.")

  if iwings.imports.hasKey(lang):
    result.langBasedMultireps[lang][wrap(TK_IMPORT)] = iwings.imports[lang]
  else:
    result.langBasedMultireps[lang][wrap(TK_IMPORT)] = initHashSet[string]()
