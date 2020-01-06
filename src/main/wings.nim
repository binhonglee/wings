from times import epochTime
from os
import createDir, fileExists, joinPath, paramCount,
  paramStr, parentDir, setCurrentDir
from strutils import endsWith, removePrefix, startsWith
import stones/genlib
import stones/log
import sets
import tables
import wingspkg/core
import wingspkg/util/config

const CONFIG_PREFIX: string = "-c:"
var USER_CONFIG: Config = initConfig()

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
  let startTime = epochTime()
  if count < 1:
    LOG(FATAL, "Please add struct or enum files to be generated.")
    return

  var wingsFiles: seq[string] = newSeq[string](0)
  for i in countup(1, count, 1):
    let file = paramStr(i)
    if file.startsWith(CONFIG_PREFIX):
      USER_CONFIG = config.parse(
        getResult[string](string(file), CONFIG_PREFIX, removePrefix)
      )
    elif not fileExists(file):
      LOG(ERROR, "Cannot find " & file & ". Skipping...")
    else:
      wingsFiles.add(file)

  var outputFiles = fromFiles(wingsFiles, USER_CONFIG)
  for files in outputFiles.keys:
    for filetype in outputFiles[files].keys:
      toFile(filetype, outputFiles[files][filetype])

  LOG(INFO, "Time taken: " & $(epochTime() - startTime) & "s")

init(paramCount())
