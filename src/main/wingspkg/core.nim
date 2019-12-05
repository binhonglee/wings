from strutils
import capitalizeAscii, contains, endsWith, join, normalize,
    parseEnum, removeSuffix, split, splitWhitespace
import tables
import lib/winterface, lib/wiutil
import util/config, util/log

proc fromFiles*(
    filenames: seq[string], config: Config,
): Table[string, Table[string, string]] =
    ## Entry point to the file. It gets all the files to read and returns a table of output to be written.
    var winterfaces: Table[string, IWings] = initTable[string, IWings]()

    for rawFilename in filenames:
        if not rawFilename.endsWith(".wings"):
            LOG(ERROR, "Unrecognized file '" & rawFilename & "'. Skipping...")

        if winterfaces.hasKey(rawFilename) and not winterfaces[rawFilename].imported:
            continue

        let file: File = open(rawFilename)

        for filename, winterface in parseFile(file, rawFilename, config.skipImport).pairs:
            if winterfaces.hasKey(filename):
                if winterface.imported:
                    continue
            winterfaces[filename] = winterface

        file.close()

    result = dependencyGraph(winterfaces, config)
