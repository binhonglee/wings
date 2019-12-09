from strutils
import alignLeft, capitalizeAscii, contains, endsWith, indent,
    removePrefix, removeSuffix, split, startsWith, toLowerAscii, unindent
import sets
from tables import getOrDefault
from ../util/varname import pascalCase, maxWidth
import ../util/config, ../util/log
import ../lib/winterface

proc types(
    imports: var HashSet[string],
    name: string,
    customTypes: HashSet[string] = initHashSet[string]()
): string =
    result = name
    var newCustoms: HashSet[string] = customTypes

    if newCustoms.len() < 1:
        for givenImport in imports:
            let importDat: seq[string] = givenImport.split(':')

            if importDat.len() == 2:
                newCustoms.incl(importDat[0])

    if startsWith(result, "Map<") and endsWith(result, ">"):
        result.removePrefix("Map<")
        result.removeSuffix(">")
        var mapTypes: seq[string] = result.split(",")
        if mapTypes.len() != 2:
            LOG(FATAL, "Invalid map types: " & name & ".")
        else:
            result = "map[" &
                imports.types(mapTypes[0]) &
                "]" & imports.types(mapTypes[1], newCustoms)
    elif startsWith(result, "[]"):
        result.removePrefix("[]")
        result = "[]" & imports.types(result)
    else:
        case result
        of "int":
            result = "int"
        of "str":
            result = "string"
        of "bool":
            result = "bool"
        of "date":
            imports.incl("time")
            result = "time.Time"
        else:
            var prefix = ""
            if newCustoms.contains(toLowerAscii(result)):
                prefix = toLowerAscii(result) & "."
            result = prefix & result

proc wEnumFile(
    name: string,
    values: seq[string],
    package: string,
    config: Config
): string =
    result = "package " & package & "\n\n"
    result &= "type " & name & " int\n\n"
    result &= "const ("
    var count: int = 0
    var content: string = ""

    for value in values:
        if value.len() < 1:
            continue
        var iota: string = ""
        if count == 0:
            iota = " = iota"
            count = 1

        content &= "\n" & value & iota

    result &= indent(content, config.tabbing, " ") & "\n)\n"

proc wStructFile(
    name: string,
    imports: HashSet[string],
    fields: seq[string],
    functions: string,
    comment: string,
    package: string,
    config: Config,
): string =
    result = "package " & package & "\n"
    var mutImports = imports
    var fieldDec: seq[string] = newSeq[string](0)

    for fieldStr in fields:
        let field = fieldStr.split(' ')
        if field.len() > 1:
            fieldDec.add(pascalCase(field[0]) & " " &
                mutImports.types(field[1]) & " `json:\"" & field[0] & "\"`")

    let width: seq[int] = maxWidth(fieldDec)
    var fieldStr: string = ""

    for row in fieldDec:
        if fieldStr.len() > 0:
            fieldStr &= "\n"
        let words: seq[string] = row.split(' ')
        fieldStr &= alignLeft(words[0], width[0] + config.tabbing) &
            alignLeft(words[1], width[1] + config.tabbing) & words[2]

    var importDec = ""
    if mutImports.len() > 0:
        for toImport in mutImports:
            if toImport.len < 1:
                continue

            var importDat: seq[string] = toImport.split(':')

            if importDat.len < 2:
                importDec &= "\n\"" & toImport & "\""
            else:
                importDec &=  "\n" & importDat[0] &
                    " \"" & importDat[1] & "\""
        result &= "\nimport (" & indent(importDec, config.tabbing, " ") & "\n)\n"

    if comment.len() > 0:
        result &= "\n" & indent(comment, 2, "/")

    result &= "\ntype " & name & " struct {\n" &
        indent(fieldStr, config.tabbing, " ") & "\n}\n"

    if functions.len() > 0:
        var tabbing = "\n"
        while functions.startsWith(tabbing):
            tabbing &= " "
        result &= unindent(functions, tabbing.len() - 2, " ") & "\n"

    result &= "\n" & indent(" " & name & "s - An array of " & name, 2, "/")
    result &= "\ntype " & name & "s []" & name

proc genWEnum*(wenum: WEnum, config: Config): string =
    var tempPackage: seq[string] = split(wenum.filepath.getOrDefault("go"), '/')
    result = wEnumFile(wenum.name, wenum.values, tempPackage[tempPackage.len() - 1], config)

proc genWStruct*(wstruct: WStruct, config: Config): string =
    var tempPackage: seq[string] = split(wstruct.filepath.getOrDefault("go"), '/')

    result = wStructFile(
        wstruct.name, wstruct.imports.getOrDefault("go"),
        wstruct.fields, wstruct.functions.getOrDefault("go"),
        wstruct.comment, tempPackage[tempPackage.len() - 1], config,
    )
