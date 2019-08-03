from strutils import split
import tables
import ../lib/wenum
import ../lang/go, ../lang/kt, ../lang/nim, ../lang/py, ../lang/ts

proc genFiles*(wenum: var WEnum): Table[string, string] =
    result = initTable[string, string]()

    for filetype in wenum.package.keys:
        var fileContent: string = ""
        case filetype
        of "go":
            fileContent = go.genWEnum(wenum)
        of "kt":
            fileContent = kt.genWEnum(wenum)
        of "nim":
            fileContent = nim.genWEnum(wenum)
        of "py":
            fileContent = py.genWEnum(wenum)
        of "ts":
            fileContent = ts.genWEnum(wenum)
        else:
            continue

        result.add(filetype, fileContent)
