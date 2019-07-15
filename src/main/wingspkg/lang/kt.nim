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
        outType = "Int"
    of "str":
        outType = "String"
    of "bool":
        outType = "Boolean"
    of "date":
        outType = "Date"
    else:
        outType = outType

    if arr:
        return "ArrayList<" & outType & ">"
    else:
        return outType

proc typeInit(name: string): string =
    if contains(name, "[]"):
        return types(name) & "()"

    case name
    of "int":
        return "-1"
    of "str":
        return "\"\""
    of "bool":
        return "false"
    of "date":
        return "Date()"
    else:
        return name & "()"

proc enumFile*(
    name: string,
    values: seq[string],
    package: string,
): string =
    var enumFile: string = ""
    enumFile &= "package " & package & "\n\n"
    enumFile &= "enum class " & name & " {"

    var content: string = ""
    for value in values:
        if value.len() > 0:
            content &= "\n" & value & ","

    enumFile &= indent(content, 4, " ") & "\n}\n"
    return enumFile

proc structFile*(
    name: string,
    imports: seq[string],
    fields: seq[string],
    functions: string,
    implement: string,
    package: string,
): string =
    var structFile: string = ""
    structFile &= "package " & package & "\n\n"

    for toImport in imports:
        if toImport.len() < 1:
            continue

        structFile &= "import " & toImport & "\n"

    structFile &= "\n"
    structFile &= "class " & name
    
    if implement.len() > 0:
        structFile &= " : " & implement

    structFile &= " {\n"

    var declaration: string = ""
    var jsonKey: string = ""

    for fieldStr in fields:
        let field = fieldStr.split(' ')
        if field.len() < 3:
            continue

        if (declaration.len() > 1):
            declaration &= "\n"
            jsonKey &= "\n"
        
        var typeInit: string = typeInit(field[1])
        if field.len() > 3:
            typeInit = field[3]

        declaration &= "var " & field[0] & ": " & types(field[1]) & " = " & typeInit
        jsonKey &= "\"" & field[0] & "\" -> return \"" & field[2] & "\""

    structFile &= indent(declaration, 4, " ")
    structFile &= "\n\n"
    
    structFile &= indent(
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
        structFile &= "\n" & functions
    
    return structFile & "\n}\n"