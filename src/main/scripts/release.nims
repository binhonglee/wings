#!/usr/bin/env nim
from os import lastPathPart
import ./releaseConst
import strutils

mode = ScriptMode.Verbose

const folder: string = "release"
const main: string = "src/main/wings.nim"
const nimble: string = "~/.nimble/pkgs"
const release: string = "-d:release"
const ssl: string = "-d:ssl"
const ssl3: string = "-d:useOpenssl3"

proc build(version: string): void =
  exec(
    "nim " & version & " " & ssl & (if "linux" in getFilename(version): (" " & ssl3 & " ") else: " ") & release & " --verbosity:0 --NimblePath:" & nimble & " -o:" &
    folder & "/wings_" & getFilename(version) & " c " & main
  )

proc genRun(): void =
  if lastPathPart(getCurrentDir()) != "wings":
    echo "This script should be run on the top level folder instead."
    echo "Exiting..."
    return

  exec("nim c src/main/staticlang/main.nim")

  if paramCount() > 1 and paramStr(2) == "--all":
    var status: string = ""
    for i in options:
      try:
        build(i)
        status &= "\n  \u001b[32m[SUCCESS] " & getFilename(i) & "\u001b[0m"
      except:
        status &= "\n  \u001b[31m[FAILED]  " & getFilename(i) & "\u001b[0m"
    echo "Build status:" & status
    return
  else:
    build(getVersion())

  echo "Build successful. Exiting..."

genRun()
