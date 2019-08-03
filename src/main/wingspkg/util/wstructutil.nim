from strutils import split
import tables
import ../lib/wstruct
import ../lang/go, ../lang/kt, ../lang/nim, ../lang/py, ../lang/ts

proc genFiles*(wstruct: var WStruct): Table[string, string] =
    result = initTable[string, string]()

    for filetype in wstruct.package.keys:
        var fileContent: string = ""
        case filetype
        of "go":
            fileContent = go.genWStruct(wstruct)
        of "kt":
            fileContent = kt.genWStruct(wstruct)
        of "nim":
            fileContent = nim.genWStruct(wstruct)
        of "py":
            fileContent = py.genWStruct(wstruct)
        of "ts":
            fileContent = ts.genWStruct(wstruct)
        else:
            continue

        result.add(filetype, fileContent)