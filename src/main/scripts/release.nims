#!/usr/bin/env nim
from os import lastPathPart

mode = ScriptMode.Verbose

type
  MissingFilenameError* = object of ValueError

const folder: string = "release"
const main: string = "src/main/wings.nim"
const nimble: string = "plz-out/.nimble/pkgs"
const plz_run: string = "./pleasew run --show_all_output"
const plz_build: string = "./pleasew build --show_all_output"

const arm: string = "--cpu:arm -t:-marm -l:-marm"
const bit_32: string = "--cpu:i386 -t:-m32 -l:-m32"
const bit_64: string = "--cpu:amd64 -t:-m64 -l:-m64"

const windows: string = "-d:mingw"
const linux: string = "--os:linux -d:emscripten"
const macosx: string = "--os:macosx -d:emscripten"

const options: seq[string] =
  @[
    # This can be compiled separately and manually if you intend to get it.
    # linux & " " & arm,
    linux & " " & bit_32,
    linux & " " & bit_64,
    windows & " " & bit_32,
    windows & " " & bit_64,
    macosx & " " & bit_64,
  ]

proc getFilename(option: string): string =
  case option
  of linux & " " & arm:
    return "arm_linux"
  of linux & " " & bit_32:
    return "32bit_linux"
  of linux & " " & bit_64:
    return "64bit_linux"
  of windows & " " & bit_32:
    return "32bit_windows"
  of windows & " " & bit_64:
    return "64bit_windows"
  of macosx & " " & bit_64:
    return "64bit_macosx"
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
