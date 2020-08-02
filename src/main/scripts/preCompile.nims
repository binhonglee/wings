#!/usr/bin/env nim

mode = ScriptMode.Verbose

const outputFile: string = "src/main/const.nim"
const header: string = """
# DO NOT MODIFY
#
# This file is generated from `src/main/scripts/preCompile.nims`.
# If you would like to make any changes, please make your edits there instead.
"""

proc genRun(): void =
  let (version, _) = gorgeEx("git describe --tags")
  let (hash, _) = gorgeEx("git rev-parse HEAD")
  writeFile(
    outputFile,
    header & "\n" &
    "const VERSION*: string = \"" & version & "\"\n" &
    "const HASH*: string = \"" & hash & "\"\n"
  )

genRun()
