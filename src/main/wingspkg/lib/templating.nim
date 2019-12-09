from sequtils import toSeq
from strutils import contains, parseInt, removePrefix, replace, split, splitWhitespace, startsWith, strip
import streams
import sets
import tables
import ./tconfig, ./winterface
import ../util/log, ../util/varname, ../util/tableutil

type
    Templatable* = object
        replacements*: Table[string, string]
        fields*: seq[Table[string, string]]
        langBasedReps*: Table[string, Table[string, string]]
        langBasedMultireps*: Table[string, Table[string, HashSet[string]]]
        langBasedFields*: Table[string, seq[Table[string, string]]]

proc rows(format: string, replacements: seq[Table[string, string]]): string =
    result = ""
    for rep in replacements:
        if result.len() > 0:
            result &= "\n"
        result &= seqCharToString(toSeq(format.items).replace(rep))

proc multiRow(keyword: string, inputs: seq[Table[string, string]], givenTemplate: string): string =
    result = ""
    let format: string = givenTemplate.replace("// #" & keyword & " ", "")
    result = rows(format, inputs)

proc multiWords(keyword: string, inputs: HashSet[string], givenTemplate: string): string =
    result = ""
    var brokenDownInput: Table[int, seq[Table[string, string]]] = initTable[int, seq[Table[string, string]]]()
    for input in inputs:
        let temp: seq[string] = input.split(':')
        if not brokenDownInput.hasKey(temp.len()):
            brokenDownInput.add(temp.len(), newSeq[Table[string, string]](0))
        var words: Table[string, string] = initTable[string, string]()
        var i: int = 1
        for str in temp:
            words.add("{#" & keyword & "_" & $i & "}", str)
            inc(i)
        brokenDownInput[temp.len()].add(words)

    var templateTypes: seq[string] = givenTemplate.split('\n')
    for templateType in templateTypes:
        if not templateType.contains("// #" & keyword):
            continue

        var count: int = 0
        try:
            count = parseInt($(templateType.replace("// #" & keyword, "").strip()[0]))
        except:
            LOG(DEBUG, "'" & keyword & "' only have 1 version.")

        if not brokenDownInput.hasKey(count):
            continue

        let row: string = templateType.replace("// #" & keyword & $count & " ", "")
        if result.len() > 0:
            result &= "\n"
        result &= rows(row, brokenDownInput[count])

proc genFile*(templatable: Templatable, tconfig: TConfig, wingsType: WingsType): string =
    if not templatable.langBasedReps.hasKey(tconfig.filetype):
        LOG(FATAL, "`genFile()` should only be called on templatable containing that language type.")

    if not tconfig.templates.hasKey($wingsType):
        LOG(FATAL, "No template found for the given type and language.")

    var givenTemplate: StringStream = newStringStream(readFile(tconfig.templates[$wingsType]))

    result = ""
    var line: string = ""
    var lineNo: int = 1
    while givenTemplate.readLine(line):
        if not line.contains("// #"):
            result &= "\n" & line
        elif line.startsWith("// #BEGIN_"):
            var keyword = line
            keyword.removePrefix("// #BEGIN_")
            var prefix: string = ""
            while givenTemplate.readLine(line) and not line.contains("// #" & keyword) and not line.startsWith("// #END_" & keyword):
                if prefix.len() > 0:
                    prefix &= "\n"
                prefix &= line
                inc(lineNo)
            var templateText: string = ""
            if not line.startsWith("// #END_" & keyword):
                templateText = line
                while givenTemplate.readLine(line) and line.contains("// #" & keyword) and not line.startsWith("// #END_" & keyword):
                    if templateText.len() > 0:
                        templateText &= "\n"
                    templateText &= line
                    inc(lineNo)
            var postfix: string = ""
            if not line.startsWith("// #END_" & keyword):
                postfix = line
                while givenTemplate.readLine(line) and not line.startsWith("// #END_" & keyword):
                    if postfix.len() > 0:
                        postfix &= "\n"
                    postfix &= line
                    inc(lineNo)

            var output: string = ""
            if templatable.langBasedReps[tconfig.filetype].hasKey("{#" & keyword & "}"):
                output = multiRow(
                    keyword,
                    @[templatable.langBasedReps[tconfig.filetype]],
                    templateText
                )
            elif templatable.langBasedMultireps[tconfig.filetype].hasKey("{#" & keyword & "}"):
                output = multiWords(
                    keyword,
                    templatable.langBasedMultireps[tconfig.filetype]["{#" & keyword & "}"],
                    templateText
                )
            else:
                output = multiRow(keyword, templatable.fields, templateText)

            if output.len() > 0:
                result &= prefix & "\n" & output & "\n" & postfix
        else:
            LOG(ERROR, "Multiline declarations should have `// #BEGIN_{KEYWORD}` and `// #END_{KEYWORD}` declarations")

        inc(lineNo)
    var reps: Table[string, string] = templatable.replacements
    reps = merge(reps, templatable.langBasedReps[tconfig.filetype])
    result = seqCharToString(toSeq(result.items).replace(reps))

