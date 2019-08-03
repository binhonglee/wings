from strutils import splitWhitespace
import tables

type
    WEnum* = object
        name*: string
        values*: seq[string]
        package*: Table[string, string]

proc newWEnum*(): WEnum =
    result = WEnum()
    result.name = ""
    result.values = newSeq[string](0)
    result.package = initTable[string, string]()

proc parseFile*(wenum: var WEnum, file: File, filename: string, package: Table[string, string]): void =
    var line: string = ""
    var inWEnum: bool = false
    wenum.package = package

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
