from strutils import splitWhitespace
import tables
from ./winterface import IWings

type
    WEnum* = ref object of IWings
        values*: seq[string]

proc newWEnum*(): WEnum =
    result = WEnum()
    result.name = ""
    result.dependencies = newSeq[string](0)
    result.filepath = initTable[string, string]()
    result.imports = initTable[string, seq[string]]()
    result.values = newSeq[string](0)

proc parseFile*(wenum: var WEnum, file: File, filename: string, filepath: Table[string, string]): bool =
    wenum.filename = filename
    var line: string = ""
    var inWEnum: bool = false
    wenum.filepath = filepath

    while readLine(file, line):
        if line.len() < 1:
            continue;

        var words: seq[string] = line.splitWhitespace()

        if not inWEnum and words.len > 1 and words[1] == "{":
            wenum.name = words[0]
            inWEnum = true
        elif words[0] == "}":
            inWEnum = false
        elif inWEnum:
            wenum.values.add(words[0])

    if inWEnum:
        result = false
    else:
        result = true