from strutils
import capitalizeAscii, endsWith, indent, replace, startsWith, split, unindent
import sets
from tables import getOrDefault
import ../util/config
import ../lib/winterface

proc types(imports: var HashSet[string], name: string): string =
    if name.startsWith("[]"):
        result = "list"
    elif name.startsWith("Map<") and name.endsWith(">"):
        result = "dict"
    else:
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
            imports.incl("datetime:date")
            result = "date"
        else:
            result = name

proc typeInit(name: string): string =
    if name.startsWith("[]"):
        result = "list()"
    elif name.startsWith("Map<") and name.endsWith(">"):
        result = "{}"
    else:
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
    config: Config,
): string =
    result = "from enum import Enum, auto\n\n"
    result &= "class " & name & "(Enum):\n"

    var content = ""
    for value in values:
        if value.len() > 0:
            if content.len() > 0:
                content &= "\n"
            content &= value & " = auto()"

    result &= indent(content, config.tabbing, " ")

proc wStructFile(
    name: string,
    imports: HashSet[string],
    fields: seq[string],
    functions: string,
    comment: string,
    implement: string,
    config: Config,
): string =
    result = "import json\n"
    var mutImports = imports

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
            declaration &= field[0] & ": " & mutImports.types(field[1]) & " = " & varInit

    for toImport in mutImports:
        if toImport.len() < 1:
            continue

        var importDat: seq[string] = toImport.split(':')
        if importDat.len < 2:
            result &= "import " & toImport & "\n"
        else:
            result &=  "from " & importDat[0] & " import " & importDat[1] & "\n"

    if comment.len() > 0:
        result &= "\n" & indent(comment, 1, "#") & "\n"

    result &= "class " & name & "("
    if implement.len() < 1:
        result &= "object"
    else:
        result &= implement
    result &= "):\n"

    result &= indent(declaration, config.tabbing, " ") & "\n"
    result &= indent(
        "\ndef init(self, data):\n" &
        indent("self = json.loads(data)", config.tabbing, " "), config.tabbing, " "
    )

    if functions.len() > 0:
        var tabbing = "\n"
        while functions.startsWith(tabbing):
            tabbing &= " "
        result &= unindent(functions, tabbing.len() - 2, " ") & "\n"

proc genWStruct*(wstruct: WStruct, config: Config): string =
    result = wStructFile(
        wstruct.name, wstruct.imports.getOrDefault("py"),
        wstruct.fields, wstruct.functions.getOrDefault("py"),
        wstruct.comment, wstruct.implement.getOrDefault("py"), config,
    )

proc genWEnum*(wenum: WEnum, config: Config): string =
    result = wEnumFile(wenum.name, wenum.values, config)
