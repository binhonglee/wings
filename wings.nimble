# Package

version      = "0.0.2"
author       = "BinHong Lee"
description  = "A simple cross language struct and enum file generator."
license      = "MIT"
skipDirs     = @["examples"]
bin          = @["wings"]
srcDir       = "src/main"
installExt   = @["nim"]

requires "nim >= 1.0.0"
requires "stones#devel"

task genFile, "Generate file(s)":
  exec "nimble build"
  var start = false
  var temp: string = ""
  for i in countup(0, paramCount(), 1):
    if start:
      temp &= " " & paramStr(i)
    elif paramStr(i) == "genFile":
      start = true
  exec "./wings" & temp
