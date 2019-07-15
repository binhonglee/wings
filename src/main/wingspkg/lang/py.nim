from strutils
import capitalizeAscii, contains, indent, replace, split

proc types(name: string): string =
    if contains(name, "[]"):
        return "list"

    case name
    of "int":
        return "int"
    of "str":
        return "str"
    of "bool":
        return "bool"
    of "date":
        return "date"
    else:
        return name

proc typeInit(name: string): string =
    if contains(name, "[]"):
        return "list()"

    case name
    of "int":
        return "-1"
    of "str":
        return "\"\""
    of "bool":
        return "False"
    of "date":
        return "date.today()"
    else:
        return name & "()"

proc enumFile*(
    name: string,
    values: seq[string],
): string =
    var enumFile: string = ""
    enumFile &= "from enum import Enum, auto\n\n"
    enumFile &= "class " & name & "(Enum):\n"

    var content = ""
    for value in values:
        if value.len() > 0:
            if content.len() > 0:
                content &= "\n"
            content &= value & " = auto()"

    enumFile &= indent(content, 4, " ")

    return enumFile & "\n"

proc structFile*(
    name: string,
    imports: seq[string],
    fields: seq[string],
    functions: string,
    implement: string,
): string =
    var structFile: string = "import json\n"

    for toImport in imports:
        if toImport.len() < 1:
            continue

        var importDat: seq[string] = toImport.split(':')
        if importDat.len < 2:
            structFile &= "import " & toImport & "\n"
        else:
            structFile &=  "from " & importDat[0] & " import " & importDat[1] & "\n"

    if imports.len() > 0:
        structFile &= "\n"

    structFile &= "class " & name & "("
    if implement.len() < 1:
        structFile &= "object"
    else:
        structFile &= implement
    structFile &= "):\n"

    var declaration: string = ""
    for fieldStr in fields:
        var field = fieldStr.split(' ')
        if field.len() > 2:
            if declaration.len() > 1:
                declaration &= "\n"

            var varInit: string = typeInit(field[1])
            if field.len() > 3:
                varInit = field[3]
                if field[1] == "bool":
                    varInit = capitalizeAscii(varInit)
            declaration &= field[2] & ": " & types(field[1]) & " = " & varInit

    structFile &= indent(declaration, 4, " ") & "\n"
    structFile &= indent(
        "\ndef init(self, data):\n" &
        indent("self = json.loads(data)", 4, " "), 4, " "
    )

    if functions.len() > 0:
        structFile &= "\n" & functions & "\n"

    return structFile