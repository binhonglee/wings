from strutils import indent, isSpaceAscii, removePrefix, removeSuffix,
  replace, split, splitWhitespace, startsWith, unindent
from stones/genlib import merge, getResult
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
  s: string,
  langConfig: TConfig,
  typesImported: Table[string, ImportedWingsType] = initTable[string, ImportedWingsType](),
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

  var i: int = 0
  var prev: int = 0
  var same: bool = false
  result = ""
  while i < s.len() - 1:
    if s[i] == '\n' or same:
      inc(i)
      var j: int = 0
      same = true
      while ci.len() - j > 0 and s.len() > i + j and same:
        if ci[j] == s[i + j]:
          inc(j)
        else:
          same = false
      if ci.len() - j == 0 and same:
        result &= substr(s, prev, i - 1) & ind.spacing
        prev = i + j
        i = prev - 2
    inc(i)
  result &= substr(s, prev, i - 1)
  if not ind.preIndent:
    result = result.unindent(1, ind.spacing)

proc processCustomType(
  s: string,
  ti: TypeInterpreter,
  tc: TConfig,
  kw: string,
  timpt: Table[string, ImportedWingsType],
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
    ts.add(
      TYPE_PREFIX & $i & TYPE_POSTFIX,
      parseType(t, tc, timpt)[wrap(TK_TYPE)]
    )
    inc(i)

  str = ti.output.replace(ts)
  let t: Table[Case, string] = allCases(str, Snake)
  for key in t.keys:
    result.add(
      wrap(kw, $key),
      t[key],
    )
  result.add(wrap(kw), str)

proc parseType(
  s: string,
  langConfig: TConfig,
  typesImported: Table[string, ImportedWingsType] = initTable[string, ImportedWingsType](),
): Table[string, string] =
  result = initTable[string, string]()
  var hit: bool = false

  if typesImported.hasKey(s):
    result.add(wrap(TK_TYPE), typesImported[s].name)
    result.add(wrap(TK_TYPE, TK_INIT), typesImported[s].init)

  for key in langConfig.customTypes.keys:
    if key.len() > 0 and s.startsWith(key):
      let r: Table[string, string] = processCustomType(
        s,
        langConfig.customTypes[key],
        langConfig,
        TK_TYPE,
        typesImported,
      )
      if not r.len() > 0:
        continue

      result.merge(r)
      hit = true

  if hit:
    for key in langConfig.customTypeInits.keys:
      if key.len() > 0 and s.startsWith(key):
        let r: Table[string, string] = processCustomType(
          s,
          langConfig.customTypeInits[key],
          langConfig,
          TK_TYPE & TK_SEPARATOR & TK_INIT,
          typesImported,
        )
        if not r.len() > 0:
          continue

        result.merge(r)

    if not result.hasKey(
      wrap(TK_TYPE, TK_INIT)
    ) and langConfig.typeInits.hasKey(TYPE_UNIMPORTED):
      result.add(wrap(TK_TYPE, TK_INIT), langConfig.typeInits[TYPE_UNIMPORTED])

  if not hit and langConfig.types.hasKey(s):
    result.add(
      wrap(TK_TYPE),
      langConfig.types[s]
    )
    if langConfig.typeInits.len() > 0 and langConfig.typeInits.hasKey(s):
      result.add(
        wrap(TK_TYPE, TK_INIT),
        langConfig.typeInits[s]
      )
    else:
      let types: Table[Case, string] = allCases(s, Snake)
      var temp: Table[string, string] = initTable[string, string]()
      for key in types.keys:
        temp.add(
          wrap(TK_TYPE, $key),
          types[key]
        )

      if langConfig.typeInits.hasKey(TYPE_UNIMPORTED):
        result.add(
          wrap(TK_TYPE, TK_INIT),
          langConfig.typeInits[TYPE_UNIMPORTED].replace(temp),
        )
  elif not hit:
    let types: Table[Case, string] = allCases(s, Snake)
    var temp: Table[string, string] = initTable[string, string]()
    for key in types.keys:
      temp.add(
        wrap(TK_TYPE, $key),
        types[key],
      )
    result.add(
      wrap(TK_TYPE),
      langConfig.types[TYPE_UNIMPORTED].replace(temp),
    )

    if langConfig.typeInits.hasKey(TYPE_UNIMPORTED):
      result.add(
        wrap(TK_TYPE, TK_INIT),
        langConfig.typeInits[TYPE_UNIMPORTED].replace(temp),
      )

proc initTemplatable(): Templatable =
  result = Templatable()
  result.replacements = initTable[string, string]()
  result.langBasedReps = initTable[string, Table[string, string]]()
  result.langBasedMultireps = initTable[string, Table[string, HashSet[string]]]()
  result.fields = newSeq[Table[string, string]](0)

proc wingsToTemplatable*(winterface: IWings, tconfig: TConfig): Templatable =
  ## Convert IWings to TConfig.
  result = initTemplatable()
  if winterface.dependencies.len() > 0:
    LOG(
      FATAL,
      "Dependencies is not yet fulfilled for '" &
      winterface.name &
      "' when calling `wingsToTemplatable()`."
    )

  let lang: string = tconfig.filetype

  result.langBasedReps.add(lang, initTable[string, string]())
  result.langBasedReps[lang].add(wrap(TK_FUNCTIONS), "")
  result.langBasedMultireps.add(lang, initTable[string, HashSet[string]]())
  result.replacements.add(wrap(TK_COMMENT), winterface.comment)
  result.replacements.add(wrap(TK_NAME), winterface.name)

  var names: Table[Case, string] = allCases(winterface.name, Snake)
  for key in names.keys:
    result.replacements.add(wrap(TK_NAME, $key), names[key])

  if winterface.imports.hasKey(lang):
    result.langBasedMultireps[lang].add(wrap(TK_IMPORT), winterface.imports[lang])
  else:
    result.langBasedMultireps[lang].add(wrap(TK_IMPORT), initHashSet[string]())

  var i: int = 1
  var words: seq[string] = tFilename(
    winterface.filename,
    winterface.filepath[lang],
  ).split('/')

  for w in words:
    var word: string = w
    if word != "." and word != "..":
      result.langBasedReps[lang].add(wrap($(words.len() - i)), word)
    inc(i)

  case winterface.wingsType
  of WingsType.structw:
    let wstruct: WStruct = WStruct(winterface)
    var implement: string = ""
    if wstruct.implement.hasKey(tconfig.filetype):
      implement = replace(
        tconfig.implementFormat,
        wrap(TK_IMPLEMENT),
        wstruct.implement[tconfig.filetype]
      )

    result.langBasedReps[tconfig.filetype].add(wrap(TK_IMPLEMENT), implement)

    if wstruct.functions.hasKey(lang):
      result.langBasedReps[lang][wrap(TK_FUNCTIONS)] = processFunctions(
        wstruct.functions[lang], tconfig.indentation
      )
    else:
      result.langBasedReps[lang][wrap(TK_FUNCTIONS)] = ""

    for row in wstruct.fields:
      var variables: Table[string, string] = initTable[string, string]()
      let fields: seq[string] = row.splitWhitespace()
      if fields.len() < 2:
        LOG(ERROR, "Row '" & row & "' has less field than expected. Skipping...")

      variables.add(wrap(TK_VARNAME), fields[0])
      var varnames: Table[Case, string] = allCases(fields[0], Snake)
      variables.add(wrap(TK_VARNAME, TK_JSON), varnames[Snake])

      for key in varnames.keys:
        variables.add(wrap(TK_VARNAME, $key), varnames[key])

      variables.merge(
        parseType(fields[1], tConfig, winterface.typesImported.getOrDefault(lang))
      )
      if fields.len() > 2:
        if variables.hasKey(wrap(TK_TYPE, TK_INIT)):
          variables[wrap(TK_TYPE, TK_INIT)] = fields[2]
        else:
          variables.add(wrap(TK_TYPE, TK_INIT), fields[2])
      result.fields.add(variables)
  of WingsType.enumw:
    let wenum: WEnum = WEnum(winterface)
    for field in wenum.values:
      var variables: Table[string, string] = initTable[string, string]()
      variables.add(wrap(TK_VARNAME), field)
      var varnames: Table[Case, string] = allCases(field, Snake)
      variables.add(wrap(TK_VARNAME, TK_JSON), varnames[Snake])
      for key in varnames.keys:
        variables.add(wrap(TK_VARNAME, $key), varnames[key])
      result.fields.add(variables)
  of WingsType.default:
    LOG(FATAL, "Invalid `WingsType`.")
