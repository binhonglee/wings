#!/usr/bin/env nim
from os import lastPathPart

mode = ScriptMode.Verbose

type
  MissingFilenameError* = object of Exception

const folder: string = "release"
const main: string = "src/main/wings.nim"
const nimble: string = "plz-out/.nimble/pkgs"
const plz_run: string = "./pleasew run --show_all_output"
const plz_build: string = "./pleasew build --show_all_output"
const options: seq[string] =
  @[
    # This can be compiled separately and manually if you intend to get it.
    # "--os:linux --cpu:arm -t:-marm -l:-marm",
    "--os:linux --cpu:i386 -t:-m32 -l:-m32",
    "--os:linux --cpu:amd64",
    "-d:mingw --cpu:i386 -t:-m32 -l:-m32",
    "-d:mingw --cpu:amd64",
  ]

proc getFilename(option: string): string =
  case option
  of "--os:linux --cpu:arm -t:-marm -l:-marm":
    return "arm_unix"
  of "--os:linux --cpu:i386 -t:-m32 -l:-m32":
    return "32bit_unix"
  of "--os:linux --cpu:amd64":
    return "64bit_unix"
  of "-d:mingw --cpu:i386 -t:-m32 -l:-m32":
    return "32bit_windows"
  of "-d:mingw --cpu:amd64":
    return "64bit_windows"
  else:
    raise newException(
      MissingFilenameError,
      "Filename not found for compile variant. This usually happens when " &
      "a variant is added to the release script but its filename is not " &
      "defined in `getFilename()`."
    )


proc genRun(): void =
  if lastPathPart(getCurrentDir()) != "wings":
    echo "This script should be run on the top level folder instead."
    echo "Exiting..."
    return

  exec(plz_run & " //src/main/staticlang:static")
  exec(plz_build & " //src/main:wings")

  for i in options:
    exec(
      "nim " & i & " --verbosity:2 --NimblePath:" & nimble & " -o:" &
      folder & "/wings_" & getFilename(i) & " c " & main
    )

genRun()
