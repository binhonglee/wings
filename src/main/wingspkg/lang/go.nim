from strutils
import capitalizeAscii, contains, endsWith, indent, removePrefix,
    removeSuffix, replace, split, startsWith, toLowerAscii, unindent
import sets
from tables import getOrDefault
from ../lib/varname import camelCase
import ../lib/wstruct, ../lib/wenum

proc types(imports: var HashSet[string], name: string): string =
    result = name

    if startsWith(result, "Map<") and endsWith(result, ">"):
        result.removePrefix("Map<")
        result.removeSuffix(">")
        var mapTypes: seq[string] = result.split(",")
        if mapTypes.len() != 2:
            echo "Invalid map type: " & name
            result = ""
        else:
            result = "map[" & imports.types(mapTypes[0]) & "]" & imports.types(mapTypes[1])
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
            result = toLowerAscii(result) & "." & result

proc wEnumFile(
    name: string,
    values: seq[string],
    package: string,
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

    result &= indent(content, 4, " ") & "\n)\n"

proc wStructFile(
    name: string,
    imports: HashSet[string],
    fields: seq[string],
    functions: string,
    comment: string,
    package: string,
): string =
    result = "package " & package & "\n"
    var mutImports = imports
    var fieldDec: string = ""

    for fieldStr in fields:
        var field = fieldStr.split(' ')
        if field.len() > 1:
            if fieldDec.len() > 1:
                fieldDec &= "\n"
            fieldDec &= capitalizeAscii(camelCase(field[0])) & " " &
                mutImports.types(field[1]) & " `json:\"" & field[0] & "\"`"

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
        result &= "\nimport (" & indent(importDec, 4, " ") & "\n)\n"

    if comment.len() > 0:
        result &= "\n" & indent(comment, 2, "/")

    result &= "\ntype " & name & " struct {\n" &
        indent(fieldDec, 4, " ") & "\n}\n"

    if functions.len() > 0:
        result &= unindent(functions, 4, " ") & "\n"

    result &= "\ntype " & name & "s []" & name

proc genWEnum*(wenum: WEnum): string =
    var tempPackage: seq[string] = split(wenum.filepath.getOrDefault("go"), '/')
    result = wEnumFile(wenum.name, wenum.values, tempPackage[tempPackage.len() - 1])

proc genWStruct*(wstruct: WStruct): string =
    var tempPackage: seq[string] = split(wstruct.filepath.getOrDefault("go"), '/')

    result = wStructFile(
        wstruct.name, wstruct.imports.getOrDefault("go"),
        wstruct.fields, wstruct.functions.getOrDefault("go"),
        wstruct.comment, tempPackage[tempPackage.len() - 1],
    )
