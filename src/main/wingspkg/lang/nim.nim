from strutils
import contains, indent, replace, split

proc types(name: string): string =
    var arr: bool = false
    result = name

    if contains(name, "[]"):
        arr = true
        result = replace(name, "[]", "")

    case result
    of "int":
        result = "int"
    of "str":
        result = "string"
    of "bool":
        result = "bool"
    of "date":
        result = "DateTime"

    if arr:
        result = "seq[" & result & "]"

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
    result = ""

    for toImport in imports:
        if toImport.len < 1:
            continue

        result &= "import " & toImport & "\n"

    if imports.len() > 0:
        result &= "\n"

    result &= "type\n"
    result &= indent(name & "* = object", 4, " ")

    var declaration = ""

    for fieldStr in fields:
        let field = fieldStr.split(' ')
        if field.len() < 3:
            continue

        if declaration.len() > 1:
            declaration &= "\n"

        declaration &= field[2] & "* : " & types(field[1])

    result &= "\n" & indent(declaration, 8, " ")
    result &= "\n"

    if functions.len() > 0:
        result &= "\n" & functions
