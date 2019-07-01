from os import paramCount, paramStr
from strutils import split
import tables
import wingspkg/core
import wingspkg/plz

proc getHeader(source: string): string =
    var header = """
/* This is a generated file
 *
 * If you would like to make any changes, please edit the source file instead.
 * run `nimble genFile "{SOURCE_FILE}"` upon completion.
"""

    return header & " * Source: " & source & "\n */\n\n"

proc toFile(path: string, content: string, source: string): void =
    try:
        writeFile(path, getHeader(source) & content)
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
        # try:
            fromFile(paramStr(i))
        # except:
            # echo "File " & paramStr(i) & " Not Found."
init(paramCount())
