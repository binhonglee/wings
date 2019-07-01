# Package

version       = "0.0.1"
author        = "BinHong Lee"
description   = "A simple cross language struct and enum file generator."
license       = "MIT"
srcDir        = "src"
bin           = @["wings"]

# Dependencies

requires "nim >= 0.17.2"

task genFile, "Generate file(s)":
    exec "nimble build"
    var start = false
    var ran = false
    for i in countup(0, paramCount(), 1):
        if start:
            exec "./wings " & paramStr(i)

            if not ran:
                ran = true
        elif paramStr(i) == "genFile":
            start = true

    if not ran:
        exec "./wings "