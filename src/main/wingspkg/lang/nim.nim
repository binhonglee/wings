from strutils
import capitalizeAscii, contains, endsWith, indent, normalize,
    removePrefix, removeSuffix, replace, split, startsWith, unindent
import sets
from tables import getOrDefault
from ../util/varname import camelCase
import ../util/config, ../util/log
import ../lib/winterface

proc types(imports: var HashSet[string], name: string): string =
    result = name

    if result.startsWith("Map<") and result.endsWith(">"):
        result.removePrefix("Map<")
        result.removeSuffix(">")
        var typeToProcess: seq[string] = result.split(",")
        if typeToProcess.len() != 2:
            LOG(FATAL, "Invalid map types: " & name & ".")
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
    config: Config,
): string =
    result = "type\n"
    result &= indent(name & "* = enum", config.tabbing, " ") & "\n"

    var content: string = ""
    for value in values:
        if value.len() > 0:
            if content.len() > 1:
                content &= "\n"

            content &= value & ","

    result &= indent(content, (config.tabbing * 2), " ")

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

    if imports.len() > 0:
        result &= "\n"

    if comment.len() > 0:
        result &= "\n" & indent(comment, 1, "#") & "\n"

    result &= "type\n"

    var objStr = "* = object"
    if implement.len() > 0:
        objStr = "* = ref object of " & implement

    result &= indent(name & objStr, config.tabbing, " ")
    result &= "\n" & indent(declaration, (config.tabbing * 2), " ") & "\n\n"

    result &= "proc parse*(" & normalize(name) &
            ": var " & name & ", data: string): void =\n"
    result &= indent("let jsonOutput = parseJson(data)\n\n" & parse, config.tabbing, " ")

    if functions.len() > 0:
        var tabbing = "\n"
        while functions.startsWith(tabbing):
            tabbing &= " "
        result &= unindent(functions, tabbing.len() - 2, " ") & "\n"

proc genWEnum*(wenum: WEnum, config: Config): string =
    result = wEnumFile(wenum.name, wenum.values, config)

proc genWStruct*(wstruct: WStruct, config: Config): string =
    result = wStructFile(
        wstruct.name, wstruct.imports.getOrDefault("nim"),
        wstruct.fields, wstruct.functions.getOrDefault("nim"),
        wstruct.comment, wstruct.implement.getOrDefault("nim"), config,
    )
