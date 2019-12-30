from strutils
import endsWith, join, removePrefix, removeSuffix,
    split, splitWhitespace, startsWith
from os import fileExists
import log
import sets
import tables

type
    WingsType* = enum
        ## Supported wings types
        default = "unknownObj"
        structw = "struct"
        enumw = "enum"

const COMMENT = "//"

const TYPE_FILEPATH = "filepath"
const TYPE_FUNCTION_OPEN = "func("
const TYPE_FUNCTION_CLOSE = ")"
const TYPE_IMPLEMENT = "implement"
const TYPE_IMPORT = "import"

const WINGS_OPEN = "{"
const WINGS_CLOSE = "}"
const WINGS_COMMENT = "#"
const WINGS_IMPORT = "import"

type
    ImportedWingsType* = ref object
        name*: string
        init*: string

type
    IWings* = ref object of RootObj
        ## A wings object interface.
        comment*: string
        dependencies*: seq[string]
        filename*: string
        filepath*: Table[string, string]
        implement*: Table[string, string]
        imported*: bool
        imports*: Table[string, HashSet[string]]
        name*: string
        typesImported*: Table[string, Table[string, ImportedWingsType]]
        wingsType*: WingsType

type
    WEnum* = ref object of IWings
        ## A wings enum object.
        values*: seq[string]

type
    WStruct* = ref object of IWings
        ## A wings struct object.
        fields*: seq[string]
        functions*: Table[string, string]

proc initImportedWingsType*(name: string = "", init: string = ""): ImportedWingsType =
    result = ImportedWingsType()
    result.name = name
    result.init = init

proc initIWings(): IWings =
    ## Returns an empty initialized `IWings`.
    result = IWings()
    result.comment = ""
    result.dependencies = newSeq[string](0)
    result.filename = ""
    result.filepath = initTable[string, string]()
    result.implement = initTable[string, string]()
    result.imports = initTable[string, HashSet[string]]()
    result.imported = false
    result.name = ""
    result.typesImported = initTable[string, Table[string, ImportedWingsType]]()
    result.wingsType = WingsType.default

proc initWEnum(winterface: IWings = initIWings()): WEnum =
    ## Returns an empty initialized `WEnum`.
    result = WEnum()
    result.comment = winterface.comment
    result.dependencies = winterface.dependencies
    result.filename = winterface.filename
    result.filepath = winterface.filepath
    result.implement = winterface.implement
    result.imported = winterface.imported
    result.imports = winterface.imports
    result.name = winterface.name
    result.typesImported = winterface.typesImported
    result.values = newSeq[string](0)
    result.wingsType = WingsType.enumw

proc initWStruct(winterface: IWings = initIWings()): WStruct =
    ## Returns an empty initialized `WStruct`.
    result = WStruct()
    result.comment = winterface.comment
    result.dependencies = winterface.dependencies
    result.fields = newSeq[string](0)
    result.filename = winterface.filename
    result.filepath = winterface.filepath
    result.functions = initTable[string, string]()
    result.implement = winterface.implement
    result.imported = winterface.imported
    result.imports = winterface.imports
    result.name = winterface.name
    result.wingsType = WingsType.structw

proc error(line: int, message: string): void =
    LOG(FATAL, "Line " & $line & ": " & message)

proc parseWEnum(wenum: var WEnum, words: seq[string]): string =
    if words.len() > 1:
        LOG(FATAL, "Unexpected input: " & join(words, " "))

    if words[0] == WINGS_CLOSE:
        result = ""
    else:
        wenum.values.add(words[0])
        result = $WingsType.default

proc parseWStruct(wstruct: var WStruct, words: seq[string]): string =
    if words[0] == WINGS_CLOSE:
        result = ""
    elif words.len() < 2 or words.len() > 3:
        LOG(FATAL, "Unexpected input: " & join(words, " "))
    else:
        wstruct.fields.add(join(words, " "))
        result = $WingsType.default

