#!/usr/bin/env nim
from os import lastPathPart

mode = ScriptMode.Verbose

const gitURL: string = "https://github.com/binhonglee/wings"
const folder: string = "docs/main"
const main: string = "src/main/wings.nim"
const devel: string = "devel"
const build: string = "build"
const serve: string = "serve"
const docLicense: string = "docs/license.md"

proc run(cmd: string): void =
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
  rmFile(docLicense)
  cpFile("LICENSE", docLicense)

  try:
    exec("mkdocs -v " & cmd)
  except:
    discard

proc genRun(): void =
  if lastPathPart(getCurrentDir()) != "wings":
    echo "This script should be run on the top level folder instead."
    echo "Exiting..."
    return

  if (paramCount() > 2):
    echo "This script can only take in 1 parameter. Use -h for more info."
    return

  if (paramCount() < 2):
    run(build)
    return

  case paramStr(2)
  of "-h":
    echo build
    echo "  Generate all the documentations into static webpages in the `site` folder."
    echo serve
    echo "  Run mkdocs development server for realtime feedback on changes made `docs` folder"
    return
  of build:
    run(build)
  of serve:
    run(serve)
  else:
    echo "Invalid argument `" & paramStr(2) & "`."
    echo "Try `-h` for help."

genRun()
