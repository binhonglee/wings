from strutils
import contains, endsWith, indent, intToStr, removePrefix, removeSuffix, replace, split, startsWith
import sets
from tables import getOrDefault
from ../util/varname import camelCase
import ../util/log, ../util/config
import ../lib/wstruct, ../lib/wenum

proc types(name: string): string =
    result = name

    if result.startsWith("Map<") and result.endsWith(">"):
        result.removePrefix("Map<")
        result.removeSuffix(">")
        var typeToProcess: seq[string] = result.split(",")
        if typeToProcess.len() != 2:
            LOG(ERROR, "Invalid map types.")
            result = ""
        else:
            result = "Map<" & types(typeToProcess[0]) &
                ", " & types(typeToProcess[1]) & ">"
    elif result.startsWith("[]"):
        result.removePrefix("[]")
        result = types(result) & "[]"
    else:
        case result
        of "int", "float":
            result = "number"
        of "str":
            result = "string"
        of "bool":
            result = "boolean"
        of "date":
            result = "Date"

proc typeInit(name: string): string =
    if name.startsWith("[]"):
        result = "[]"
    elif name.startsWith("Map<") and name.endsWith(">"):
        result = "new Map()"
    else:
        case name
        of "int":
            result = "-1"
        of "float":
            result = "-0.1"
        of "str":
            result = "''"
        of "bool":
            result = "false"
        of "date":
            result = "new Date()"
        else:
            result = "new " & name & "()"

proc typeAssign(name: string, content: string): string =
    case name
    of "date":
        result = "new Date(" & content & ")"
    else:
        result = content

proc wEnumFile(
    name: string,
    values: seq[string],
): string =
    result = "enum " & name & "{"

    var content: string = ""
    for value in values:
        if value.len() > 0:
            content &= "\n" & value & ","

    result &= indent(content, 4, " ") & "\n}\n"
    result &= "\nexport default " & name & ";\n"


proc wStructFile(
    name: string,
    imports: HashSet[string],
    fields: seq[string],
    functions: string,
    comment: string,
    implement: string,
): string =
    result = ""

    for toImport in imports:
        if toImport.len < 1:
            continue

        var importDat: seq[string] = toImport.split(':')

        if importDat.len() == 1:
            let filename = toImport.split('/')
            let classname = filename[filename.len() - 1].split('.')
            let next = importDat[0]
            importDat = newSeq[string](0)
            importDat.add(classname[0])
            importDat.add(next)
        result &= "import " & importDat[0] & " from '" & importDat[1] & "';\n"

    if comment.len() > 0:
        result &= "\n" & indent(comment, 2, "/")
    result &= "\n"
    result &= "export default class " & name

    if implement.len() > 0:
        result &= " implements " & implement

    result &= " {\n"

    var declaration: string = "[key: string]: any;"
    var init: string = ""
    var jsonKey: string = ""

    for fieldStr in fields:
        let field = fieldStr.split(' ')
        if field.len() < 2:
            continue

        if (declaration.len() > 1):
            declaration &= "\n"

        if (init.len() > 1):
            init &= "\n"
            jsonKey &= "\n"

        var typeInit: string = typeInit(field[1])
        if field.len() > 2:
            typeInit = field[2]
        var fieldName: string = camelCase(field[0])
        declaration &= "public " & fieldName & ": " &
            types(field[1]) & " = " & typeInit & ";"

        if contains(field[1], "[]"):
            init &= "\nif (data." & field[0] & " !== null) {\n"
            init &= indent(
                "this." & fieldName &
                " = " & typeAssign(field[1], "data." & field[0]) &
                ";", 4, " "
            )
            init &= "\n}"
        else:
            init &= "this." & fieldName & " = " &
                typeAssign(field[1], "data." & field[0]) & ";"

        jsonKey &= "case '" & fieldName & "': {\n"
        jsonKey &= indent("return '" & field[0] & "';", 4, " ")
        jsonKey &= "\n}"

    result &= indent(declaration, 4, " ")
    result &= "\n"
    result &= indent(
        "\npublic init(data: any): boolean {\n" &
        indent(
            "try {\n" &
            indent(init, 4, " ") &
            "\n} catch (e) {\n" &
            indent("return false;", 4, " ") &
            "\n}\nreturn true;", 4, " "
        ) &
        "\n}", 4, " "
    )
    result &= "\n"
    result &= indent(
        "\npublic toJsonKey(key: string): string {\n" &
        indent(
            "switch (key) {\n" &
            indent(jsonKey, 4, " ") &
            "\n" &
            indent(
                "default: {\n" &
                indent("return key;", 4, " ") &
                "\n}", 4, " "
            ) & "\n}", 4, " "
        ) & "\n}", 4, " "
    )

    if functions.len() > 0:
        result &= "\n" & functions

    result &= "\n}\n"

proc genWEnum*(wenum: WEnum): string =
    result = wEnumFile(wenum.name, wenum.values)

proc genWStruct*(wstruct: WStruct): string =
    result = wStructFile(
        wstruct.name, wstruct.imports.getOrDefault("ts"),
        wstruct.fields, wstruct.functions.getOrDefault("ts"),
        wstruct.comment, wstruct.implement.getOrDefault("ts"),
    )
