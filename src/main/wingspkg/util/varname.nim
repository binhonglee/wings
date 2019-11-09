from strutils import capitalizeAscii, split, toUpperAscii

var acronyms = @["api", "id", "json", "url", "ui", "xml"]

proc setAcronyms*(configAcronyms: seq[string]): void =
    acronyms = configAcronyms

proc camelCase*(variable: string): string =
    let words: seq[string] = variable.split("_")
    result = ""

    for word in words:
        if acronyms.contains(word):
            result &= toUpperAscii(word)
        elif result == "":
            result &= word
        else:
            result &= capitalizeAscii(word)

proc alignment*(fields: seq[string]): seq[int] =
    result = newSeq[int](0)

    for fieldStr in fields:
        let field = fieldStr.split(' ')
        for i in 0..(field.len() - 1):
            if i >= result.len():
                result.add(field[i].len())
            else:
                if field[i].len() > result[i]:
                    result[i] = field[i].len()