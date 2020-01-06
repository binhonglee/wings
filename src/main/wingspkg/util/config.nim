from os import fileExists, getCurrentDir, lastPathPart, parentDir
from strutils import join
from stones/cases import setAcronyms
import json
import sets
import tables
import stones/log
import ../lang/defaults, ../lib/tconfig, ../lib/tutil

const DEFAULT_HEADER: string = """
This is a generated file

If you would like to make any changes, please edit the source file instead.
run `wings "{SOURCE_FILE}"` upon completion.
"""

const DEFAULT_OUTPUT_ROOT_DIRS: HashSet[string] = initHashSet[string]()
const DEFAULT_SKIP_IMPORT: bool = false
const DEFAULT_TABBING: int = 4
let CALLER_DIR*: string = getCurrentDir() ## Directory from which `wings` is ran from.

type
  Config* = object
    ## An object that stores user configurations.
    header*: string
    langConfigs*: Table[string, TConfig]
    outputRootDirs*: HashSet[string]
    skipImport*: bool
    tabbing*: int

proc initConfig*(
  header: string = DEFAULT_HEADER,
  langConfigs: Table[string, TConfig] = DEFAULT_CONFIGS,
  outputRootDirs: HashSet[string] = DEFAULT_OUTPUT_ROOT_DIRS,
  skipImport: bool = DEFAULT_SKIP_IMPORT,
  tabbing: int = DEFAULT_TABBING,
): Config =
  ## Create a config to be used.
  result = Config()
  result.header = header
  result.langConfigs = langConfigs
  result.outputRootDirs = outputRootDirs
  result.skipImport = skipImport
  result.tabbing = tabbing

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
    return result

  let jsonConfig: JsonNode = parseFile(filename)

  if jsonConfig.hasKey("acronyms"):
    var userAcronyms: HashSet[string] = initHashSet[string]()
    let acronyms: seq[JsonNode] = jsonConfig["acronyms"].getElems()
    if acronyms.len() > 0:
      for line in acronyms:
        userAcronyms.incl(line.getStr())
    setAcronyms(userAcronyms)
  else:
    LOG(INFO, "'acronyms' is not set. Using default 'acronyms'.")

  if jsonConfig.hasKey("header"):
    var header: seq[string] = newSeq[string](0)
    let headerSeq: seq[JsonNode] = jsonConfig["header"].getElems()

    if headerSeq.len() > 0:
      for line in headerSeq:
        header.add(line.getStr())
    result.header = header.join("\n")
  else:
    LOG(INFO, "'header' is not set. Using default 'header'.")

  if jsonConfig.hasKey("logging"):
    setLevel(AlertLevel(jsonConfig["logging"].getInt(int(SUCCESS))))
  else:
    LOG(INFO, "'logging' is not set. Using default ('DEPRECATED').")

  if jsonConfig.hasKey("outputRootDirs"):
    let outputRootDirs = jsonConfig["outputRootDirs"].getElems()
    for field in outputRootDirs:
      result.outputRootDirs.incl(verifyRootDir(field.getStr("")))
  else:
    result.outputRootDirs.incl("")
    LOG(
      INFO,
      "'outputRootDirs' is not set.\n" &
      "Resuming operation in current directory: " &
      getCurrentDir()
    )

  if jsonConfig.hasKey("skipImport"):
    result.skipImport = jsonConfig["skipImport"].getBool(DEFAULT_SKIP_IMPORT)
    LOG(INFO, "Set 'skipImport' to " & $result.skipImport & ".")
  else:
    LOG(INFO, "'skipImport' is not set. Using default " & $DEFAULT_SKIP_IMPORT & ".")

  if jsonConfig.hasKey("tabbing"):
    result.tabbing = jsonConfig["tabbing"].getInt(DEFAULT_TABBING)
    LOG(INFO, "Set 'tabbing' to " & $result.tabbing & ".")
  else:
    LOG(INFO, "'tabbing' is not set. Using default " & $DEFAULT_TABBING & ".")

  if jsonConfig.hasKey("langConfigs"):
    let langConfigs: seq[JsonNode] = jsonConfig["langConfigs"].getElems()
    for configNode in langConfigs:
      let config: TConfig = tutil.parse(configNode.getStr(""))
      if result.langConfigs.hasKey(config.filetype):
        result.langConfigs[config.filetype] = config
      else:
        result.langConfigs.add(config.filetype, config)

  if jsonConfig.hasKey("prefixes"):
    let prefixFields: OrderedTable[string, JsonNode] = jsonConfig["prefixes"].getFields()
    for field in prefixFields.keys:
      let fieldStr: string = prefixFields[field].getStr("")
      if fieldStr != "" and result.langConfigs.hasKey(field):
        result.langConfigs[field].importPath.prefix = fieldStr
