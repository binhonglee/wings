from strutils
import contains, endsWith, join, removeSuffix, split, splitWhitespace
from sequtils import foldr
import sets
import tables
from ./winterface import IWings

type
    WStruct* = ref object of IWings
        comment*: string
        fields*: seq[string]
        functions*, implement*: Table[string, string]

proc newWStruct*(): WStruct =
    result = WStruct()
    result.name = ""
    result.dependencies = newSeq[string](0)
    result.filepath = initTable[string, string]()
    result.imports = initTable[string, HashSet[string]]()
    result.comment = ""
    result.fields = newSeq[string](0)
    result.functions = initTable[string, string]()
    result.implement = initTable[string, string]()

proc parseFile*(wstruct: var WStruct, file: File, filename: string, filepath: Table[string, string]): bool =
    wstruct.filename = filename
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
            if words[0] == "#" or words[0] == "//":
                words.delete(0)
                if wstruct.comment.len() > 0:
                    wstruct.comment &= "\n"
                wstruct.comment &= " " & foldr(words, a & " " & b)
            elif words[0].endsWith("-implement"):
                var toImplement: string = words[1]
                words[0].removeSuffix("-implement")
                wstruct.implement.add(words[0], toImplement)
            elif words[0].endsWith("-import"):
                var key: string = words[0]
                words.delete(0)
                key.removeSuffix("-import")
                if not wstruct.imports.hasKey(key):
                    wstruct.imports.add(key, initHashSet[string]())
                wstruct.imports[key].incl(foldr(words, a & " " & b))
            elif words[0].endsWith("import"):
                wstruct.dependencies.add(words[1])
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

    wstruct.filepath = filepath
    result = true
