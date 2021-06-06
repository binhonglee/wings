#!/usr/bin/env nim
from os import lastPathPart
import ./releaseConst

mode = ScriptMode.Verbose

const folder: string = "release"
const main: string = "src/main/wings.nim"
const nimble: string = "plz-out/.nimble/pkgs"
const plz_args: string = " --nocolour --nocache --plain_output --verbosity=error"
const plz_run: string = "./pleasew run"
const release: string = "-d:release"
const ssl: string = "-d:ssl"

proc build(version: string): void =
  exec(
    "nim " & version & " " & ssl & " " & release & " --verbosity:0 --NimblePath:" & nimble & " -o:" &
    folder & "/wings_" & getFilename(version) & " c " & main
  )

proc genRun(): void =
  if lastPathPart(getCurrentDir()) != "wings":
    echo "This script should be run on the top level folder instead."
    echo "Exiting..."
    return

  exec(plz_run & plz_args & " //src/main/staticlang:static")

  if paramCount() > 1 and paramStr(2) == "--all":
    var status: string = ""
    for i in options:
      try:
        build(i)
        status &= "\n  \u001b[32m[SUCCESS] " & getFilename(i) & "\u001b[0m"
      except:
        status &= "\n  \u001b[31m[FAILED] " & getFilename(i) & "\u001b[0m"
    echo "Build status:" & status
    return
  else:
    try:
      build(getVersion())
    except UnsupportedOSError:
      echo "Unsupported OS version"
      return

  echo "Build successful. Exiting..."

genRun()
