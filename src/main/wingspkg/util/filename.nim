from os import DirSep, unixToNativePath
from strutils import capitalizeAscii, join, split
from sequtils import foldr
import strlib
import ../lib/tconfig

proc similarity(first: seq[string], second: seq[string]): int =
    result = 0
    var same: bool = true

    while same:
        if result >= first.len() or result >= second.len() or first[result] != second[result]:
            same = false
        else:
            result += 1

proc filename(
    filename: string,
    filepath: string,
    langConfig: TConfig,
    filetypeSuffix: bool = false,
    useNativePath: bool = false,
): string =
    var separator: char = DirSep
    if not useNativePath:
        separator = langConfig.importPath.separator
    let temp: seq[string] = filename.split(DirSep)
    let name = temp[temp.len() - 1].split('.')[0]
    result = ""

    var prefix: string = foldr(
        filepath.split(DirSep),
        a & separator & b,
    ) & separator

    var suffix: string = ""
    if filetypeSuffix:
        suffix = "." & langConfig.filetype

    result = prefix & format(langConfig.filename, name) & suffix
    if useNativePath:
        result =  unixToNativePath(result)

proc outputFilename*(
    filename: string,
    filepath: string,
    langConfig: TConfig,
): string =
    filename(filename, filepath, langConfig, true, true)

proc importFilename*(
    filename: string,
    filepath: string,
    callerFilename: string,
    callerFilepath: string,
    langConfig: TConfig,
): string =
    result = ""
    if langConfig.importPath.pathType != ImportPathType.Never:
        var selfPath: seq[string] = filename(
            filename,
            filepath,
            langConfig,
        ).split(langConfig.importPath.separator)
        let callerPath: seq[string] = filename(
            callerFilename,
            callerFilepath,
            langConfig,
        ).split(langConfig.importPath.separator)

        var prefix: string = ""
        if langConfig.importPath.prefix.len() > 0:
            prefix = langConfig.importPath.prefix &
                $langConfig.importPath.separator

        if langConfig.importPath.pathType == ImportPathType.Absolute:
            var tempCaller = callerPath
            tempCaller.setLen(tempCaller.len() - langConfig.importPath.level)
            var tempSelf = selfPath
            tempSelf.setLen(tempSelf.len() - langConfig.importPath.level)

            let pos: int = similarity(tempSelf, tempCaller)
            if pos == tempSelf.len() and pos == tempCaller.len():
                result = ""
            else:
                result = prefix &
                    selfPath.join($langConfig.importPath.separator)
        elif langConfig.importPath.pathType == ImportPathType.Relative:
            let pos: int = similarity(selfPath, callerPath)

            for i in countup(pos, callerPath.len() - 2, 1):
                if result != "":
                    result &= langConfig.importPath.separator
                result &= ".."

            if result == "":
                result &= "."

            for i in countup(pos, selfPath.len() - 1, 1):
                result &= langConfig.importPath.separator & selfPath[i]

proc tFilename*(filename: string, filepath: string): string =
    result = importFilename(
        filename,
        filepath, "", "",
        initTConfig(
            ipt = ImportPathType.Absolute,
            level = 0
        )
    )