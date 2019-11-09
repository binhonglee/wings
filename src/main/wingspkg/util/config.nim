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
run `nimble genFile "{SOURCE_FILE}"` upon completion.
"""

const DEFAULT_PREFIXES: Table[string, string] = initTable[string, string]()
const DEFAULT_TABBING: int = 4
let CALLER_DIR*: string = getCurrentDir()

type
    Config* = object
        header*: string
        prefixes*: Table[string, string]
        tabbing*: int
        outputRootDirs*: HashSet[string]

proc newConfig*(
    header: string = DEFAULT_HEADER,
    prefixes: Table[string, string] = DEFAULT_PREFIXES,
    tabbing: int = DEFAULT_TABBING,
    outputRootDirs: HashSet[string] = initHashSet[string]()
): Config =
    result = Config()
    result.header = header
    result.prefixes = prefixes
    result.tabbing = tabbing
    result.outputRootDirs = outputRootDirs

proc verifyRootDir(outputRootDir: string): string =
    result = getCurrentDir()
    if outputRootDir.len() > 0:
        while lastPathPart(result) != outputRootDir:
            result = parentDir(result)
            if result == "":
                LOG(FATAL, "Directory named '" & outputRootDir & "' not found.")

proc parse*(filename: string): Config =
    result = newConfig()
    if not fileExists(filename):
        return result

    var jsonConfig: JsonNode = parseFile(filename)
    if jsonConfig.hasKey("logging"):
        setLevel(AlertLevel(jsonConfig["logging"].getInt(int(SUCCESS))))
    else:
        # This should never be shown lol
        LOG(INFO, "'logging' is not set. Using default ('DEPRECATED').")

    if jsonConfig.hasKey("header"):
        var header: seq[string] = newSeq[string](0)
        let headerSeq: seq[JsonNode] = jsonConfig["header"].getElems()

        if headerSeq.len() > 0:
            for line in headerSeq:
                header.add(line.getStr())
        result.header = header.join("\n")
    else:
        LOG(INFO, "'header' is not set. Using default 'header'.")

    if jsonConfig.hasKey("prefixes"):
        var prefixes: Table[string, string] = initTable[string, string]()
        let prefixFields: OrderedTable[string, JsonNode] = jsonConfig["prefixes"].getFields()
        for field in prefixFields.keys:
            let fieldStr: string = prefixFields[field].getStr("")
            if fieldStr != "":
                prefixes.add(field, fieldStr)
        result.prefixes = prefixes

    if jsonConfig.hasKey("acronyms"):
        var userAcronyms: seq[string] = newSeq[string](0)
        var acronyms: seq[JsonNode] = jsonConfig["acronyms"].getElems()
        if acronyms.len() > 0:
            for line in acronyms:
                userAcronyms.add(line.getStr())
        setAcronyms(userAcronyms)
    else:
        LOG(INFO, "'acronyms' is not set. Using default 'acronyms'.")

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

    if jsonConfig.hasKey("tabbing"):
        result.tabbing = jsonConfig["tabbing"].getInt(DEFAULT_TABBING)
        LOG(INFO, "Set tabbing indentation to " & $result.tabbing)
    else:
        LOG(INFO, "'tabbing' is not set. Using default '4'.")
