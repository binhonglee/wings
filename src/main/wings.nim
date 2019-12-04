from os
import createDir, fileExists, joinPath, paramCount, paramStr, parentDir, setCurrentDir
from strutils
import endsWith, removePrefix, startsWith
import sets
import tables
import wingspkg/core
import wingspkg/util/config, wingspkg/util/log

const DEFAULT_CONFIG_FILE: string = "wings.json"
var USER_CONFIG: Config = newConfig()

proc toFile(path: string, content: string): void =
    try:
        for outputDir in USER_CONFIG.outputRootDirs.items:
            if outputDir.len() > 0:
                setCurrentDir(outputDir)
            else:
                setCurrentDir(CALLER_DIR)
            createDir(parentDir(path))
            writeFile(path, content)
            LOG(SUCCESS, "Successfully generated " & outputDir & "/" & path)
    except:
        LOG(ERROR, "Failed to generate " & path)

proc init(count: int): void =
    if count < 1:
        LOG(FATAL, "Please add struct or enum files to be generated.")
        return

    var setConfig: bool = false
    var wingsFiles: seq[string] = newSeq[string](0)
    for i in countup(1, count, 1):
        let file = paramStr(i)
        if file.endsWith("wings.json") or file.startsWith("-c:"):
            var configFile = file
            if file.startsWith("-c:"):
                configFile.removePrefix("-c:")
            else:
                LOG(DEPRECATED, "Config file should be defined with `-c:file.json`")

            USER_CONFIG = config.parse(configFile)
            setConfig = true
        elif not fileExists(file):
            LOG(ERROR, "Cannot find " & file & ". Skipping...")
        else:
            wingsFiles.add(file)

    if not setConfig and fileExists(DEFAULT_CONFIG_FILE):
        USER_CONFIG = config.parse(DEFAULT_CONFIG_FILE)

    var outputFiles = fromFiles(wingsFiles, USER_CONFIG)
    for files in outputFiles.keys:
        for filetype in outputFiles[files].keys:
            toFile(filetype, outputFiles[files][filetype])

init(paramCount())