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
        result = "Int"
    of "str":
        result = "String"
    of "bool":
        result = "Boolean"
    of "date":
        result = "Date"

    if arr:
        result = "ArrayList<" & result & ">"

proc typeInit(name: string): string =
    result = name
    if contains(name, "[]"):
        result = types(name)

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

proc enumFile*(
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

proc structFile*(
    name: string,
    imports: seq[string],
    fields: seq[string],
    functions: string,
    implement: string,
    package: string,
): string =
    result = "package " & package & "\n\n"

    for toImport in imports:
        if toImport.len() < 1:
            continue

        result &= "import " & toImport & "\n"

    result &= "\n"
    result &= "class " & name
    
    if implement.len() > 0:
        result &= " : " & implement

    result &= " {\n"

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