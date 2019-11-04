from strutils
import capitalizeAscii, contains, endsWith, indent, normalize,
    removePrefix, removeSuffix, replace, split, startsWith
import sets
from tables import getOrDefault
from ../lib/varname import camelCase
import ../lib/wstruct, ../lib/wenum

proc types(imports: var HashSet[string], name: string): string =
    result = name

    if result.startsWith("Map<") and result.endsWith(">"):
        result.removePrefix("Map<")
        result.removeSuffix(">")
        var typeToProcess: seq[string] = result.split(",")
        if typeToProcess.len() != 2:
            echo "Invalid map types."
            result = ""
        else:
            imports.incl("tables")
            result = "Table[" & types(imports, typeToProcess[0]) &
                ", " & types(imports, typeToProcess[1]) & "]"
    elif result.startsWith("[]"):
        result.removePrefix("[]")
        result = "seq[" & types(imports, result) & "]"
    else:
        case result
        of "int":
            result = "int"
        of "float":
            result = "float"
        of "str":
            result = "string"
        of "bool":
            result = "bool"
        of "date":
            imports.incl("times")
            result = "DateTime"

proc typeAssign(name: string, content: string): string =
    if contains(name, "[]") or (startsWith(name, "Map<") and endsWith(name, ">")):
        return "jsonOutput[\"" & content &
            "\"].getElems()"

    case name
    of "bool", "float", "int", "str":
        result = "jsonOutput[\"" & content &
            "\"].get" & capitalizeAscii(name) & "()"
    of "date":
        # TODO: Parse ISOString time properly
        result = "now()"
    else:
        result = "new" & capitalizeAscii(name) &
                "(" & typeAssign("str", content) & ")"

proc wEnumFile(
    name: string,
    values: seq[string],
): string =
    result = "type\n"
    result &= indent(name & "* = enum", 4, " ") & "\n"

    var content: string = ""
    for value in values:
        if value.len() > 0:
            if content.len() > 1:
                content &= "\n"

            content &= value & ","

    result &= indent(content, 8, " ")

proc wStructFile(
    name: string,
    imports: HashSet[string],
    fields: seq[string],
    functions: string,
    comment: string,
    implement: string,
): string =
    result = "import json\n"
    var mutImports = imports

    var declaration = ""
    var parse = ""

    for fieldStr in fields:
        let field = fieldStr.split(' ')
        if field.len() < 2:
            continue

        if declaration.len() > 1:
            declaration &= "\n"
            parse &= "\n"

        declaration &= camelCase(field[0]) & "* : " & mutImports.types(field[1])
        parse &= normalize(name) & "." & camelCase(field[0]) &
                " = " & typeAssign(field[1], field[0])

    for toImport in mutImports:
        if toImport.len < 1:
            continue

        result &= "import " & toImport & "\n"

    if comment.len() > 0:
        result &= "\n" & indent(comment, 1, "#")

    if imports.len() > 0:
        result &= "\n"
    result &= "type\n"

    var objStr = "* = object"
    if implement.len() > 0:
        objStr = "* = ref object of " & implement

    result &= indent(name & objStr, 4, " ")
    result &= "\n" & indent(declaration, 8, " ") & "\n\n"

    result &= "proc parse*(" & normalize(name) &
            ": var " & name & ", data: string): void =\n"
    result &= indent("let jsonOutput = parseJson(data)\n\n" & parse, 4, " ")

    if functions.len() > 0:
        result &= "\n" & functions

proc genWEnum*(wenum: WEnum): string =
    result = wEnumFile(wenum.name, wenum.values)

proc genWStruct*(wstruct: WStruct): string =
    result = wStructFile(
        wstruct.name, wstruct.imports.getOrDefault("nim"),
        wstruct.fields, wstruct.functions.getOrDefault("nim"),
        wstruct.comment, wstruct.implement.getOrDefault("nim"),
    )
