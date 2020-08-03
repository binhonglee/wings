#!/usr/bin/env nim
from os import lastPathPart

mode = ScriptMode.Verbose

const build: string = "build"
const serve: string = "serve"
const docLicense: string = "docs/license.md"

proc run(cmd: string): void =
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
