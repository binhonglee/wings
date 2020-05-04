from strutils
import contains, endsWith, join, normalize,
  parseEnum, removeSuffix, split, splitWhitespace
import tables
import stones/log
import lib/winterface, lib/wiutil
import util/config

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

    for filename, winterface in parseFile(rawFilename, config.skipImport).pairs:
      if winterfaces.hasKey(filename) and winterface.imported:
        continue
      winterfaces[filename] = winterface

  result = dependencyGraph(winterfaces, config)
