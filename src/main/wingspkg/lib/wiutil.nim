import tables
import ./winterface
import ../util/filename, ../util/header, ../util/config, ../util/log
import ../lang/go, ../lang/kt, ../lang/nim, ../lang/py, ../lang/ts

proc genWEnumFiles*(this: var WEnum, config: Config): Table[string, string] =
    ## Generate the enum files for all the natively supported output types.
    result = initTable[string, string]()
    let filenames = outputFilename(this.filename, this.filepath)

    for filetype in this.filepath.keys:
        LOG(DEBUG, "Generating " & filenames[filetype] & "...")
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

proc genWStructFiles*(this: var WStruct, config: Config): Table[string, string] =
    ## Generate the struct files for all the natively supported output types.
    if this.dependencies.len() > 0:
        for dependency in this.dependencies:
            LOG(WARNING, "Dependency (" & dependency & ") not yet fulfilled.")

        LOG(WARNING, "Generated files may not work as intended.")

    result = initTable[string, string]()
    let filenames = outputFilename(this.filename, this.filepath)

    for filetype in this.filepath.keys:
        LOG(DEBUG, "Generating " & filenames[filetype] & "...")
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

proc genFiles*(this: var IWings, config: Config): Table[string, string] =
    ## Generate the corresponding files (WEnum or WStruct) for all the natively supported output types.
    if this of WEnum:
        result = WEnum(this).genWEnumFiles(config)
    elif this of WStruct:
        result = WStruct(this).genWStructFiles(config)

proc dependencyGraph*(
    allWings: var Table[string, IWings],
    config: Config,
): Table[string, Table[string, string]] =
    ## Generate and fulfill all dependencies in its intended succession.
    var noDeps: seq[string] = newSeq[string](0)
    var filenameToObj: Table[string, IWings] = initTable[string, IWings]()
    var reverseDependencyTable: Table[string, seq[string]] =
        initTable[string, seq[string]]()
    result = initTable[string, Table[string, string]]()

    var index = 0;
    for wings in allWings.values:
        filenameToObj[wings.filename] = wings
        if wings.dependencies.len() == 0:
            noDeps.add(wings.filename)

        for dependency in wings.dependencies:
            if not reverseDependencyTable.hasKey(dependency):
                reverseDependencyTable[dependency] = newSeq[string](0)
            reverseDependencyTable[dependency].add(wings.filename)

        index += 1

    # TODO: Multithread this
    while noDeps.len() > 0:
        var wings: IWings = filenameToObj[noDeps.pop()]
        var name: string = wings.filename
        LOG(DEBUG, "Generating files from " & name & "...")

        if not (config.skipImport and wings.imported):
            result.add(name, wings.genFiles(config))
        if reverseDependencyTable.hasKey(name):
            for dependant in reverseDependencyTable[name]:
                var obj = filenameToObj[dependant]
                let fulfillDep = obj.fulfillDependency(
                    name,
                    importFilename(
                        name,
                        wings.filepath,
                        filename(obj.filename, obj.filepath),
                        config.prefixes,
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
                    allWings[obj.filename] = obj

            reverseDependencyTable.del(name)

        allWings.del(wings.filename)

    if allWings.len() > 0:
        let next = dependencyGraph(allWings, config)

        for k in next.keys:
            result.add(k, next[k])
