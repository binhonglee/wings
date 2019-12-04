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
    var winterfaces: seq[IWings] = newSeq[IWings](0)

    for rawFilename in filenames:
        var filename: string = rawFilename
        if filename.endsWith(".wings"):
            filename.removeSuffix(".wings")
        else:
            LOG(DEPRECATED, "Filenames without .wings ending will be ignored soon.")

        let file: File = open(rawFilename)

        var winterface = initIWings()
        if winterface.parseFileIWings(file, rawFilename):
            winterfaces.add(winterface)

        file.close()

    result = dependencyGraph(winterfaces, config)
