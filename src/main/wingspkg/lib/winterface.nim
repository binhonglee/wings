from strutils
import endsWith, isEmptyOrWhitespace, join, parseEnum,
  removePrefix, removeSuffix, split, splitWhitespace, startsWith, strip
from os import fileExists
import stones/log
import stones/strlib, stones/genlib
import sets
import tables

type
  WingsType* = enum
    ## Supported wings types
    default = "unknownObj"
    structw = "struct"
    enumw = "enum"
    interfacew = "interface"

type
  Visibility* = enum
    public = "public"
    protected = "protected"
    private = "private"

const COMMENT = "//"

const TYPE_FILEPATH = "filepath"
const TYPE_FUNCTION_OPEN = "func("
const TYPE_FUNCTION_CLOSE = ")"
const TYPE_IMPLEMENT = "implement"
const TYPE_IMPORT = "import"

const WINGS_OPEN = "{"
const WINGS_CLOSE = "}"
const WINGS_COMMENT = "#"
const WINGS_IMPORT = "import"
const WINGS_FUNC = "wings"
const WINGS_FUNC_OPEN = '('
const WINGS_FUNC_CLOSE = ')'

type
  ImportedWingsType* = ref object
    name*: string
    init*: string
    wingsType*: WingsType

type
  AbstractFunction* = object
    visibility*: Visibility
    name*: string
    arguments*: Table[string, string]
      ## key: name, value: type
    returnType*: string
      ## wingsType to be parse

type
  IWings* = ref object of RootObj
    ## A wings object interface.
    comment*: string
    dependencies*: seq[string]
    filename*: string
    filepath*: Table[string, string]
    implement*: Table[string, string]
    imported*: bool
    imports*: Table[string, HashSet[string]]
    name*: string
    typesImported*: Table[string, Table[string, ImportedWingsType]]
    wingsType*: WingsType

type
  WEnum* = ref object of IWings
    ## A wings enum object.
    values*: seq[string]

type
  WStruct* = ref object of IWings
    ## A wings struct object.
    fields*: seq[string]
    functions*: Table[string, string]

type
  WInterface* = ref object of IWings
    fields*: seq[string]
    functions*: Table[string, string]
    abstractFunctions*: Table[string, AbstractFunction]

proc initImportedWingsType*(
  name: string = "",
  init: string = "",
  wingsType: WingsType = WingsType.default
): ImportedWingsType =
  result = ImportedWingsType()
  result.name = name
  result.init = init
  result.wingsType = wingsType

proc initIWings(): IWings =
  ## Returns an empty initialized `IWings`.
  result = IWings()
  result.comment = ""
  result.dependencies = newSeq[string](0)
  result.filename = ""
  result.filepath = initTable[string, string]()
  result.implement = initTable[string, string]()
  result.imports = initTable[string, HashSet[string]]()
  result.imported = false
  result.name = ""
  result.typesImported = initTable[string, Table[string, ImportedWingsType]]()
  result.wingsType = WingsType.default

proc initWEnum(iwings: IWings = initIWings()): WEnum =
  ## Returns an empty initialized `WEnum`.
  result = WEnum()
  result.comment = iwings.comment
  result.dependencies = iwings.dependencies
  result.filename = iwings.filename
  result.filepath = iwings.filepath
  result.implement = iwings.implement
  result.imported = iwings.imported
  result.imports = iwings.imports
  result.name = iwings.name
  result.typesImported = iwings.typesImported
  result.values = newSeq[string](0)
  result.wingsType = WingsType.enumw

proc initWStruct(iwings: IWings = initIWings()): WStruct =
  ## Returns an empty initialized `WStruct`.
  result = WStruct()
  result.comment = iwings.comment
  result.dependencies = iwings.dependencies
  result.fields = newSeq[string](0)
  result.filename = iwings.filename
  result.filepath = iwings.filepath
  result.functions = initTable[string, string]()
  result.implement = iwings.implement
  result.imported = iwings.imported
  result.imports = iwings.imports
  result.name = iwings.name
  result.wingsType = WingsType.structw

proc initWInterface(iwings: IWings = initIWings()): WInterface =
  ## Returns an empty initialized `WEnum`.
  result = WInterface()
  result.abstractFunctions = initTable[string, AbstractFunction]()
  result.comment = iwings.comment
  result.dependencies = iwings.dependencies
  result.fields = newSeq[string](0)
  result.filename = iwings.filename
  result.filepath = iwings.filepath
  result.functions = initTable[string, string]()
  result.implement = iwings.implement
  result.imported = iwings.imported
  result.imports = iwings.imports
  result.name = iwings.name
  result.typesImported = iwings.typesImported
  result.wingsType = WingsType.interfacew

