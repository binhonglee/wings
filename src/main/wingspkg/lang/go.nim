from strutils
import capitalizeAscii, contains, toLowerAscii,
    replace, indent, split, unindent
from tables import getOrDefault
from ../lib/varname import camelCase
import ../lib/wstruct, ../lib/wenum

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

proc wEnumFile(
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

proc wStructFile(
    name: string,
    imports: seq[string],
    fields: seq[string],
    functions: string,
    comment: string,
    package: string,
): string =
    result = "package " & package & "\n"
    var declarations: string = ""

    if imports.len() > 0:
        for toImport in imports:
            if toImport.len < 1:
                continue

            var importDat: seq[string] = toImport.split(':')

            if importDat.len < 2:
                declarations &= "\n\"" & toImport & "\""
            else:
                declarations &=  "\n" & importDat[0] &
                    " \"" & importDat[1] & "\""
        result &= "\nimport (" & indent(declarations, 4, " ") & "\n)\n"

    declarations = ""
    for fieldStr in fields:
        var field = fieldStr.split(' ')
        if field.len() > 1:
            if declarations.len() > 1:
                declarations &= "\n"
            declarations &= capitalizeAscii(camelCase(field[0])) & " " &
                types(field[1]) & " `json:\"" & field[0] & "\"`"

    if comment.len() > 0:
        result &= "\n" & indent(comment, 2, "/")
    result &= "\ntype " & name & " struct {\n" &
        indent(declarations, 4, " ") & "\n}\n"

    if functions.len() > 0:
        result &= unindent(functions, 4, " ") & "\n"

    result &= "\ntype " & name & "s []" & name

proc genWEnum*(wenum: WEnum): string =
    var tempPackage: seq[string] = split(wenum.package.getOrDefault("go"), '/')
    result = wEnumFile(wenum.name, wenum.values, tempPackage[tempPackage.len() - 1])

proc genWStruct*(wstruct: WStruct): string =
    var tempPackage: seq[string] = split(wstruct.package.getOrDefault("go"), '/')

    result = wStructFile(
        wstruct.name, wstruct.imports.getOrDefault("go"),
        wstruct.fields, wstruct.functions.getOrDefault("go"),
        wstruct.comment, tempPackage[tempPackage.len() - 1],
    )
