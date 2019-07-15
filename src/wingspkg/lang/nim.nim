from strutils
import contains, indent, replace, split

proc types(name: string): string =
    var arr: bool = false
    var outType: string = name

    if contains(name, "[]"):
        arr = true
        outType = replace(name, "[]", "")

    case outType
    of "int":
        outType = "int"
    of "str":
        outType = "string"
    of "bool":
        outType = "bool"
    of "date":
        outType = "DateTime"
    else:
        outType = outType

    if arr:
        return "seq[" & outType & "]"
    else:
        return outType

proc enumFile*(
    name: string,
    values: seq[string],
): string =
    var enumFile: string = ""
    enumFile &= "type\n"
    enumFile &= indent(name & "* = enum", 4, " ") & "\n"

    var content: string = ""
    for value in values:
        if value.len() > 0:
            if content.len() > 1:
                content &= "\n"

            content &= value & ","

    enumFile &= indent(content, 8, " ")
    return enumFile

proc structFile*(
    name: string,
    imports: seq[string],
    fields: seq[string],
    functions: string,
): string =
    var structFile: string = ""

    for toImport in imports:
        if toImport.len < 1:
            continue

        structFile &= "import " & toImport & "\n"

    if imports.len() > 0:
        structFile &= "\n"

    structFile &= "type\n"
    structFile &= indent(name & "* = object", 4, " ")

    var declaration = ""

    for fieldStr in fields:
        let field = fieldStr.split(' ')
        if field.len() < 3:
            continue

        if declaration.len() > 1:
            declaration &= "\n"

        declaration &= field[2] & "* : " & types(field[1])

    structFile &= "\n" & indent(declaration, 8, " ")
    structFile &= "\n"

    if functions.len() > 0:
        structFile &= "\n" & functions

    return structFile