proc initAbstractFunction(
  visibility: Visibility = Visibility.public,
  name: string = "",
  arguments: Table[string, string] = initTable[string, string](),
  returnType: string = "",
): AbstractFunction =
  result = AbstractFunction()
  result.visibility = visibility
  result.name = name
  result.arguments = arguments
  result.returnType = returnType

proc error(line: int, message: string): void =
  LOG(FATAL, "Line " & $line & ": " & message)

proc parseFields(fields: var seq[string], words: seq[string]): string =
  if words[0] == WINGS_CLOSE:
    result = ""
  elif words.len() < 2 or words.len() > 3:
    LOG(FATAL, "Unexpected input: " & join(words, " "))
  else:
    fields.add(join(words, " "))
    result = $WingsType.default

proc parseWInteface(winterface: var WInterface, words: seq[string]): string =
  result = parseFields(winterface.fields, words)

proc parseWEnum(wenum: var WEnum, words: seq[string]): string =
  if words.len() > 1:
    LOG(FATAL, "Unexpected input: " & join(words, " "))

  if words[0] == WINGS_CLOSE:
    result = ""
  else:
    wenum.values.add(words[0])
    result = $WingsType.default

proc parseWStruct(wstruct: var WStruct, words: seq[string]): string =
  result = parseFields(wstruct.fields, words)

proc parseAbstractFunc(
  winterface: var WInterface,
  words: seq[string],
  line: string,
): string =
  if words.len() > 0 and words[0] == TYPE_FUNCTION_CLOSE:
    return ""

  var str: string = getResult(line, trim)
  var i = 0
  var space = false

  while not space and i < str.len():
    if isEmptyOrWhitespace($str[i]) or str[i] == WINGS_FUNC_OPEN:
      space = true
    else:
      inc(i)
  dec(i)

  var visibility: Visibility
  var name: string

  try:
    visibility = parseEnum[Visibility](system.substr(str, 0, i))
  except:
    visibility = Visibility.public
    name = system.substr(str, 0, i)

  strlib.substr(str, i + 1, str.len() - 1)

  if name.len() == 0:
    i = 0
    space = false

    while not space and i < str.len():
      if str[i] != WINGS_FUNC_OPEN:
        inc(i)
      else:
        space = true

    name = system.substr(str, 0, i - 1).strip()
    strlib.substr(str, i, str.len() - 1)

  var strs = strlib.split(str, WINGS_FUNC_OPEN, WINGS_FUNC_CLOSE, " ")
  if strs.len() < 2:
    error(0, "Missing return type for the wings-func().")
  elif strs.len() > 2:
    error(0, "Unexpected characters at the end of the line for the wings-func().")

  str = system.substr(strs[0], 1, strs[0].len() - 2)
  var paramTable = initTable[string, string]()

  if str.len() > 0:
    let params = split(str, ",")

    for param in params:
      let ss = split(param, ":")
      if ss.len() < 2:
        echo ss
        error(0, "Missing type declaration in `" & param & "`.")
      elif ss.len() > 2:
        error(0, "Unexpected characters in `" & param & "`.")
      
      if paramTable.hasKey(ss[0]):
        error(0, "Parameter name `" & ss[0] & "` already declared previously.")
      
      paramTable.add(strip(ss[0]), strip(ss[1]))

  winterface.abstractFunctions.add(
    name,
    initAbstractFunction(visibility, name, paramTable, strs[1])
  )
  result = WINGS_FUNC

proc parseFunc(
  functions: var Table[string, string],
  words: seq[string],
  line: string,
  lang: string
): string =
  if words.len() > 0 and words[0] == TYPE_FUNCTION_CLOSE:
    result = ""
  else:
    if not functions.hasKey(lang):
      functions.add(lang, "")
    functions[lang] &= "\n" & line
    result = lang

