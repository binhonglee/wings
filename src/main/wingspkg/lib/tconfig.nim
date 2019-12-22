from genlib import getResult
from os import fileExists, lastPathPart, parentDir
from strlib import Case
from strutils import contains, endsWith, removePrefix, split, startsWith
import json
import log
import tables
import ./tconstant

const DEFAULT_SEPARATOR: char = '/'

type
    ImportPathType* = enum
        ## Supported import path types.
        Never = 0,
        Absolute = 1,
        Relative = 2,

type
    ImportPath = object
        format*: string
        pathType*: ImportPathType
        prefix*: string
        separator*: char
        level*: int

type
    TypeInterpreter* = object
        prefix*: string
        separators*: string
        postfix*: string
        output*: string

type
    TConfig* = object
        ## Object of template config.
        customTypes*: Table[string, TypeInterpreter]
        customTypeInits*: Table[string, TypeInterpreter]
        filename*: Case
        filetype*: string
        implementFormat*: string
        importPath*: ImportPath
        templates*: Table[string, string]
        types*: Table[string, string]
        typeInits*: Table[string, string]

proc initTypeInterpreter(
    prefix: string = "",
    separators: string = "",
    postfix: string = "",
    output: string = "",
): TypeInterpreter =
    result = TypeInterpreter()
    result.prefix = prefix
    result.separators = separators
    result.postfix = postfix
    result.output = output

proc interpretType*(inputType: string, outputType: string): TypeInterpreter =
    if not inputType.contains(TYPE_PREFIX):
        LOG(
            ERROR,
            "Types without '" &
            TYPE_PREFIX &
            "' should never be passed into interpretType()"
        )
    result = initTypeInterpreter()

    let splittedInput: seq[string] = inputType.split(TYPE_PREFIX)
    if splittedInput.len() == 1:
        if not inputType.startsWith(TYPE_POSTFIX):
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
    result.output = outputType

proc initTConfig*(
    ct: Table[string, TypeInterpreter] = initTable[string, TypeInterpreter](),
    cti: Table[string, TypeInterpreter] = initTable[string, TypeInterpreter](),
    c: Case = Case.Default,
    ft: string = "",
    ifmt: string = "",
    ipfmt: string = "",
    ipt: ImportPathType = ImportPathType.Never,
    pfx: string = "",
    sep: char = DEFAULT_SEPARATOR,
    level: int = 0,
    temp: Table[string, string] = initTable[string, string](),
    ty: Table[string, string] = initTable[string, string](),
    ti: Table[string, string] = initTable[string, string](),
): TConfig =
    ## Create an initialized template config.
    result = TConfig()
    result.customTypes = ct
    result.customTypeInits = cti
    result.filename = c
    result.filetype = ft
    result.implementFormat = ifmt
    result.importPath = ImportPath()
    result.importPath.format = ipfmt
    result.importPath.pathType = ipt
    result.importPath.prefix = pfx
    result.importPath.separator = sep
    result.importPath.level = level
    result.templates = temp
    result.types = ty
    result.typeInits = ti

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
    LOG(DEBUG, "Parsing file: '" & filename & "'.")
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

    if jsonConfig.hasKey("implementFormat"):
        result.implementFormat = jsonConfig["implementFormat"].getStr("")
    else:
        result.implementFormat = "{#IMPLEMENT}"

    if jsonConfig.hasKey("importPath"):
        let importPath: OrderedTable[string, JsonNode] = jsonConfig["importPath"].getFields()

        let importPathTypeErrMsg: string = "importPath:pathType" & errorMsg
        if importPath.hasKey("pathType"):
            result.importPath.pathType = getImportPathType(
                importPath["pathType"].getStr(""),
                FATAL,
                importPathTypeErrMsg
            )
        else:
            LOG(FATAL, importPathTypeErrMsg)

        try:
            result.importPath.separator = importPath["separator"].getStr($DEFAULT_SEPARATOR)[0]
        except:
            LOG(DEBUG, "Using default separator: '" & $DEFAULT_SEPARATOR & "'.")
            result.importPath.separator = DEFAULT_SEPARATOR

        if result.importPath.pathType != ImportPathType.Never:
            try:
                result.importPath.prefix = importPath["prefix"].getStr("")
            except:
                LOG(DEBUG, "Setting prefix to empty.")
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
                result.templates.add(key, readFile(file))
    else:
        LOG(FATAL, "templates" & errorMsg)

    if jsonConfig.hasKey("types"):
        let types: OrderedTable[string, JsonNode] = jsonConfig["types"].getFields()

        for key in types.keys:
            let givenType: string = types[key].getStr("")
            if givenType != "":
                if key.contains(TYPE_PREFIX):
                    let temp: TypeInterpreter = interpretType(key, givenType)
                    result.customTypes.add(temp.prefix, temp)
                else:
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
