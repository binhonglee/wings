from strutils
import startsWith, contains, endsWith, indent, removePrefix, removeSuffix, replace, split
from tables import getOrDefault
from ../lib/varname import camelCase
import ../lib/wstruct, ../lib/wenum

const filetype: string = "kt"

proc types(imports: var seq[string], name: string): string =
    result = name

    if result.startsWith("Map<") and result.endsWith(">"):
        result.removePrefix("Map<")
        result.removeSuffix(">")
        var typeToProcess: seq[string] = result.split(",")
        if typeToProcess.len() != 2:
            echo "Invalid map types."
            result = ""
        else:
            imports.add("java.util.HashMap")
            result = "HashMap<" & types(imports, typeToProcess[0]) & ", " & types(imports, typeToProcess[1]) & ">"
    elif result.startsWith("[]"):
        result.removePrefix("[]")
        imports.add("java.util.ArrayList")
        result = "ArrayList<" & types(imports, result) & ">"
    else:
        case result
        of "int":
            result = "Int"
        of "str":
            result = "String"
        of "bool":
            result = "Boolean"
        of "date":
            result = "Date"

proc typeInit(name: string): string =
    result = name
    if strutils.contains(name, "[]") or strutils.contains(name, "Map<"):
        var tempSeq = newSeq[string](0)
        result = types(tempSeq, name)

    case result
    of "int":
        result = "-1"
    of "str":
        result = "\"\""
    of "bool":
        result = "false"
    of "date":
        result = "Date()"
    else:
        result &= "()"

proc wEnumFile(
    name: string,
    values: seq[string],
    package: string,
): string =
    result = "package " & package & "\n\n"
    result &= "enum class " & name & " {"

    var content: string = ""
    for value in values:
        if value.len() > 0:
            content &= "\n" & value & ","

    result &= indent(content, 4, " ") & "\n}\n"

proc wStructFile(
    name: string,
    imports: seq[string],
    fields: seq[string],
    functions: string,
    comment: string,
    implement: string,
    package: string,
): string =
    result = "package " & package & "\n\n"
    var typeDependentImports = imports
    var declaration: string = ""
    var jsonKey: string = ""

    for fieldStr in fields:
        let field = fieldStr.split(' ')
        if field.len() < 2:
            continue

        if (declaration.len() > 1):
            declaration &= "\n"
            jsonKey &= "\n"

        var typeInit: string = typeInit(field[1])
        if field.len() > 2:
            typeInit = field[2]
        var fieldName: string = camelCase(field[0])
        declaration &= "var " & fieldName & ": " & typeDependentImports.types(field[1]) & " = " & typeInit
        jsonKey &= "\"" & fieldName & "\" -> return \"" & field[0] & "\""

    for toImport in typeDependentImports:
        if toImport.len() < 1:
            continue

        result &= "import " & toImport & "\n"

    if comment.len() > 0:
        result &= "\n" & indent(comment, 2, "/")
    result &= "\n" & "class " & name

    if implement.len() > 0:
        result &= " : " & implement

    result &= " {\n"
    result &= indent(declaration, 4, " ")
    result &= "\n\n"

    result &= indent(
        "fun toJsonKey(key: string): string {\n" &
        indent(
            "when (key) {\n" &
            indent(
                jsonKey & "\n" &
                "else -> return key", 4, " "
            ) & "\n}", 4, " "
        ) & "\n}", 4, " "
    )

    if functions.len() > 0:
        result &= "\n" & functions

    result &= "\n}\n"

proc genWEnum*(wenum: WEnum): string =
    var tempPackage: seq[string] = split(wenum.filepath.getOrDefault(filetype), '/')
    result = wEnumFile(wenum.name, wenum.values, tempPackage[tempPackage.len() - 1])

proc genWStruct*(wstruct: WStruct): string =
    var tempPackage: seq[string] = split(wstruct.filepath.getOrDefault(filetype), '/')

    result = wStructFile(
        wstruct.name, wstruct.imports.getOrDefault(filetype),
        wstruct.fields, wstruct.functions.getOrDefault(filetype),
        wstruct.comment, wstruct.implement.getOrDefault(filetype),
        tempPackage[tempPackage.len() - 1],
    )
