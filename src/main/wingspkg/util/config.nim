import json
from os import fileExists, getCurrentDir, lastPathPart, parentDir
from strutils import join
import sets
import tables
import ./log
from ./varname import setAcronyms

const DEFAULT_HEADER: string = """
This is a generated file

If you would like to make any changes, please edit the source file instead.
run `wings "{SOURCE_FILE}"` upon completion.
"""

const DEFAULT_OUTPUT_ROOT_DIRS: HashSet[string] = initHashSet[string]()
const DEFAULT_PREFIXES: Table[string, string] = initTable[string, string]()
const DEFAULT_SKIP_IMPORT: bool = false
const DEFAULT_TABBING: int = 4
let CALLER_DIR*: string = getCurrentDir() ## Directory which `wings` is ran from.

type
    Config* = object
        ## An object that stores user configurations.
        header*: string
        outputRootDirs*: HashSet[string]
        prefixes*: Table[string, string]
        skipImport*: bool
        tabbing*: int

proc initConfig*(
    header: string = DEFAULT_HEADER,
    outputRootDirs: HashSet[string] = DEFAULT_OUTPUT_ROOT_DIRS,
    prefixes: Table[string, string] = DEFAULT_PREFIXES,
    skipImport: bool = DEFAULT_SKIP_IMPORT,
    tabbing: int = DEFAULT_TABBING,
): Config =
    ## Create a config to be used.
    result = Config()
    result.header = header
    result.outputRootDirs = outputRootDirs
    result.prefixes = prefixes
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

    if jsonConfig.hasKey("prefixes"):
        var prefixes: Table[string, string] = initTable[string, string]()
        let prefixFields: OrderedTable[string, JsonNode] = jsonConfig["prefixes"].getFields()
        for field in prefixFields.keys:
            let fieldStr: string = prefixFields[field].getStr("")
            if fieldStr != "":
                prefixes.add(field, fieldStr)
        result.prefixes = prefixes

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
