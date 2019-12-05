from strutils import endsWith, join, removePrefix, removeSuffix, split, splitWhitespace, startsWith
from os import fileExists
import sets
import tables
import ../util/log

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

type
    WEnum* = ref object of IWings
        ## A wings enum object.
        values*: seq[string]

type
    WStruct* = ref object of IWings
        ## A wings struct object.
        fields*: seq[string]
        functions*: Table[string, string]

proc initIWings*(): IWings =
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
    result.values = newSeq[string](0)

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

proc addImport(iwings: var IWings, newImport: string, importLang: string): void =
    if not iwings.imports.hasKey(importLang):
        iwings.imports.add(importLang, initHashSet[string]())

    iwings.imports[importLang].incl(newImport)

proc error(line: int, message: string): void =
    LOG(FATAL, "Line " & $line & ": " & message)

proc fulfillDependency*(iwings: var IWings, dependency: string, imports: Table[string, string]): bool =
    ## Fulfill the required dependency (after dependant file is generated).
    if not iwings.dependencies.contains(dependency):
        result = false
    else:
        for importType in imports.keys:
            if importType == "kt":
                continue
            iwings.addImport(imports[importType], importType)

        var location: int = iwings.dependencies.find(dependency)
        iwings.dependencies.delete(location)
        result = true

proc parseWEnum(wenum: var WEnum, words: seq[string]): string =
    if words.len() > 1:
        LOG(FATAL, "Unexpected input: " & join(words, " "))

    if words[0] == "}":
        result = ""
    else:
        wenum.values.add(words[0])
        result = "WObj"

proc parseWStruct(wstruct: var WStruct, words: seq[string]): string =
    if words[0] == "}":
        result = ""
    elif words.len() < 2 or words.len() > 3:
        LOG(FATAL, "Unexpected input: " & join(words, " "))
    else:
        wstruct.fields.add(join(words, " "))
        result = "WObj"

proc parseFunc(wstruct: var WStruct, words: seq[string], line: string, lang: string): string =
    if words.len() > 0 and words[0] == ")":
        result = ""
    else:
        if not wstruct.functions.hasKey(lang):
            wstruct.functions.add(lang, "")
        wstruct.functions[lang] &= "\n" & line
        result = lang

proc parseFileIWings*(
    winterface: var IWings,
    file: File,
    filename: string,
): bool =
    ## Parse the IWings` from the given file.
    LOG(DEBUG, "Parsing " & filename & "...")
    winterface.filename = filename
    var line: string = ""
    var lineNo: int = 1

    while readLine(file, line):
        if line.len() < 1:
            lineNo += 1
            break;

        var words: seq[string] = line.splitWhitespace()
        var filepath: seq[string] = words[0].split('-')

        winterface.filepath.add(filepath[0], words[1])
        lineNo += 1

    var inObj: string = ""
    while readLine(file, line):
        if line.len() < 1:
            lineNo += 1
            continue;

        var words: seq[string] = line.splitWhitespace()

        if (inObj == "" or inObj == "struct" or inObj == "enum") and words[0].startsWith("//"):
            lineNo += 1
            continue

        if inObj != "":
            if winterface of WEnum:
                inObj = parseWEnum(WEnum(winterface), words)
            elif winterface of WStruct:
                if inObj == "WObj":
                    inObj = parseWStruct(WStruct(winterface), words)
                else:
                    inObj = parseFunc(WStruct(winterface), words, line, inObj)
            else:
                error(lineNo, "Unexpected code path! `winterface` should be either a `WEnum` or a `WStruct`.")
        elif words[0].startsWith("#"):
            words[0].removePrefix("#")
            while words[0].startsWith(" "):
                words[0].removePrefix(" ")
            while words[0].len() < 1:
                words.delete(0)
            if words.len() > 0:
                if winterface.comment.len() > 0:
                    winterface.comment &= "\n"
                winterface.comment &= " " & join(words, " ")
        elif words[0].endsWith("-implement"):
            var toImplement: string = words[1]
            words[0].removeSuffix("-implement")
            winterface.implement.add(words[0], toImplement)
        elif words[0].endsWith("-import"):
            var key: string = words[0]
            words.delete(0)
            key.removeSuffix("-import")
            if not winterface.imports.hasKey(key):
                winterface.imports.add(key, initHashSet[string]())
            winterface.imports[key].incl(join(words, " "))
        elif words[0].endsWith("import"):
            if words.len() != 2:
                error(lineNo, "Invalid import file argument.")
            if not fileExists(words[1]):
                error(lineNo, "Could not find import file '" & words[1] & "'.")
            winterface.dependencies.add(words[1])
        elif words.len > 2 and words[2] == "{":
            case words[0]
            of "struct":
                winterface = initWStruct(winterface)
            of "enum":
                winterface = initWEnum(winterface)
            else:
                error(lineNo, "Invalid type \"" & words[0] & "\" defined.")
            winterface.name = words[1]
            inObj = "WObj"
        elif words[0].endsWith("Func("):
            if not (winterface of WStruct):
                error(lineNo, "`{lang}Func()` should only be used when defining a `struct`.")
            words[0].removeSuffix("Func(")
            inObj = words[0]
        else:
            error(lineNo, "Unrecognized syntax \"" & join(words, " ") & "\"")

        lineNo += 1

    result = true

proc parseFile*(
    file: File,
    filename: string,
    skipImport: bool,
): Table[string, IWings] =
    result = initTable[string, IWings]()
    var winterface = initIWings()

    if winterface.parseFileIWings(file, filename):
        result.add(filename, winterface)
        let deps = winterface.dependencies
        for imports in deps:
            winterface = initIWings()
            winterface.imported = skipImport
            let newFile: File = open(imports)
            if winterface.parseFileIWings(newFile, imports):
                result.add(imports, winterface)
            else:
                LOG(FATAL, "Failed to parse '" & imports & "' imported in " & filename & ".")
            newFile.close()
    else:
        LOG(FATAL, "Failed to parse '" & filename & "'.")
