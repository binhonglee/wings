from strutils import capitalizeAscii, split
from sequtils import foldr

proc camelCase*(variable: string): string =
    var words: seq[string] = variable.split("_")
    result = ""

    for word in words:
        if result == "":
            result &= word
        else:
            result &= capitalizeAscii(word)
