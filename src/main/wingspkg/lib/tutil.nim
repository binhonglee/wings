from os import fileExists, lastPathPart, parentDir
from stones/cases import Case
from strutils import contains, endsWith, removePrefix, replace, split, startsWith
import json
import stones/log
import tables
import ./tconfig, ./tempconst

const CMT = "comment"
const FN = "filename"
const FT = "filetype"
const I_FMT = "implementFormat"
const I_P = "importPath"
const FMT = "format"
const P_TY = "pathType"
const SEP = "separator"
const PFX = "prefix"
const LEVEL = "level"
const IND = "indentation"
const SP = "spacing"
const P_I = "preIndent"
const P_FMT = "parseFormat"
const TEMP = "templates"
const TY = "types"
const W_T = "wingsType"
const T_T = "targetType"
const R_I = "requiredImport"
const T_I = "targetInit"
const T_P = "targetParse"

const parseFMT = "{P_FMT}"

proc getCase(
  input: string,
  logLevel: AlertLevel = ERROR,
  errorMsg: string = "Given input is not a supported case."
): Case =
  case input
  of "default":
    result = Default
  of "camel":
    result = Camel
  of "kebab":
    result = Kebab
  of "lower":
    result = Lower
  of "pascal":
    result = Pascal
  of "snake":
    result = Snake
  of "upper":
    result = Upper
  else:
    LOG(logLevel, errorMsg)

proc getImportPathType(
  input: string,
  logLevel: AlertLevel = FATAL,
  errorMsg: string = "Given input is not a supported import path type."
): ImportPathType =
  case input
  of "never":
    result = ImportPathType.Never
  of "absolute":
    result = ImportPathType.Absolute
  of "relative":
    result = ImportPathType.Relative
  else:
    LOG(logLevel, errorMsg)

proc parse*(filename: string): TConfig =
  ## Parse template config file into `TConfig`.
  LOG(DEBUG, "Parsing file: '" & filename & "'.")
  result = initTConfig()
  if not fileExists(filename):
    LOG(FATAL, "Template config file not found: " & filename)

  let jsonConfig: JsonNode = parseFile(filename)
  let errorMsg: string = " is not found or invalid."

  if jsonConfig.hasKey(CMT):
    result.comment = jsonConfig[CMT].getStr(DEFAULT_COMMENT)
  else:
    result.comment = DEFAULT_COMMENT

  let filenameErrMsg: string = FN & errorMsg
  if jsonConfig.hasKey(FN):
    result.filename = getCase(jsonConfig[FN].getStr(""), FATAL, filenameErrMsg)
  else:
    LOG(FATAL, filenameErrMsg)

  let filetypeErrMsg: string = FT & errorMsg
  if jsonConfig.hasKey(FT):
    let filetype: string = jsonConfig[FT].getStr("")
    if filename.len() < 1:
      LOG(FATAL, filetypeErrMsg)
    result.filetype = filetype
  else:
    LOG(FATAL, filetypeErrMsg)

  if jsonConfig.hasKey(I_FMT):
    result.implementFormat = jsonConfig[I_FMT].getStr("")
  else:
    result.implementFormat = wrap(TK_IMPLEMENT)

  if jsonConfig.hasKey(I_P):
    let importPath: OrderedTable[string, JsonNode] = jsonConfig[I_P].getFields()

    if importPath.hasKey(FMT):
      result.importPath.format = importPath[FMT].getStr("")

    let importPathTypeErrMsg: string = I_P & ":" & P_TY & errorMsg
    if importPath.hasKey(P_TY):
      result.importPath.pathType = getImportPathType(
        importPath[P_TY].getStr(""),
        FATAL,
        importPathTypeErrMsg
      )
    else:
      LOG(FATAL, importPathTypeErrMsg)

    try:
      result.importPath.separator = importPath[SEP].getStr($DEFAULT_SEPARATOR)[0]
    except:
      LOG(DEBUG, "Using default separator: '" & $DEFAULT_SEPARATOR & "'.")
      result.importPath.separator = DEFAULT_SEPARATOR

    if result.importPath.pathType != ImportPathType.Never:
      try:
        result.importPath.prefix = importPath[PFX].getStr("")
      except:
        LOG(DEBUG, "Setting " & PFX & " to empty.")
        result.importPath.prefix = ""

      try:
        let pathLevel: int = importPath[LEVEL].getInt(-1)
        if pathLevel < 0:
          LOG(FATAL, I_P & ":" & LEVEL & errorMsg)
        else:
          result.importPath.level = pathLevel
      except:
        LOG(FATAL, I_P & ":" & LEVEL & errorMsg)
  else:
    LOG(FATAL, I_P & errorMsg)

  if jsonConfig.hasKey(IND):
    let ind: OrderedTable[string, JsonNode] = jsonConfig[IND].getFields()

    if ind.hasKey(SP):
      result.indentation.spacing = ind[SP].getStr("")
    if ind.hasKey(P_I):
      result.indentation.preIndent = ind[P_I].getBool(false)

  if jsonConfig.hasKey(P_FMT):
    result.parseFormat = jsonConfig[P_FMT].getStr("")

  if jsonConfig.haskey(TEMP):
    let templates: OrderedTable[string, JsonNode] = jsonConfig[TEMP].getFields()
    for key in templates.keys:
      let file: string = templates[key].getStr("")

      if not fileExists(file):
        LOG(FATAL, "'" & file & "' referenced in '" & filename & "' does not exists.")

      if file != "":
        result.templates.add(key, readFile(file))
  else:
    LOG(FATAL, TEMP & errorMsg)

  if jsonConfig.hasKey(TY):
    let types: seq[JsonNode] = jsonConfig[TY].getElems()
    if types.len < 1:
      LOG(FATAL, TY & errorMsg)

    for t in types:
      var wingsType: string
      var targetType: string
      var requiredImport: string
      var targetInit: string
      var targetParse: string

      if t.hasKey(W_T):
        wingsType = t[W_T].getStr("")
      else:
        wingsType = ""

      if t.hasKey(T_T):
        targetType = t[T_T].getStr("")
      else:
        targetType = ""

      if t.hasKey(R_I):
        requiredImport = t[R_I].getStr("")
      else:
        requiredImport = ""

      if t.hasKey(T_I):
        targetInit = t[T_I].getStr("")
      else:
        targetInit = ""

      if t.hasKey(T_P):
        targetParse = t[T_P].getStr("")
        targetParse = targetParse.replace(parseFMT, result.parseFormat)
      else:
        targetParse = result.parseFormat

      if wingsType.len() < 1 or targetType.len() < 1:
        LOG(FATAL,  W_T & " or " & T_T & errorMsg)

      let typeInterpreter: TypeInterpreter = initTypeInterpreter(
        wingsType, targetType, requiredImport, targetInit, targetParse,
      )

      if wingsType.contains(TYPE_PREFIX):
        let temp: CustomTypeInterpreter = interpretType(typeInterpreter)
        result.customTypes.add(temp.prefix, temp)
      else:
        result.types.add(typeInterpreter.wingsType, typeInterpreter)
  else:
    LOG(FATAL, TY & errorMsg)
