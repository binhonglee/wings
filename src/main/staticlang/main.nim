from os import createDir, getCurrentDir, joinPath, lastPathPart, paramCount,
  paramStr, parentDir, walkFiles
from strutils import indent, removeSuffix, replace
from tables import getOrDefault, hasKey, pairs
import stones/cases
import stones/log
import ../wingspkg/lib/tconfig, ../wingspkg/lib/tutil
import "./const" as c

let OUTPUT_PATH_DIR*: string = joinPath(getCurrentDir(), "src", "main", "wingspkg", "lang")
let INPUT_PATH_DIR*: string = joinPath(getCurrentDir(), "examples", "input", "templates")

var content: string

proc reset(): void =
  content = c.HEADER

proc push(ss: varargs[string]): void =
  for str in ss:
    content &= str
  content &= "\n"

proc args(ss: varargs[string]): string =
  result = ""

  for str in ss:
    result &= "\"" & str & "\", "

  result.removeSuffix(", ")

proc genFile(inputFile: string): void =
  let config = parse(inputFile)
  reset()

  push(c.COMMENT_PRE, config.comment, c.COMMENT_POST)
  push(c.FILENAME, format(Case.Pascal, $config.filename))
  push(c.FILETYPE_PRE, config.filetype, c.FILETYPE_POST)
  push(c.IMPLEMENT_FORMAT_PRE, config.implementFormat, c.IMPLEMENT_FORMAT_POST)
  push(c.IMPORT_PATH_FORMAT_PRE, config.importPath.format, c.IMPORT_PATH_FORMAT_POST)
  push(c.IMPORT_PATH_TYPE, $config.importPath.pathType)
  push(c.IMPORT_PATH_PREFIX_PRE, config.importPath.prefix, c.IMPORT_PATH_PREFIX_POST)
  push(c.IMPORT_PATH_SEPARATOR_PRE, $config.importPath.separator, c.IMPORT_PATH_SEPARATOR_POST)
  push(c.IMPORT_PATH_LEVEL, $config.importPath.level)
  push(c.PARSE_FORMAT_PRE, config.parseFormat, c.PARSE_FORMAT_POST)

  push(c.INTERFACE_SUPPORTED, $config.interfaceConfig.interfaceSupported)
  push(c.PARAM_FORMAT_PRE, config.interfaceConfig.paramFormat, c.PARAM_FORMAT_POST)
  push(c.PARAM_JOINER_PRE, config.interfaceConfig.paramJoiner, c.PARAM_JOINER_POST)

  push(c.PRE_INDENT, $config.indentation.preIndent)
  push(c.INDENTATION_SPACING_PRE, config.indentation.spacing, c.INDENTATION_SPACING_POST)

  push()
  push(c.TEMPLATE_STRUCT_PRE, config.templates.getOrDefault("struct"), c.TEMPLATE_STRUCT_POST)

  push()
  push(c.TEMPLATE_ENUM_PRE, config.templates.getOrDefault("enum"), c.TEMPLATE_ENUM_POST)

  push()
  push(c.TEMPLATE_INTERFACE_PRE, config.templates.getOrDefault("interface"), c.TEMPLATE_INTERFACE_POST)

  push()
  push(c.TEMPLATE_LOGGER_PRE, config.templates.getOrDefault("logger"), c.TEMPLATE_LOGGER_POST)

  push()
  push(c.TYPES_PRE)
  for k, v in config.types.pairs:
    push(
      indent(
        "\"" & k & "\": initTypeInterpreter(" &
        args(
          v.wingsType, v.targetType, v.requiredImport, replace(v.targetInit, "\"", "\\\""), v.targetParse
        ), 2
      ), "),"
    )
  push(c.TYPES_POST)

  push()
  push(c.CUSTOM_TYPES_PRE)
  for k, v in config.customTypes.pairs:
    push(
      indent(
        "\"" & k & "\": interpretType(\n" &
        indent(
          "initTypeInterpreter(" & args(
            v.wingsType,
            v.targetType,
            v.requiredImport,
            replace(v.targetInit, "\"", "\\\""),
            v.targetParse
          ) & ")", 2
        ) & "\n),", 2
      )
    )
  push(c.CUSTOM_TYPES_POST)

  push()
  push(c.CONFIG_PRE, format(Case.Upper, config.filetype), c.CONFIG_POST)

  let outputFile: string = joinPath(OUTPUT_PATH_DIR, format(Case.Lower, config.filetype) & "Config.nim")
  writeFile(outputFile, content)
  LOG(SUCCESS, "Generated " & outputFile & ".")

proc init*(inputPath: string, outputPath: string): void =
  setLevel(INFO)
  if lastPathPart(getCurrentDir()) != "wings":
    LOG(FATAL, "This should only be run from the top level directory `wings/`)")

  createDir(outputPath)
  for file in walkFiles(joinPath(inputPath, "*.json")):
    LOG(INFO, "Generating from " & file & ".")
    genFile(file)

init(INPUT_PATH_DIR, OUTPUT_PATH_DIR)
