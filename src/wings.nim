from os import paramCount, paramStr
from strutils import split
import tables
import wingspkg/core

proc toFile(path: string, content: string, source: string): void =
    try:
        writeFile(path, content)
    except:
        echo "Please create the required folder to host the new files to be created and run this again."

proc fromFile(filepath: string): void =
    var source: string = filepath
    var outputFiles: Table[string, string] = core.fromFile(source)

    for path in outputFiles.keys:
        toFile(path, outputFiles[path], source)

proc init(count: int): void =
    if count < 1:
        echo "Please add struct or enum files to be generated."
        return

    for i in countup(1, count, 1):
        try:
            fromFile(paramStr(i))
        except:
            echo "File " & paramStr(i) & " Not Found."
init(paramCount())
