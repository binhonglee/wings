from strutils import indent

proc genHeader*(filetype: string, source: string, text: string = ""): string =
    result = """
This is a generated file

If you would like to make any changes, please edit the source file instead.
"""

    if len(text) > 0:
        result = text

    result &= "\nSource: " & source

    case filetype
    of "go", "kt", "ts":
        result = "/*\n" &
            indent(result, 1, " * ") &
            "\n */"
    of "nim", "py":
        result = indent(result, 1, "# ")

    result &= "\n\n"