proc parseFunc(
    wstruct: var WStruct,
    words: seq[string],
    line: string,
    lang: string
): string =
    if words.len() > 0 and words[0] == TYPE_FUNCTION_CLOSE:
        result = ""
    else:
        if not wstruct.functions.hasKey(lang):
            wstruct.functions.add(lang, "")
        wstruct.functions[lang] &= "\n" & line
        result = lang

proc parseFileIWings(
    winterface: var IWings,
    filename: string,
): bool =
    ## Parse the `IWings` from the given file.
    LOG(DEBUG, "Parsing " & filename & "...")
    winterface.filename = filename
    var line: string = ""
    var lineNo: int = 1
    var inObj: string = ""

    let file: File = open(filename)
    while readLine(file, line):
        var words: seq[string] = line.splitWhitespace()

        if (
            inObj == "" or
            inObj == $WingsType.structw or
            inObj == $WingsType.enumw
        ) and (
            line.len() < 1 or
            words[0].startsWith(COMMENT)
        ):
            inc(lineNo)
            continue

        if inObj != "":
            if winterface of WEnum:
                inObj = parseWEnum(WEnum(winterface), words)
            elif winterface of WStruct:
                if inObj == $WingsType.default:
                    inObj = parseWStruct(WStruct(winterface), words)
                else:
                    inObj = parseFunc(WStruct(winterface), words, line, inObj)
            else:
                error(
                    lineNo,
                    "Unexpected code path! `winterface` should be either a `" &
                    $WingsType.structw & "` or a `" &
                    $WingsType.enumw & "`."
                )
            continue

        case words[0]
        of WINGS_COMMENT:
            words.delete(0)
            if words.len() > 0:
                if winterface.comment.len() > 0:
                    winterface.comment &= "\n"
                winterface.comment &= join(words, " ")
        of WINGS_IMPORT:
            if words.len() != 2:
                error(lineNo, "Invalid import file argument.")
            if not fileExists(words[1]):
                error(lineNo, "Could not find import file '" & words[1] & "'.")
            winterface.dependencies.add(words[1])
        elif words.len > 2 and words[2] == WINGS_OPEN:
            case words[0]
            of $WingsType.structw:
                winterface = initWStruct(winterface)
            of $WingsType.enumw:
                winterface = initWEnum(winterface)
            else:
                error(
                    lineNo,
                    "Invalid type \"" & words[0] &
                    "\", '" & $WingsType.structw &
                    "' defined."
                )
            winterface.name = words[1]
            inObj = $WingsType.default
        else:
            let ss: seq[string] = words[0].split('-')
            if ss.len() != 2:
                error(lineNo, "Unsupported syntax '" & words[0] & "'.")

            case ss[1]
            of TYPE_FILEPATH:
                winterface.filepath.add(ss[0], words[1])
            of TYPE_IMPLEMENT:
                winterface.implement.add(ss[0], words[1])
            of TYPE_IMPORT:
                if not winterface.imports.hasKey(ss[0]):
                    winterface.imports.add(ss[0], initHashSet[string]())
                winterface.imports[ss[0]].incl(join(words, " "))
            of TYPE_FUNCTION_OPEN:
                if not (winterface of WStruct):
                    error(lineNo, "`{lang}Func()` should only be used when defining a `struct`.")
                inObj = ss[0]
            else:
                if words[1] == WINGS_OPEN:
                    error(lineNo, "Use of \"{NAME} {\" is no longer supported.")
                error(lineNo, "Unrecognized syntax \"" & join(words, " ") & "\"")

        inc(lineNo)

    file.close()
    result = true

proc parseFile*(
    filename: string,
    skipImport: bool,
): Table[string, IWings] =
    ## Parse the given file (and its dependencies) into a table of filename to `IWings`.
    result = initTable[string, IWings]()
    var winterface = initIWings()

    if winterface.parseFileIWings(filename):
        result.add(filename, winterface)
        let deps = winterface.dependencies
        for imports in deps:
            winterface = initIWings()
            winterface.imported = skipImport
            if winterface.parseFileIWings(imports):
                result.add(imports, winterface)
            else:
                LOG(FATAL, "Failed to parse '" & imports & "' imported in " & filename & ".")
    else:
        LOG(FATAL, "Failed to parse '" & filename & "'.")
