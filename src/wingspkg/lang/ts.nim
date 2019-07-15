from strutils
import contains, indent, intToStr, split

proc types(name: string): string =
    if contains(name, "[]"):
        return "[]"

    case name
    of "int":
        return "number"
    of "str":
        return "string"
    of "bool":
        return "boolean"
    of "date":
        return "Date"
    else:
        return name

proc typeInit(name: string): string =
    if contains(name, "[]"):
        return "[]"

    case name
    of "int":
        return "-1"
    of "str":
        return "''"
    of "bool":
        return "false"
    of "date":
        return "new Date()"
    else:
        return "new " & name & "()"

proc typeAssign(name: string, content: string): string =
    case name
    of "date":
        return "new Date(" & content & ")"
    else:
        return content

proc enumFile*(
    name: string,
    values: seq[string],
): string =
    var enumFile: string = ""
    enumFile &= "enum " & name & "{"
    
    var content: string = ""
    for value in values:
        if value.len() > 0:
            content &= "\n" & value & ","

    enumFile &= indent(content, 4, " ") & "\n}\n"
    return enumFile & "\nexport default " & name & ";\n"


proc structFile*(
    name: string,
    imports: seq[string],
    fields: seq[string],
    functions: string,
    implement: string,
): string =
    var structFile: string = ""

    for toImport in imports:
        if toImport.len < 1:
            continue

        var importDat: seq[string] = toImport.split(':')

        structFile &= "import " & importDat[0] & " from '" & importDat[1] & "';\n"

    structFile &= "\n"
    structFile &= "export default class " & name

    if implement.len() > 0:
        structFile &= " implements " & implement

    structFile &= " {\n"

    var declaration: string = "[key: string]: any;"
    var init: string = ""
    var jsonKey: string = ""

    for fieldStr in fields:
        let field = fieldStr.split(' ')
        if field.len() < 3:
            continue
        
        if (declaration.len() > 1):
            declaration &= "\n"

        if (init.len() > 1):
            init &= "\n"
            jsonKey &= "\n"

        var typeInit: string = typeInit(field[1])
        if field.len() > 3:
            typeInit = field[3]

        declaration &= "public " & field[0] & ": " & types(field[1]) & " = " & typeInit & ";"

        if contains(field[1], "[]"):
            init &= "\nif (data." & field[2] & " !== \"null\") {\n"
            init &= indent("this." & field[0] & " = " & typeAssign(field[1], "data." & field[2]) & ";", 4, " ")
            init &= "\n}"
        else:
            init &= "this." & field[0] & " = " & typeAssign(field[1], "data." & field[2]) & ";"
        
        jsonKey &= "case '" & field[0] & "': {\n"
        jsonKey &= indent("return '" & field[2] & "';", 4, " ")
        jsonKey &= "\n}"

    structFile &= indent(declaration, 4, " ")
    structFile &= "\n"
    structFile &= indent(
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
    structFile &= "\n"
    structFile &= indent(
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
        structFile &= "\n" & functions

    return structFile & "\n}\n"
