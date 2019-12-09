import json
from os import fileExists, lastPathPart, parentDir
import tables
import ../util/log
from ../util/varname import Case

type
    ImportPathType* = enum
        ## Supported import path types.
        Never = 0,
        Absolute = 1,
        Relative = 2,

type
    ImportPath* = object
        pathType*: ImportPathType
        prefix*: string
        level*: int

type
    TConfig* = object
        ## Object of template config.
        filename*: Case
        filetype*: string
        importPath*: ImportPath
        templates*: Table[string, string]
        types*: Table[string, string]
        typeInits*: Table[string, string]

proc initTConfig(): TConfig =
    ## Create an initialized template config.
    result = TConfig()
    result.filename = Case.Default
    result.importPath = ImportPath()
    result.importPath.pathType = ImportPathType.Never
    result.importPath.prefix = ""
    result.importPath.level = 0
    result.templates = initTable[string, string]()
    result.types = initTable[string, string]()
    result.typeInits = initTable[string, string]()

proc getCase(
    input: string,
    logLevel: AlertLevel = ERROR,
    errorMsg: string = "Given input is not a supported case."
): Case =
    case input
    of "default":
        result = Case.Default
    of "camel":
        result = Case.Camel
    of "kebab":
        result = Case.Kebab
    of "lower":
        result = Case.Lower
    of "pascal":
        result = Case.Pascal
    of "snake":
        result = Case.Snake
    of "upper":
        result = Case.Upper
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
    result = initTConfig()
    if not fileExists(filename):
        LOG(FATAL, "Template config file not found: " & filename)

    let jsonConfig: JsonNode = parseFile(filename)
    let errorMsg: string = " is not found or invalid."

    let filenameErrMsg: string = "filename" & errorMsg
    if jsonConfig.hasKey("filename"):
        result.filename = getCase(jsonConfig["filename"].getStr(""), FATAL, filenameErrMsg)
    else:
        LOG(FATAL, filenameErrMsg)

    let filetypeErrMsg: string = "filetype" & errorMsg
    if jsonConfig.hasKey("filetype"):
        let filetype: string = jsonConfig["filetype"].getStr("")
        if filename.len() < 1:
            LOG(FATAL, filetypeErrMsg)
        result.filetype = filetype
    else:
        LOG(FATAL, filetypeErrMsg)

    if jsonConfig.hasKey("importPath"):
        let importPath: OrderedTable[string, JsonNode] = jsonConfig["importPath"].getFields()

        let importPathTypeErrMsg: string = "importPath:pathType" & errorMsg
        if importPath.contains("pathType"):
            result.importPath.pathType = getImportPathType(
                importPath["pathType"].getStr(""),
                FATAL,
                importPathTypeErrMsg
            )
        else:
            LOG(FATAL, importPathTypeErrMsg)

        if result.importPath.pathType != ImportPathType.Never:
            try:
                result.importPath.prefix = importPath["prefix"].getStr("")
            except:
                result.importPath.prefix = ""

            try:
                let pathLevel: int = importPath["level"].getInt(-1)
                if pathLevel < 0:
                    LOG(FATAL, "importPath:level" & errorMsg)
                else:
                    result.importPath.level = pathLevel
            except:
                LOG(FATAL, "importPath:level" & errorMsg)
    else:
        LOG(FATAL, "importPath" & errorMsg)

    if jsonConfig.haskey("templates"):
        let templates: OrderedTable[string, JsonNode] = jsonConfig["templates"].getFields()
        for key in templates.keys:
            let file: string = templates[key].getStr("")

            if not fileExists(file):
                LOG(FATAL, "'" & file & "' referenced in '" & filename & "' does not exists.")

            if file != "":
                result.templates.add(key, file)
    else:
        LOG(FATAL, "templates" & errorMsg)

    if jsonConfig.hasKey("types"):
        let types: OrderedTable[string, JsonNode] = jsonConfig["types"].getFields()

        for key in types.keys:
            let givenType: string = types[key].getStr("")
            if givenType != "":
                result.types.add(key, givenType)
            else:
                LOG(ERROR, "Failed to read counterpart type for '" & key & "'. Skipping...")
    else:
        LOG(FATAL, "types" & errorMsg)


    if jsonConfig.hasKey("init"):
        let init: OrderedTable[string, JsonNode] = jsonConfig["init"].getFields()

        for key in init.keys:
            let givenInit: string = init[key].getStr("")
            if givenInit != "":
                result.typeInits.add(key, givenInit)
            else:
                LOG(ERROR, "Failed to read counterpart type for '" & key & "'. Skipping...")
    else:
        LOG(DEBUG, "init" & errorMsg)
