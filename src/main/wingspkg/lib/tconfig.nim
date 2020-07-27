from stones/genlib import getResult
from stones/cases import Case
from strutils import contains, endsWith, removePrefix, split, startsWith
import stones/log
import tables
import ./tempconst

const DEFAULT_SEPARATOR*: char = '/'
const DEFAULT_COMMENT*: string = "//"

type
  ImportPathType* = enum
    ## Supported import path types.
    Never = "Never",
    Absolute = "Absolute",
    Relative = "Relative",

type
  ImportPath = object
    format*: string
    pathType*: ImportPathType
    prefix*: string
    separator*: char
    level*: int

type
  TypeInterpreter* = ref object of RootObj
    ## Output type object from given input type.
    wingsType*: string
    targetType*: string
    requiredImport*: string
    targetInit*: string
    targetParse*: string

type
  CustomTypeInterpreter* = ref object of TypeInterpreter
    ## Post processed custom types.
    prefix*: string
    separators*: string
    postfix*: string

type
  Indentation* = object
    spacing*: string
    preIndent*: bool

type
  InterfaceConfig* = object
    interfaceSupported*: bool
    paramFormat*: string
    paramJoiner*: string

type
  TConfig* = object
    ## Object of template config.
    comment*: string
    customTypes*: Table[string, CustomTypeInterpreter]
    filename*: Case
    filetype*: string
    implementFormat*: string
    importPath*: ImportPath
    indentation*: Indentation
    interfaceConfig*: InterfaceConfig
    parseFormat*: string
    templates*: Table[string, string]
    types*: Table[string, TypeInterpreter]

proc initTypeInterpreter*(
  wingsType: string = "",
  targetType: string = "",
  requiredImport: string = "",
  targetInit: string = "",
  targetParse: string = "",
): TypeInterpreter =
  result = TypeInterpreter()
  result.wingsType = wingsType
  result.targetType = targetType
  result.requiredImport = requiredImport
  result.targetInit = targetInit
  result.targetParse = targetParse

proc initCustomTypeInterpreter(
  typeInterpreter: TypeInterpreter = initTypeInterpreter(),
  prefix: string = "",
  separators: string = "",
  postfix: string = "",
): CustomTypeInterpreter =
  result = CustomTypeInterpreter()
  result.wingsType =  typeInterpreter.wingsType
  result.targetType = typeInterpreter.targetType
  result.requiredImport = typeInterpreter.requiredImport
  result.targetInit = typeInterpreter.targetInit
  result.targetParse = typeInterpreter.targetParse
  result.prefix = prefix
  result.separators = separators
  result.postfix = postfix

proc interpretType*(typeInterpreter: TypeInterpreter): CustomTypeInterpreter =
  ## Interpret custom types.
  if not typeInterpreter.wingsType.contains(TYPE_PREFIX):
    LOG(
      ERROR,
      "Types without '" &
      TYPE_PREFIX &
      "' should never be passed into interpretType()"
    )
  result = initCustomTypeInterpreter(typeInterpreter)

  let splittedInput: seq[string] = typeInterpreter.wingsType.split(TYPE_PREFIX)
  if splittedInput.len() == 1:
    if not typeInterpreter.wingsType.startsWith(TYPE_POSTFIX):
      LOG(ERROR, "Types with only 1 external type should use {TYPE} instead of {TYPE#}")

    result.postfix = getResult[string](splittedInput[0], TYPE_POSTFIX, removePrefix)
  elif splittedInput.len() == 2:
    result.prefix = splittedInput[0]
    result.postfix = getResult[string](splittedInput[1], TYPE_POSTFIX, removePrefix)
  else:
    var count: int = 1
    if splittedInput[0].startsWith($count & TYPE_POSTFIX):
      result.separators = getResult[string](
        splittedInput[0],
        $count & TYPE_POSTFIX,
        removePrefix
      )
      inc(count)
    else:
      result.prefix = splittedInput[0]

    while count < splittedInput.len() - 1:
      if result.separators.len() < 1:
        result.separators = getResult[string](
          splittedInput[count],
          $count & TYPE_POSTFIX,
          removePrefix
        )
      elif result.separators != getResult[string](
        splittedInput[count],
        $count & TYPE_POSTFIX,
        removePrefix
      ):
        LOG(FATAL, "Use of multiple different separators is currently unsupported.")
      inc(count)

    result.postfix = getResult[string](
      splittedInput[count],
      $count & TYPE_POSTFIX,
      removePrefix
    )

proc initInterfaceConfig*(
  interfaceSupported: bool = false,
  paramFormat: string = "",
  paramJoiner: string = "",
): InterfaceConfig =
  result = InterfaceConfig()
  result.interfaceSupported = interfaceSupported
  result.paramFormat = paramFormat
  result.paramJoiner = paramJoiner

proc initTConfig*(
  cmt: string = DEFAULT_COMMENT,
  ct: Table[string, CustomTypeInterpreter] = initTable[string, CustomTypeInterpreter](),
  c: Case = Case.Default,
  ft: string = "",
  ifmt: string = "",
  ipfmt: string = "",
  ipt: ImportPathType = ImportPathType.Never,
  pfx: string = "",
  sep: char = DEFAULT_SEPARATOR,
  level: int = 0,
  isp: string = "",
  pi: bool = false,
  isup: bool = false,
  prmFmt: string = "",
  prmJnr: string = "",
  pfmt: string = "",
  temp: Table[string, string] = initTable[string, string](),
  ty: Table[string, TypeInterpreter] = initTable[string, TypeInterpreter](),
): TConfig =
  ## Create an initialized template config.
  result = TConfig()
  result.comment = cmt
  result.customTypes = ct
  result.filename = c
  result.filetype = ft
  result.implementFormat = ifmt
  result.importPath = ImportPath()
  result.importPath.format = ipfmt
  result.importPath.pathType = ipt
  result.importPath.prefix = pfx
  result.importPath.separator = sep
  result.importPath.level = level
  result.indentation = Indentation()
  result.indentation.spacing = isp
  result.indentation.preIndent = pi
  result.interfaceConfig = InterfaceConfig()
  result.interfaceConfig.interfaceSupported = isup
  result.interfaceConfig.paramFormat = prmFmt
  result.interfaceConfig.paramJoiner = prmJnr
  result.parseFormat = pfmt
  result.templates = temp
  result.types = ty
