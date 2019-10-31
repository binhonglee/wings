import tables
import strutils
from sequtils import foldr

let joiner: Table[string, char] = {"go": '/', "kt": '/', "nim": '/', "py": '.', "ts": '/'}.toTable

proc filename*(
    filename: string,
    filepath: Table[string, string],
    customJoin: Table[string, char] = joiner,
    filetypeSuffix: bool = false,
): Table[string, string] =
    var temp: seq[string] = filename.split('/')
    temp[temp.len() - 1] = temp[temp.len() - 1].split('.')[0]
    result = initTable[string, string]()

    for filetype in filepath.keys:
        let prefix: string = foldr(
            filepath[filetype].split('/'),
            a & customJoin[filetype] & b
        ) & customJoin[filetype]
        var suffix: string = ""
        if filetypeSuffix:
            suffix = "." & filetype
        case filetype
        of "go", "nim", "py":
            result.add(
                filetype,
                prefix &
                join(
                    split(
                        temp[temp.len() - 1], '_'
                    )
                ) &
                suffix
            )
        of "kt", "ts":
            var words = split(temp[temp.len() - 1], '_')
            for i in countup(0, words.len() - 1, 1):
                words[i] = capitalizeAscii(words[i])
            result.add(filetype, prefix & join(words) & suffix)
        else:
            echo "Unsupported type given"

proc outputFilename*(
    filename: string,
    filepath: Table[string, string]
): Table[string, string] =
    result = filename(
        filename,
        filepath,
        {"go": '/', "kt": '/', "nim": '/', "py": '/', "ts": '/'}.toTable,
        true
    )

proc importFilename*(
    filename: string,
    filepath: Table[string, string],
    callerFilepath: Table[string, string],
    prefixes: Table[string, string],
): Table[string, string] =
    result = filename(filename, filepath)

    for filetype in filepath.keys:

        if prefixes.contains(filetype):
            result[filetype] = prefixes[filetype] & joiner[filetype] & result[filetype]
            continue
        elif filetype == "py" or filetype == "go":
            continue

        let selfPath: seq[string] = result[filetype].split(joiner[filetype])
        let callerPath: seq[string] = callerFilepath[filetype].split(joiner[filetype])
        var pos: int = 0
        var same: bool = true

        while same:
            if selfPath[pos] != callerPath[pos]:
                same = false
            else:
                pos += 1

        var output: string = ""
        for i in countup(pos, callerPath.len() - 2, 1):
            if output != "":
                output &= joiner[filetype]
            output &= ".."

        if output == "":
            output &= "."

        for i in countup(pos, selfPath.len() - 1, 1):
            output &= joiner[filetype] & selfPath[i]

        result[filetype] = output

    if result.contains("go"):
        var words = result["go"].split('/')
        let name = words[words.len() - 1]
        words.delete(words.len() - 1)
        result["go"] = name & ":" & foldr(words, a & "/" & b)