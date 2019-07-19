from strutils
import capitalizeAscii, contains, indent, normalize, replace, split
from ../lib/varname import camelCase

proc types(name: string): string =
    var arr: bool = false
    result = name

    if contains(name, "[]"):
        arr = true
        result = replace(name, "[]", "")

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
        result = "DateTime"

    if arr:
        result = "seq[" & result & "]"

proc typeAssign(name: string, content: string): string =
    if contains(name, "[]"):
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

proc enumFile*(
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

proc structFile*(
    name: string,
    imports: seq[string],
    fields: seq[string],
    functions: string,
): string =
    result = "import json\n"

    for toImport in imports:
        if toImport.len < 1:
            continue

        result &= "import " & toImport & "\n"

    if imports.len() > 0:
        result &= "\n"

    result &= "type\n"
    result &= indent(name & "* = object", 4, " ")

    var declaration = ""
    var parse = ""

    for fieldStr in fields:
        let field = fieldStr.split(' ')
        if field.len() < 2:
            continue

        if declaration.len() > 1:
            declaration &= "\n"
            parse &= "\n"

        declaration &= camelCase(field[0]) & "* : " & types(field[1])
        parse &= normalize(name) & "." & camelCase(field[0]) &
                " = " & typeAssign(field[1], field[0])

    result &= "\n" & indent(declaration, 8, " ") & "\n\n"

    result &= "proc parse*(" & normalize(name) &
            ": var " & name & ", data: string): void =\n"
    result &= indent("let jsonOutput = parseJson(data)\n\n" & parse, 4, " ")

    if functions.len() > 0:
        result &= "\n" & functions
