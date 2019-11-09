import tables
import ./winterface, ./wenum, ./wstruct
import ../util/filename, ../util/header, ../util/config
import ../lang/go, ../lang/kt, ../lang/nim, ../lang/py, ../lang/ts
import ../util/log

proc genWStructFiles*(this: var WStruct, config: Config): Table[string, string] =
    if this.dependencies.len() > 0:
        for dependency in this.dependencies:
            LOG(WARNING, "Dependency (" & dependency & ") not yet fulfilled.")

        LOG(WARNING, "Generated files may not work as intended.")

    result = initTable[string, string]()
    let filenames = outputFilename(this.filename, this.filepath)

    for filetype in this.filepath.keys:
        LOG(INFO, "Generating " & filenames[filetype] & "...")
        var fileContent: string = ""
        case filetype
        of "go":
            fileContent = go.genWStruct(this, config)
        of "kt":
            fileContent = kt.genWStruct(this, config)
        of "nim":
            fileContent = nim.genWStruct(this, config)
        of "py":
            fileContent = py.genWStruct(this, config)
        of "ts":
            fileContent = ts.genWStruct(this, config)
        else:
            continue

        result.add(
            filenames[filetype],
            genHeader(filetype, this.filename, config.header) &
                fileContent
        )

proc genWEnumFiles*(this: var WEnum, config: Config): Table[string, string] =
    result = initTable[string, string]()
    let filenames = outputFilename(this.filename, this.filepath)

    for filetype in this.filepath.keys:
        LOG(INFO, "Generating " & filenames[filetype] & "...")
        var fileContent: string = ""
        case filetype
        of "go":
            fileContent = go.genWEnum(this, config)
        of "kt":
            fileContent = kt.genWEnum(this, config)
        of "nim":
            fileContent = nim.genWEnum(this, config)
        of "py":
            fileContent = py.genWEnum(this, config)
        of "ts":
            fileContent = ts.genWEnum(this, config)
        else:
            continue

        result.add(
            filenames[filetype],
            genHeader(filetype, this.filename, config.header) &
                fileContent
        )

proc genFiles*(this: var IWings, config: Config): Table[string, string] =
    if this of WEnum:
        result = WEnum(this).genWEnumFiles(config)
    elif this of WStruct:
        result = WStruct(this).genWStructFiles(config)

proc findWings(allWings: seq[IWings], filename: string): int =
    var i = 0
    while i < allWings.len():
        if allWings[i].filename == filename:
            return i
        i += 1

    LOG(ERROR, filename & " not found.")
    result = -1


proc dependencyGraph*(
    allWings: var seq[IWings],
    config: Config,
): Table[string, Table[string, string]] =
    var noDeps: seq[string] = newSeq[string](0)
    var filenameToObj: Table[string, IWings] = initTable[string, IWings]()
    var reverseDependencyTable: Table[string, seq[string]] =
        initTable[string, seq[string]]()
    result = initTable[string, Table[string, string]]()

    var index = 0;
    for wing in allWings:
        filenameToObj[wing.filename] = wing
        if wing.dependencies.len() == 0:
            noDeps.add(wing.filename)

        for dependency in wing.dependencies:
            if not reverseDependencyTable.hasKey(dependency):
                reverseDependencyTable[dependency] = newSeq[string](0)
            reverseDependencyTable[dependency].add(wing.filename)

        index += 1

    # All noDeps can and should be generated in parallel if possible
    while noDeps.len() > 0:
        var wing = filenameToObj[noDeps.pop()]
        var name: string = wing.filename
        LOG(INFO, "Generating files from " & name & "...")

        result.add(name, wing.genFiles(config))
        if reverseDependencyTable.hasKey(name):
            for dependant in reverseDependencyTable[name]:
                var obj = filenameToObj[dependant]
                let fulfillDep = obj.fulfillDependency(
                    name,
                    importFilename(
                        name,
                        wing.filepath,
                        filename(obj.filename, obj.filepath),
                        config.prefixes
                    )
                )
                if not fulfillDep:
                    LOG(
                        ERROR,
                        "Something went wrong when fulfilling a dependency of" &
                        name &
                        "for " &
                        obj.name,
                    )
                else:
                    allWings[findWings(allWings, obj.filename)] = obj

            reverseDependencyTable.del(name)

        allWings.delete(findWings(allWings, wing.filename))

    if allWings.len() > 0:
        let next = dependencyGraph(allWings, config)

        for k in next.keys:
            result.add(k, next[k])
