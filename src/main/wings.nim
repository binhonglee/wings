from os
import fileExists, paramCount, paramStr
from strutils
import startsWith, endsWith
import tables
import wingspkg/core
import wingspkg/util/config, wingspkg/util/log

const DEFAULT_CONFIG_FILE: string = "wings.json"
var USER_CONFIG: Config = newConfig()

proc toFile(path: string, content: string): void =
    try:
        writeFile(path, content)
        LOG(SUCCESS, "Successfully generated " & path)
    except:
        LOG(
            ERROR,
            "Failed to generate " &
            path &
            "\nPlease make sure the required folders are already created.",
        )

proc init(count: int): void =
    if count < 1:
        LOG(ERROR, "Please add struct or enum files to be generated.")
        return

    var setConfig: bool = false
    var wingsFiles: seq[string] = newSeq[string](0)
    for i in countup(1, count, 1):
        var file = paramStr(i)
        if not fileExists(file):
            LOG(ERROR, "Cannot find " & file & ". Skipping...")
        elif file.endsWith("wings.json"):
            USER_CONFIG = config.parse(file)
            setConfig = true
        else:
            wingsFiles.add(file)

    if not setConfig and fileExists(DEFAULT_CONFIG_FILE):
        USER_CONFIG = config.parse(DEFAULT_CONFIG_FILE)

    var outputFiles = fromFiles(wingsFiles, USER_CONFIG)
    for files in outputFiles.keys:
        for filetype in outputFiles[files].keys:
            toFile(filetype, outputFiles[files][filetype])

init(paramCount())
