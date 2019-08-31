from strutils
import capitalizeAscii, contains, indent, replace, split
from tables import getOrDefault
import ../lib/wstruct, ../lib/wenum

proc types(name: string): string =
    if contains(name, "[]"):
        return "list"

    case name
    of "int":
        result = "int"
    of "float":
        result = "float"
    of "str":
        result = "str"
    of "bool":
        result = "bool"
    of "date":
        result = "date"
    else:
        result = name

proc typeInit(name: string): string =
    if contains(name, "[]"):
        return "list()"

    case name
    of "int":
        result = "-1"
    of "float":
        result = "-0.1"
    of "str":
        result = "\"\""
    of "bool":
        result = "False"
    of "date":
        result = "date.today()"
    else:
        result = name & "()"

proc wEnumFile(
    name: string,
    values: seq[string],
): string =
    result = "from enum import Enum, auto\n\n"
    result &= "class " & name & "(Enum):\n"

    var content = ""
    for value in values:
        if value.len() > 0:
            if content.len() > 0:
                content &= "\n"
            content &= value & " = auto()"

    result &= indent(content, 4, " ")

proc wStructFile(
    name: string,
    imports: seq[string],
    fields: seq[string],
    functions: string,
    comment: string,
    implement: string,
): string =
    result = "import json\n"

    for toImport in imports:
        if toImport.len() < 1:
            continue

        var importDat: seq[string] = toImport.split(':')
        if importDat.len < 2:
            result &= "import " & toImport & "\n"
        else:
            result &=  "from " & importDat[0] & " import " & importDat[1] & "\n"

    if comment.len() > 0:
        result &= "\n" & indent(comment, 1, "#")

    if imports.len() > 0:
        result &= "\n"

    result &= "class " & name & "("
    if implement.len() < 1:
        result &= "object"
    else:
        result &= implement
    result &= "):\n"

    var declaration: string = ""
    for fieldStr in fields:
        var field = fieldStr.split(' ')
        if field.len() > 1:
            if declaration.len() > 1:
                declaration &= "\n"

            var varInit: string = typeInit(field[1])
            if field.len() > 2:
                varInit = field[2]
                if field[1] == "bool":
                    varInit = capitalizeAscii(varInit)
            declaration &= field[0] & ": " & types(field[1]) & " = " & varInit

    result &= indent(declaration, 4, " ") & "\n"
    result &= indent(
        "\ndef init(self, data):\n" &
        indent("self = json.loads(data)", 4, " "), 4, " "
    )

    if functions.len() > 0:
        result &= "\n" & functions & "\n"

proc genWStruct*(wstruct: WStruct): string =
    result = wStructFile(
        wstruct.name, wstruct.imports.getOrDefault("py"),
        wstruct.fields, wstruct.functions.getOrDefault("py"),
        wstruct.comment, wstruct.implement.getOrDefault("py"),
    )

proc genWEnum*(wenum: WEnum): string =
    result = wEnumFile(wenum.name, wenum.values)
