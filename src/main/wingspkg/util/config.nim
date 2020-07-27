from os import fileExists, getCurrentDir, lastPathPart, parentDir
from strutils import join
from stones/cases import setAcronyms
import json
import sets
import tables
import stones/log
import ../lang/defaults, ../lib/tconfig, ../lib/tutil

# Expected fields
const ACRONYMS: string = "acronyms"
const HEADER: string = "header"
const LANG_CONFIGS: string = "langConfigs"
const LANG_FILTER: string = "langFilter"
const LOGGING: string = "logging"
const OUTPUT_ROOT_DIRS: string = "outputRootDirs"
const PREFIXES: string = "prefixes"
const SKIP_IMPORT: string = "skipImport"

# Defaults
const DEFAULT_HEADER: string = """
This is a generated file

If you would like to make any changes, please edit the source file instead.
run `wings "{SOURCE_FILE}"` upon completion.
"""

const DEFAULT_OUTPUT_ROOT_DIRS: HashSet[string] = toHashSet([""])
const DEFAULT_SKIP_IMPORT: bool = false

let CALLER_DIR*: string = getCurrentDir() ## Directory from which `wings` is ran from.

type
  Config* = object
    ## An object that stores user configurations.
    header*: string
    langConfigs*: Table[string, TConfig]
    outputRootDirs*: HashSet[string]
    skipImport*: bool

proc initConfig*(
  header: string = DEFAULT_HEADER,
  langConfigs: Table[string, TConfig] = DEFAULT_CONFIGS,
  outputRootDirs: HashSet[string] = DEFAULT_OUTPUT_ROOT_DIRS,
  skipImport: bool = DEFAULT_SKIP_IMPORT,
): Config =
  ## Create a config to be used.
  result = Config()
  result.header = header
  result.langConfigs = langConfigs
  result.outputRootDirs = outputRootDirs
  result.skipImport = skipImport

proc verifyRootDir(outputRootDir: string): string =
  result = getCurrentDir()
  if outputRootDir.len() > 0:
    while lastPathPart(result) != outputRootDir:
      result = parentDir(result)
      if result == "":
        LOG(FATAL, "Directory named '" & outputRootDir & "' not found.")

proc parse*(filename: string): Config =
  ## Parse the given config file in the path.
  result = initConfig()
  if not fileExists(filename):
    LOG(ERROR, "Cannot find " & filename & ". Using default config instead.")
    return result

  let jsonConfig: JsonNode = parseFile(filename)

  if jsonConfig.hasKey(ACRONYMS):
    var userAcronyms: HashSet[string] = initHashSet[string]()
    let acronyms: seq[JsonNode] = jsonConfig[ACRONYMS].getElems()
    if acronyms.len() > 0:
      for line in acronyms:
        userAcronyms.incl(line.getStr())
    setAcronyms(userAcronyms)
  else:
    LOG(INFO, "'" & ACRONYMS & "' is not set. Using default '" & ACRONYMS & "'.")

  if jsonConfig.hasKey(HEADER):
    var header: seq[string] = newSeq[string](0)
    let headerSeq: seq[JsonNode] = jsonConfig[HEADER].getElems()

    if headerSeq.len() > 0:
      for line in headerSeq:
        header.add(line.getStr())
    result.header = header.join("\n")
  else:
    LOG(INFO, "'" & HEADER & "' is not set. Using default '" & HEADER & "'.")

  if jsonConfig.hasKey(LOGGING):
    setLevel(AlertLevel(jsonConfig[LOGGING].getInt(int(DEPRECATED))))
  else:
    LOG(INFO, "'" & LOGGING & "' is not set. Using default ('DEPRECATED').")

  if jsonConfig.hasKey(OUTPUT_ROOT_DIRS):
    let outputRootDirs = jsonConfig[OUTPUT_ROOT_DIRS].getElems()
    for field in outputRootDirs:
      result.outputRootDirs.incl(verifyRootDir(field.getStr("")))
  else:
    result.outputRootDirs.incl("")
    LOG(
      INFO,
      "'" & OUTPUT_ROOT_DIRS & "' is not set.\n" &
      "Resuming operation in current directory: " &
      getCurrentDir()
    )

  if jsonConfig.hasKey(SKIP_IMPORT):
    result.skipImport = jsonConfig[SKIP_IMPORT].getBool(DEFAULT_SKIP_IMPORT)
    LOG(INFO, "Set '" & SKIP_IMPORT & "' to " & $result.skipImport & ".")
  else:
    LOG(INFO, "'" & SKIP_IMPORT & "' is not set. Using default " & $DEFAULT_SKIP_IMPORT & ".")

  if jsonConfig.hasKey(LANG_CONFIGS):
    let langConfigs: seq[JsonNode] = jsonConfig[LANG_CONFIGS].getElems()
    for configNode in langConfigs:
      let config: TConfig = tutil.parse(configNode.getStr(""))
      if result.langConfigs.hasKey(config.filetype):
        result.langConfigs[config.filetype] = config
      else:
        result.langConfigs.add(config.filetype, config)

  if jsonConfig.hasKey(LANG_FILTER):
    let langFilter: seq[JsonNode] = jsonConfig[LANG_FILTER].getElems()
    var filters: HashSet[string] = initHashSet[string]()
    for lang in langFilter:
      filters.incl(lang.getStr(""))

    if langFilter.len() > 0:
      for lang in result.langConfigs.keys:
        if not filters.contains(lang):
          result.langConfigs.del(lang)

  if jsonConfig.hasKey(PREFIXES):
    let prefixFields: OrderedTable[string, JsonNode] = jsonConfig[PREFIXES].getFields()
    for field in prefixFields.keys:
      let fieldStr: string = prefixFields[field].getStr("")
      if fieldStr != "" and result.langConfigs.hasKey(field):
        result.langConfigs[field].importPath.prefix = fieldStr
