#!/usr/bin/env nim
from os import lastPathPart

mode = ScriptMode.Verbose

type
  MissingFilenameError* = object of ValueError

const folder: string = "release"
const main: string = "src/main/wings.nim"
const nimble: string = "plz-out/.nimble/pkgs"
const plz_args: string = " --nocolour --nocache --plain_output --verbosity=error"
const plz_run: string = "./pleasew run"
const release: string = "-d:release"
const ssl: string = "-d:ssl"

const arm: string = "--cpu:arm -t:-marm -l:-marm"
const bit_32: string = "--cpu:i386 -t:-m32 -l:-m32"
const bit_64: string = "--cpu:amd64 -t:-m64 -l:-m64"

const windows: string = "-d:mingw"
const linux: string = "--os:linux"
const macosx: string = "--os:macosx"

const options: seq[string] =
  @[
    linux & " " & arm,
    linux & " " & bit_32,
    linux & " " & bit_64,
    windows & " " & bit_32,
    windows & " " & bit_64,
    macosx & " " & bit_32,
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
  of macosx & " " & bit_32:
    return "32bit_macosx"
  of macosx & " " & bit_64:
    return "64bit_macosx"
  else:
    raise newException(
      MissingFilenameError,
      "Filename not found for compile variant. This usually happens when " &
      "a variant is added to the release script but its filename is not " &
      "defined in `getFilename()`."
    )

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
  elif defined(linux) and defined(arm):
    build(options[0])
    echo "Running build for ARM Linux"
  elif defined(linux) and defined(i386):
    build(options[1])
    echo "Running build for 32 bits Linux"
  elif defined(linux) and defined(amd64):
    build(options[2])
    echo "Running build for 64 bits Linux"
  elif defined(windows) and defined(i386):
    build(options[3])
    echo "Running build for 32 bits Windows"
  elif defined(windows) and defined(amd64):
    build(options[4])
    echo "Running build for 64 bits Windows"
  elif defined(macosx) and defined(i386):
    build(options[5])
    echo "Running build for 64 bits MacOS"
  elif defined(macosx) and defined(amd64):
    build(options[6])
    echo "Running build for 64 bits MacOS"
  else:
    echo "Unsupported OS version"
    return

  echo "Build successful. Exiting..."

genRun()
