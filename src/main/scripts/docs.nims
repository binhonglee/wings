#!/usr/bin/env nim
from os import lastPathPart

mode = ScriptMode.Verbose

const gitURL: string = "https://github.com/binhonglee/wings"
const folder: string = "docs/main"
const main: string = "src/main/wings.nim"
const devel: string = "devel"

proc genRun(): void =
  if lastPathPart(getCurrentDir()) != "wings":
    echo "This script should be run on the top level folder instead."
    echo "Exiting..."
    return

  if dirExists(folder):
    rmDir(folder)

  exec(
    "nim doc --project --index:on -o:" & folder &
    "/ --git.url:" & gitURL &
    " --git.commit:" & devel &
    " --git.devel:" & devel & " " & main
  )

  exec("nim buildIndex -o:" & folder & "/theindex.html " & folder)
  mvFile(folder & "/theindex.html", folder & "/index.html")

genRun()
