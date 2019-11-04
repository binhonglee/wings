import json
from os import fileExists
from strutils import join
import tables

const DEFAULT_HEADER: string = """
This is a generated file

If you would like to make any changes, please edit the source file instead.
run `nimble genFile "{SOURCE_FILE}"` upon completion.
"""

const DEFAULT_PREFIXES: Table[string, string] = initTable[string, string]()
const DEFAULT_TABBING: int = 4
const DEFAULT_LOGGING_LEVEL: int = 0

type
    Config* = object
        header*: string
        prefixes*: Table[string, string]
        tabbing*: int
        logging*: int

proc newConfig*(
    header: string = DEFAULT_HEADER,
    prefixes: Table[string, string] = DEFAULT_PREFIXES,
    tabbing: int = DEFAULT_TABBING,
    logging: int = DEFAULT_LOGGING_LEVEL,
): Config =
    result = Config()
    result.header = header
    result.prefixes = prefixes
    result.tabbing = tabbing
    result.logging = logging

proc parse*(filename: string): Config =
    result = newConfig()
    if not fileExists(filename):
        return result

    var jsonConfig: JsonNode = parseFile(filename)
    if jsonConfig.hasKey("logging"):
        result.logging = jsonConfig["logging"].getInt(DEFAULT_LOGGING_LEVEL)

    if jsonConfig.hasKey("header"):
        var header: seq[string] = newSeq[string](0)
        let headerSeq: seq[JsonNode] = jsonConfig["header"].getElems()

        if headerSeq.len() > 0:
            for line in headerSeq:
                header.add(line.getStr())
            result.header = header.join("\n")

    if jsonConfig.hasKey("prefixes"):
        var prefixes: Table[string, string] = initTable[string, string]()
        let prefixFields: OrderedTable[string, JsonNode] = jsonConfig["prefixes"].getFields()
        for field in prefixFields.keys:
            let fieldStr: string = prefixFields[field].getStr("")
            if fieldStr != "":
                prefixes.add(field, fieldStr)
        result.prefixes = prefixes

    if jsonConfig.hasKey("tabbing"):
        if result.logging > 1:
            echo "The \"tabbing\" field can be set but is not yet configured to be respected."
        result.tabbing = jsonConfig["tabbing"].getInt(DEFAULT_TABBING)