proc initTemplatable(): Templatable =
    result = Templatable()
    result.replacements = initTable[string, string]()
    result.langBasedReps = initTable[string, Table[string, string]]()
    result.langBasedMultireps = initTable[string, Table[string, HashSet[string]]]()
    result.fields = newSeq[Table[string, string]](0)

proc wingsToTemplatable*(winterface: IWings, tconfig: TConfig): Templatable =
    result = initTemplatable()
    if winterface.dependencies.len() > 0:
        LOG(FATAL, "Dependencies is not yet fulfilled for '" & winterface.name & "' when calling `wingsToTemplatable()`.")

    # TODO: Multithread this
    for lang in winterface.filepath.keys:
        result.langBasedReps.add(lang, initTable[string, string]())
        result.langBasedReps[lang].add("{#FUNCTIONS}", "")
        result.langBasedMultireps.add(lang, initTable[string, HashSet[string]]())

    result.replacements.add("{#COMMENT}", winterface.comment)

    result.replacements.add("{#NAME}", winterface.name)
    var names: Table[Case, string] = allCases(winterface.name)
    for key in names.keys:
        result.replacements.add("{#NAME_" & $key & "}", names[key])

    result.replacements.add("{#FILENAME}", winterface.filename)
    names = allCases(winterface.filename)
    for key in names.keys:
        result.replacements.add("{#FILENAME_" & $key & "}", names[key])

    for lang in winterface.imports.keys:
        if not result.langBasedReps.hasKey(lang):
            LOG(ERROR, "'" & lang & "-import' is defined but '" & lang & "-filepath' is missing.")
        else:
            result.langBasedMultireps[lang].add("{#IMPORT}", winterface.imports[lang])

    for lang in winterface.implement.keys:
        if not result.langBasedReps.hasKey(lang):
            LOG(ERROR, "'" & lang & "-implement' is defined but '" & lang & "-filepath' is missing.")
        else:
            result.langBasedReps[lang].add("{#IMPLEMENT}", winterface.implement[lang])

    case winterface.wingsType
    of WingsType.structw:
        let wstruct: WStruct = WStruct(winterface)
        for lang in wstruct.functions.keys:
            if not result.langBasedReps.hasKey(lang) or not result.langBasedReps[lang].hasKey("{#FUNCTIONS}"):
                LOG(ERROR, "'" & lang & "Func()' is defined but '" & lang & "-filepath' is missing.")
            else:
                result.langBasedReps[lang]["{#FUNCTIONS}"] = wstruct.functions[lang]

        for row in wstruct.fields:
            var variables: Table[string, string] = initTable[string, string]()
            let fields: seq[string] = row.splitWhitespace()
            if fields.len() < 2:
                LOG(ERROR, "Row '" & row & "' has less field than expected. Skipping...")

            variables.add("{#VARNAME}", fields[0])
            var varnames: Table[Case, string] = allCases(fields[0])
            variables.add("{#VARNAME_JSON}", varnames[Case.Snake])
            for key in varnames.keys:
                variables.add("{#VARNAME_" & $key & "}", varnames[key])

            if not tconfig.types.hasKey(fields[1]):
                LOG(ERROR, "Unsupported type: " & fields[1])
            else:
                variables.add("{#TYPE}", tconfig.types[fields[1]])
                if tconfig.typeInits.len() > 0 and tconfig.typeInits.hasKey(fields[1]):
                    variables.add("{#TYPE_INIT}", tconfig.typeInits[fields[1]])

            result.fields.add(variables)
    of WingsType.enumw:
        let wenum: WEnum = WEnum(winterface)
        for field in wenum.values:
            var variables: Table[string, string] = initTable[string, string]()
            variables.add("{#VARNAME}", field)
            var varnames: Table[Case, string] = allCases(field)
            variables.add("{#VARNAME_JSON}", varnames[Case.Snake])
            for key in varnames.keys:
                variables.add("{#VARNAME_" & $key & "}", varnames[key])
            result.fields.add(variables)
    of WingsType.default:
        LOG(FATAL, "Invalid `WingsType`.")
