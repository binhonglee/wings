from strutils
import capitalizeAscii, contains, endsWith, join, normalize,
    parseEnum, removeSuffix, split, splitWhitespace
import tables
import lib/wenum, lib/wstruct, lib/winterface, lib/wiutil
import util/config, util/log

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
            LOG(ERROR, "Unsupported type given")

proc fromFile*(filename: string, header: string = ""): Table[string, string] {.deprecated.} =
    setLevel(DEPRECATED)
    LOG(
        DEPRECATED,
        "fromFile is now deprecated. Please use fromFiles() instead.",
    )

    let fileInfo: seq[string] = filename.split('.')
    var newFileName: Table[string, string] = initTable[string, string]()
    var fileContents: Table[string, string] = initTable[string, string]()
    var filepaths: Table[string, string] = initTable[string, string]()

    let file: File = open(filename)
    var line: string

    while readLine(file, line) and line.len() > 0:
        let words: seq[string] = line.splitWhitespace()
        let filepath: seq[string] = words[0].split('-')

        if words.len() < 2 or filepath.len() < 2:
            continue

        if filepath[1] != "filepath":
            break;

        filepaths.add(filepath[0], words[1])

    let config = newConfig(header)

    case fileInfo[fileInfo.len() - 1]
    of "struct":
        var wstruct = newWStruct()
        if wstruct.parseFile(file, filename, filepaths, config):
            fileContents = wstruct.genWStructFiles(config)
            newFileName = newFilename(filename.substr(0, filename.len() - 7))
    of "enum":
        var wenum = newWEnum()
        if wenum.parseFile(file, filename, filepaths, config):
            fileContents = wenum.genWEnumFiles(config)
            newFileName = newFilename(filename.substr(0, filename.len() - 5))
    else:
        LOG(ERROR, "Unsupported file type: " & fileInfo[fileInfo.len() - 1])
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
    filenames: seq[string], config: Config,
): Table[string, Table[string, string]] =
    var winterfaces: seq[IWings] = newSeq[IWings](0)

    for rawFilename in filenames:
        var filename: string = rawFilename
        if filename.endsWith(".wings"):
            filename.removeSuffix(".wings")
        else:
            LOG(DEPRECATED, "Filenames without .wings ending will be ignored soon.")

        let fileInfo: seq[string] = filename.split('.')

        var filepaths: Table[string, string] = initTable[string, string]()
        let file: File = open(rawFilename)
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
            if wenum.parseFile(file, rawFilename, filepaths, config):
                winterfaces.add(wenum)
            else:
                LOG(ERROR, "Failed to parse \"" & rawFilename & "\". Skipping...")
        of "struct":
            var wstruct = newWStruct()
            if wstruct.parseFile(file, rawFilename, filepaths, config):
                winterfaces.add(wstruct)
            else:
                LOG(ERROR, "Failed to parse \"" & rawFilename & "\". Skipping...")
        else:
            LOG(ERROR, "Unsupported file type: " & fileInfo[fileInfo.len() - 1])

        file.close()

    result = dependencyGraph(winterfaces, config)
