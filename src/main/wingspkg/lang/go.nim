from strutils
import capitalizeAscii, contains, toLowerAscii, replace, indent, split, unindent

proc types(name: string): string =
    result = name
    var arr: bool = false
    if contains(name, "[]"):
        arr = true
        result = replace(name, "[]", "")

    case result
    of "int":
        result = "int"
    of "str":
        result = "string"
    of "bool":
        result = "bool"
    of "date":
        result = "time.Time"
    else:
        result = toLowerAscii(result) & "." & result
    
    if arr:
        result = "[]" & result

proc enumFile*(
    name: string,
    values: seq[string],
    package: string,
): string =
    result = "package " & package & "\n\n"
    result &= "type " & name & " int\n\n"
    result &= "const ("
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

    result &= indent(content, 4, " ") & "\n)\n"

proc structFile*(
    name: string,
    imports: seq[string],
    fields: seq[string],
    functions: string,
    package: string,
): string =
    result = "package " & package & "\n"
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

        result &= before & indent(declarations, 4, " ") & after
    
    declarations = ""
    var before = "\ntype " & name & " struct {\n"

    for fieldStr in fields:
        var field = fieldStr.split(' ')
        if field.len() > 2:
            if declarations.len() > 1:
                declarations &= "\n"
            declarations &= capitalizeAscii(field[0]) & " " & types(field[1]) & " `json:\"" & field[2] & "\"`"
    var after = "\n}\n"

    result &= before & indent(declarations, 4, " ") & after

    if functions.len() > 0:
        result &= unindent(functions, 4, " ") & "\n"

    result &= "\ntype " & name & "s []" & name
