from strutils
import capitalizeAscii, contains, join, normalize, parseEnum, removeSuffix, split, splitWhitespace
import tables
import lib/wenum, lib/wstruct, lib/winterface
import util/wiutil

proc newFilename(filename: string): Table[string, string] =
    const filetypes: array[5, string] = ["go", "kt", "nim", "py", "ts"]
    let temp: seq[string] = filename.split('/')
    result = initTable[string, string]()

    for filetype in filetypes:
        case filetype
        of "go", "nim", "py":
            result.add(
                filetype,
                join(
                    split(
                        temp[temp.len() - 1], '_'
                    )
                )
            )
        of "kt", "ts":
            var words = split(temp[temp.len() - 1], '_')
            for i in countup(0, words.len() - 1, 1):
                words[i] = capitalizeAscii(words[i])
            result.add(filetype, join(words))
        else:
            echo "Unsupported type given"

proc fromFile*(filename: string, header: string = ""): Table[string, string] =
    var fileInfo: seq[string] = filename.split('.')

    var newFileName: Table[string, string] = initTable[string, string]()
    var fileContents: Table[string, string] = initTable[string, string]()
    var filepaths: Table[string, string] = initTable[string, string]()

    let file: File = open(filename)
    var line: string

    while readLine(file, line) and line.len() > 0:
        var words: seq[string] = line.splitWhitespace()
        var filepath: seq[string] = words[0].split('-')

        if words.len() < 2 or filepath.len() < 2:
            continue

        if filepath[1] != "filepath":
            break;

        filepaths.add(filepath[0], words[1])

    case fileInfo[fileInfo.len() - 1]
    of "struct":
        var wstruct = newWStruct()
        if wstruct.parseFile(file, filename, filepaths):
            fileContents = wstruct.genWStructFiles(header)
            newFileName = newFilename(filename.substr(0, filename.len() - 7))
    of "enum":
        var wenum = newWEnum()
        if wenum.parseFile(file, filename, filepaths):
            fileContents = wenum.genWEnumFiles(header)
            newFileName = newFilename(filename.substr(0, filename.len() - 5))
    else:
        echo "Unsupported file type: " & fileInfo[fileInfo.len() - 1]
        file.close()
        return

    file.close()
    result = initTable[string, string]()
    for filetype in filepaths.keys:
        result.add(
            getOrDefault(filepaths, filetype) &
            "/" &
            newFileName[filetype] &
            filetype,
            getOrDefault(fileContents, filetype),
        )

proc fromFiles*(
    filenames: seq[string], header: string = "",
    prefixes: Table[string, string] = initTable[string, string](),
): Table[string, Table[string, string]] =
    var winterfaces: seq[IWings] = newSeq[IWings](0)

    for filename in filenames:
        let fileInfo: seq[string] = filename.split('.')

        var filepaths: Table[string, string] = initTable[string, string]()
        let file: File = open(filename)
        var line: string

        while readLine(file, line) and line.len() > 0:
            var words: seq[string] = line.splitWhitespace()
            var filepath: seq[string] = words[0].split('-')

            if words.len() < 2 or filepath.len() < 2:
                continue

            if filepath[1] != "filepath":
                break;

            filepaths.add(filepath[0], words[1])

        case fileInfo[fileInfo.len() - 1]
        of "enum":
            var wenum = newWEnum()
            if wenum.parseFile(file, filename, filepaths):
                winterfaces.add(wenum)
            else:
                echo "Failed to parse \"" & filename & "\". Skipping..."
        of "struct":
            var wstruct = newWStruct()
            if wstruct.parseFile(file, filename, filepaths):
                winterfaces.add(wstruct)
            else:
                echo "Failed to parse \"" & filename & "\". Skipping..."
        else:
            echo "Unsupported file type: " & fileInfo[fileInfo.len() - 1]

        file.close()

    result = dependencyGraph(winterfaces, prefixes, header)
