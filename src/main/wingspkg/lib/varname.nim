from strutils import capitalizeAscii, split, toUpperAscii
from sequtils import foldr

const customWords = @["id"]

proc camelCase*(variable: string): string =
    var words: seq[string] = variable.split("_")
    result = ""

    for word in words:
        if customWords.contains(word):
            result &= toUpperAscii(word)
        elif result == "":
            result &= word
        else:
            result &= capitalizeAscii(word)
