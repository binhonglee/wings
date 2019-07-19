from os
import FilePermission, fileExists, paramCount, paramStr, setFilePermissions
from strutils import split
import tables
import wingspkg/core

const header: string ="""
This is a generated file

If you would like to make any changes, please edit the source file instead.
run `nimble genFile "{SOURCE_FILE}"` upon completion.
"""

proc toFile(path: string, content: string): void =
    try:
        if fileExists(path):
            setFilePermissions(
                path, {
                    FilePermission.fpUserWrite,
                    FilePermission.fpGroupWrite,
                    FilePermission.fpOthersWrite
                }
            )
        writeFile(path, content)
        setFilePermissions(
            path, {
                FilePermission.fpUserRead,
                FilePermission.fpGroupRead,
                FilePermission.fpOthersRead
            }
        )
    except:
        echo "Please create the required folder for files to be generated."

proc fromFile(filepath: string): void =
    var source: string = filepath
    var outputFiles: Table[string, string] = core.fromFile(source, header)

    for path in outputFiles.keys:
        toFile(path, outputFiles[path])

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
