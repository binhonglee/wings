from os
import FilePermission, fileExists, paramCount, paramStr, setFilePermissions
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

proc init(count: int): void =
    if count < 1:
        echo "Please add struct or enum files to be generated."
        return

    var temp: seq[string] = newSeq[string](0)
    for i in countup(1, count, 1):
        temp.add(paramStr(i))

    var outputFiles = fromFiles(temp, header, {"go": "github.com/binhonglee/wings"}.toTable)
    for files in outputFiles.keys:
        for filetype in outputFiles[files].keys:
            toFile(filetype, outputFiles[files][filetype])

init(paramCount())
