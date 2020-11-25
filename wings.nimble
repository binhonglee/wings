# Package

version      = "0.0.4"
author       = "BinHong Lee"
description  = "A simple cross language struct and enum file generator."
license      = "MIT"
skipDirs     = @["examples"]
bin          = @["wings"]
srcDir       = "src/main"
installExt   = @["nim"]

# While it should still work for any nim version over 1.0.0, its only actively
# tested against 1.4.0 due to some changes in 1.4.0 causing some inconsistency
# in the generated code (breaking CI).
requires "nim >= 1.4.0"
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
