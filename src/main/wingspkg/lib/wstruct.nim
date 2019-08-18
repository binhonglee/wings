from strutils
import contains, endsWith, join, removeSuffix, split, splitWhitespace
from sequtils import foldr
import tables

type
    WStruct* = object
        name*: string
        fields*: seq[string]
        functions*, implement*, package*: Table[string, string]
        imports*: Table[string, seq[string]]

proc newWStruct*(): WStruct =
    result = WStruct()
    result.name = ""
    result.functions = initTable[string, string]()
    result.implement = initTable[string, string]()
    result.package = initTable[string, string]()
    result.fields = newSeq[string](0)
    result.imports = initTable[string, seq[string]]()

proc parseFile*(wstruct: var WStruct, file: File, filename: string, package: Table[string, string]): bool =
    var line: string = ""

    var inWStruct: bool = false
    var inFunc: string = ""

    while readLine(file, line):
        if line.len() < 1:
            if inFunc != "":
                wstruct.functions[inFunc] &= "\n"

            continue;

        var words: seq[string] = line.splitWhitespace()

        if not inWStruct and inFunc == "":
            if words[0].endsWith("-implement"):
                var toImplement: string = words[1]
                words[0].removeSuffix("-implement")
                wstruct.implement.add(words[0], toImplement)
            elif words[0].endsWith("-import"):
                words[0].removeSuffix("-import")
                if not wstruct.imports.hasKey(words[0]):
                    wstruct.imports.add(words[0], newSeq[string](0))
                var key: string = words[0]
                words.delete(0)
                wstruct.imports[key].add(foldr(words, a & " " & b))
            elif words[0].endsWith("Func("):
                words[0].removeSuffix("Func(")
                wstruct.functions.add(words[0], "")
                inFunc = words[0]
            elif words.len > 1 and words[1] == "{":
                wstruct.name = words[0]
                inWStruct = true
            elif words.len > 1:
                echo "Invalid input: " & join(words, " ")
                return false
        elif inWStruct:
            if words[0] == "}":
                inWStruct = false
            else:
                wstruct.fields.add(join(words, " "))
        elif inFunc != "":
            if words.len() > 0 and words[0] == ")":
                inFunc = ""
            else:
                wstruct.functions[inFunc] &= "\n" & line

    wstruct.package = package
    result = true