proc parseFileIWings(
  iwings: var IWings,
  filename: string,
): bool =
  ## Parse the `IWings` from the given file.
  LOG(DEBUG, "Parsing " & filename & "...")
  iwings.filename = filename
  var line: string = ""
  var lineNo: int = 1
  var inObj: string = ""

  let file: File = open(filename)
  while readLine(file, line):
    var words: seq[string] = line.splitWhitespace()

    if (
      inObj == "" or
      inObj == $WingsType.structw or
      inObj == $WingsType.enumw
    ) and (
      line.len() < 1 or
      words[0].startsWith(COMMENT)
    ):
      inc(lineNo)
      continue

    if inObj != "":
      if iwings of WEnum:
        inObj = parseWEnum(WEnum(iwings), words)
      elif iwings of WStruct:
        if inObj == $WingsType.default:
          inObj = parseWStruct(WStruct(iwings), words)
        else:
          inObj = parseFunc(WStruct(iwings).functions, words, line, inObj)
      elif iwings of WInterface:
        if inObj == $WingsType.default:
          inObj = parseWInteface(WInterface(iwings), words)
        elif inObj == WINGS_FUNC:
          inObj = parseAbstractFunc(WInterface(iwings), words, line)
        else:
          inObj = parseFunc(WInterface(iwings).functions, words, line, inObj)
      else:
        error(
          lineNo,
          "Unexpected code path! `iwings` should be either `" &
          $WingsType.structw & "`, `" &
          $WingsType.enumw & "`, or `" &
          $WingsType.interfacew & "`."
        )
      continue

    case words[0]
    of WINGS_COMMENT:
      words.delete(0)
      if words.len() > 0:
        if iwings.comment.len() > 0:
          iwings.comment &= "\n"
        iwings.comment &= join(words, " ")
    of WINGS_IMPORT:
      if words.len() != 2:
        error(lineNo, "Invalid import file argument.")
      if not fileExists(words[1]):
        error(lineNo, "Could not find import file '" & words[1] & "'.")
      iwings.dependencies.add(words[1])
    elif words.len > 2 and words[2] == WINGS_OPEN:
      case words[0]
      of $WingsType.structw:
        iwings = initWStruct(iwings)
      of $WingsType.enumw:
        iwings = initWEnum(iwings)
      of $WingsType.interfacew:
        iwings = initWInterface(iwings)
      else:
        error(
          lineNo,
          "Invalid type \"" & words[0] &
          "\", '" & $WingsType.structw &
          "' defined."
        )
      iwings.name = words[1]
      inObj = $WingsType.default
    else:
      let ss: seq[string] = words[0].split('-')
      if ss.len() != 2:
        error(lineNo, "Unsupported syntax '" & words[0] & "'.")
      words.delete(0)

      case ss[1]
      of TYPE_FILEPATH:
        iwings.filepath.add(ss[0], words[0])
      of TYPE_IMPLEMENT:
        iwings.implement.add(ss[0], words[0])
      of TYPE_IMPORT:
        if not iwings.imports.hasKey(ss[0]):
          iwings.imports.add(ss[0], initHashSet[string]())
        iwings.imports[ss[0]].incl(join(words, " "))
      of TYPE_FUNCTION_OPEN:
        if not (iwings of WStruct or iwings of WInterface):
          error(lineNo, "`{lang}Func()` should only be used when defining a `struct` or an `interface`.")
        inObj = ss[0]
      else:
        if words[1] == WINGS_OPEN:
          error(lineNo, "Use of \"{NAME} {\" is no longer supported.")
        error(lineNo, "Unrecognized syntax \"" & join(ss, " ") & "\"")

    inc(lineNo)

  file.close()
  result = true

proc parseFile*(
  filename: string,
  skipImport: bool,
): Table[string, IWings] =
  ## Parse the given file (and its dependencies) into a table of filename to `IWings`.
  result = initTable[string, IWings]()
  var iwings = initIWings()

  if iwings.parseFileIWings(filename):
    result.add(filename, iwings)
    let deps = iwings.dependencies
    for imports in deps:
      iwings = initIWings()
      iwings.imported = skipImport
      if iwings.parseFileIWings(imports):
        result.add(imports, iwings)
      else:
        LOG(FATAL, "Failed to parse '" & imports & "' imported in " & filename & ".")
  else:
    LOG(FATAL, "Failed to parse '" & filename & "'.")

proc addImport*(iwings: var IWings, newImport: string, importLang: string): void =
  ## Add new file / library to be imported by the IWings.
  if not iwings.imports.hasKey(importLang):
    iwings.imports.add(importLang, initHashSet[string]())
  iwings.imports[importLang].incl(newImport)
