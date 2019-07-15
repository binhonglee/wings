from strutils import indent

proc genHeader*(filetype: string, source: string, text: string = ""): string =
    var header = """
This is a generated file

If you would like to make any changes, please edit the source file instead.
run `nimble genFile "{SOURCE_FILE}"` upon completion.
"""

    if len(text) > 0:
        header = text

    header &= "\nSource: " & source

    case filetype
    of "go", "kt", "ts":
        header = "/*\n" &
            indent(header, 1, " * ") &
            "\n */"
    of "nim", "py":
        header = indent(header, 1, "# ")

    return header & "\n\n"