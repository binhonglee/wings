from os import createDir, createSymlink, dirExists, fileExists, getHomeDir, moveFile, removeFile
import httpClient
import json
import "../../const" as c

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

proc version(): string =
  if defined(linux) and defined(arm):
    result = options[0]
  elif defined(linux) and defined(i386):
    result = options[1]
  elif defined(linux) and defined(amd64):
    result = options[2]
  elif defined(windows) and defined(i386):
    result = options[3]
  elif defined(windows) and defined(amd64):
    result = options[4]
  elif defined(macosx) and defined(i386):
    result = options[5]
  elif defined(macosx) and defined(amd64):
    result = options[6]

proc upgrade*(): void =
  let client = newHttpClient()
  let homeDir = getHomeDir() & ".wings/"
  let releaseURL = "https://api.github.com/repos/binhonglee/wings/releases"
  let jsonConfig: JsonNode = parseJson(get(client, releaseURL).body)
  let latestVersion = jsonConfig.getElems()[0]["name"].str
  if c.VERSION == latestVersion:
    echo "Already using the latest version of wings."
    return

  if not dirExists(homeDir):
    createDir(homeDir)

  let latestDir = latestVersion & "/"
  if not dirExists(homeDir & latestDir):
    createDir(homeDir & latestDir)

  if not fileExists(homeDir & latestDir & "wings"):
    let downloadURL = "https://github.com/binhonglee/wings/releases/download/" &
      latestDir & "/wings_" & getFilename(version())
    echo "Downloading version " & latestVersion & "..."
    downloadFile(client, downloadURL, homeDir & latestDir & "wings")
  else:
    echo "Version already exist. Skip downloading..."

  if not dirExists(homeDir & "bin/"):
    createDir(homeDir & "bin/")

  if fileExists(homeDir & "bin/wings"):
    removeFile(homeDir & "bin/wings")
  createSymlink(homeDir & latestDir & "wings", homeDir & "bin/wings")
  echo "Now using version " & latestVersion  & "."

  echo "Make sure to add `export PATH=\"$HOME/wings/bin:$PATH\"` to your `.zshrc` or `.bashrc` file."
