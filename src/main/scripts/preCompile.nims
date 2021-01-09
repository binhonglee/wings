#!/usr/bin/env nim

mode = ScriptMode.Verbose

const outputFile: string = "const.nim"
const header: string = """
# DO NOT MANUALLY EDIT THIS FILE
#
# This file is generated from `src/main/scripts/preCompile.nims`.
# If you would like to make any changes, please make your edits there instead.
"""

proc genRun(): void =
  let (status, _) = gorgeEx("git status --porcelain")
  var getHash: string = "git rev-parse HEAD"
  var getVersion = "git describe --tags HEAD"
  if status == "":
    getHash &= "^"
    getVersion &= "^"
  let (hash, _) = gorgeEx(getHash)
  let (version, _) = gorgeEx(getVersion)
  writeFile(
    outputFile,
    header & "\n" &
    "const VERSION*: string = \"" & version & "\"\n" &
    "const HASH*: string = \"" & hash & "\"\n"
  )

genRun()
