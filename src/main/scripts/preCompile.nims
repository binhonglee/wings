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
  let (version, _) = gorgeEx("git describe --tags")
  let (status, _) = gorgeEx("git status --porcelain")
  var getHash: string = "git rev-parse HEAD"
  if status == "":
    getHash &= "^"
  let (hash, _) = gorgeEx(getHash)
  writeFile(
    outputFile,
    header & "\n" &
    "const VERSION*: string = \"" & version & "\"\n" &
    "const HASH*: string = \"" & hash & "\"\n"
  )

genRun()
