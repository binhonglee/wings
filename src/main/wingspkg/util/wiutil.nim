import tables
import ../lib/winterface, ../lib/wenum, ../lib/wstruct
import ../lib/filename, ../lib/header
import ../lang/go, ../lang/kt, ../lang/nim, ../lang/py, ../lang/ts

proc genWStructFiles*(this: var WStruct, header: string): Table[string, string] =
    if this.dependencies.len() > 0:
        for dependency in this.dependencies:
            echo "Dependency (" & dependency & ") not yet fulfilled."

        echo "Generated files may not work as intended."

    result = initTable[string, string]()
    let filenames = outputFilename(this.filename, this.filepath)

    for filetype in this.filepath.keys:
        var fileContent: string = ""
        case filetype
        of "go":
            fileContent = go.genWStruct(this)
        of "kt":
            fileContent = kt.genWStruct(this)
        of "nim":
            fileContent = nim.genWStruct(this)
        of "py":
            fileContent = py.genWStruct(this)
        of "ts":
            fileContent = ts.genWStruct(this)
        else:
            continue

        result.add(
            filenames[filetype],
            genHeader(filetype, this.filename, header) &
                fileContent
        )

proc genWEnumFiles*(this: var WEnum, header: string): Table[string, string] =
    result = initTable[string, string]()
    let filenames = outputFilename(this.filename, this.filepath)

    for filetype in this.filepath.keys:
        var fileContent: string = ""
        case filetype
        of "go":
            fileContent = go.genWEnum(this)
        of "kt":
            fileContent = kt.genWEnum(this)
        of "nim":
            fileContent = nim.genWEnum(this)
        of "py":
            fileContent = py.genWEnum(this)
        of "ts":
            fileContent = ts.genWEnum(this)
        else:
            continue

        result.add(
            filenames[filetype],
            genHeader(filetype, this.filename, header) &
                fileContent
        )

proc genFiles*(this: var IWings, header: string): Table[string, string] =
    if this of WEnum:
        result = WEnum(this).genWEnumFiles(header)
    elif this of WStruct:
        result = WStruct(this).genWStructFiles(header)

proc dependencyGraph*(
    allWings: var seq[IWings],
    prefixes: Table[string, string],
    header: string,
): Table[string, Table[string, string]] =
    var noDeps: seq[string] = newSeq[string](0)
    var filenameToIndex: Table[string, int] = initTable[string, int]()
    var filenameToObj: Table[string, IWings] = initTable[string, IWings]()
    var reverseDependencyTable: Table[string, seq[string]] =
        initTable[string, seq[string]]()
    result = initTable[string, Table[string, string]]()

    var index = 0;
    for wing in allWings:
        filenameToObj[wing.filename] = wing
        filenameToIndex[wing.filename] = index
        if wing.dependencies.len() == 0:
            noDeps.add(wing.filename)

        for dependency in wing.dependencies:
            if not reverseDependencyTable.hasKey(dependency):
                reverseDependencyTable[dependency] = newSeq[string](0)
            reverseDependencyTable[dependency].add(wing.filename)

        index += 1

    while noDeps.len() > 0:
        var wing = filenameToObj[noDeps.pop()]
        let name = wing.filename
        result.add(name, wing.genFiles(header))
        if reverseDependencyTable.hasKey(name):
            for dependant in reverseDependencyTable[name]:
                var obj = filenameToObj[dependant]
                let fulfillDep = obj.fulfillDependency(
                    name,
                    importFilename(
                        name,
                        wing.filepath,
                        filename(obj.filename, obj.filepath),
                        prefixes
                    )
                )
                if not fulfillDep:
                    echo "Something went wrong when fulfilling a dependency for " &
                        obj.name
                else:
                    allWings[filenameToIndex[obj.filename]] = obj
            reverseDependencyTable.del(name)

        index = filenameToIndex[name]
        allWings.delete(index)

    if allWings.len() > 0:
        let next = dependencyGraph(allWings, prefixes, header)

        for k in next.keys:
            result.add(k, next[k])
