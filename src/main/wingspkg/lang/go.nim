from strutils
import capitalizeAscii, contains, toLowerAscii, replace, indent, split, unindent

proc types(name: string): string =
    var arr: string = ""
    var outType: string = name
    if contains(name, "[]"):
        arr = "[]"
        outType = replace(name, "[]", "")

    case outType
    of "int":
        outType = "int"
    of "str":
        outType = "string"
    of "bool":
        outType = "bool"
    of "date":
        outType = "time.Time"
    else:
        outType = toLowerAscii(outType) & "." & outType

    return arr & outType

proc enumFile*(
    name: string,
    values: seq[string],
    package: string,
): string =
    var enumFile: string = ""
    enumFile &= "package " & package & "\n\n"
    enumFile &= "type " & name & " int\n\n"
    enumFile &= "const ("
    var count: int = 0
    var content: string = ""

    for value in values:
        if value.len() < 1:
            continue
        var iota: string = ""
        if count == 0:
            iota = " = iota"
            count = 1

        content &= "\n" & value & iota

    return enumFile & indent(content, 4, " ") & "\n)\n"

proc structFile*(
    name: string,
    imports: seq[string],
    fields: seq[string],
    functions: string,
    package: string,
): string =
    var structFile: string = ""
    structFile &= "package " & package & "\n"
    var declarations: string = ""

    if imports.len() > 0:
        var before: string = "\nimport ("
        for toImport in imports:
            if toImport.len < 1:
                continue

            var importDat: seq[string] = toImport.split(':')

            if importDat.len < 2:
                declarations &= "\n\"" & toImport & "\""
            else:
                declarations &=  "\n" & importDat[0] & " \"" & importDat[1] & "\""
        var after: string = "\n)\n"

        structFile &= before & indent(declarations, 4, " ") & after
    
    declarations = ""
    var before = "\ntype " & name & " struct {\n"

    for fieldStr in fields:
        var field = fieldStr.split(' ')
        if field.len() > 2:
            if declarations.len() > 1:
                declarations &= "\n"
            declarations &= capitalizeAscii(field[0]) & " " & types(field[1]) & " `json:\"" & field[2] & "\"`"
    var after = "\n}\n"

    structFile &= before & indent(declarations, 4, " ") & after

    if functions.len() > 0:
        structFile &= unindent(functions, 4, " ") & "\n"

    structFile &= "\ntype " & name & "s []" & name

    return structFile
