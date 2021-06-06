from os import createDir, createSymlink, dirExists, fileExists, getHomeDir, moveFile, removeFile
import httpClient
import json
import "../../const" as c
import ../../scripts/releaseConst

const BIN = "bin/"
const WINGS = "wings"

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

  if not fileExists(homeDir & latestDir & WINGS):
    let downloadURL = "https://github.com/binhonglee/wings/releases/download/" &
      latestDir & "wings_" & getFilename(getVersion())
    echo "Downloading version " & latestVersion & "..."
    downloadFile(client, downloadURL, homeDir & latestDir & WINGS)
  else:
    echo "Version already exist. Skip downloading..."

  if not dirExists(homeDir & BIN):
    createDir(homeDir & BIN)

  if fileExists(homeDir & BIN & WINGS):
    removeFile(homeDir & BIN & WINGS)
  createSymlink(homeDir & latestDir & WINGS, homeDir & BIN & WINGS)
  echo "Now using version " & latestVersion  & "."

  echo "Make sure to add `export PATH=\"$HOME/wings/bin:$PATH\"` to your `.zshrc` or `.bashrc` file."
