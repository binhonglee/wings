from strutils import indent

proc arr(name: string, arr: seq[string]): string =
    var condition: string = ""

    result = name & " = ["
    for i in countup(0, arr.len - 1, 1):
        condition &= "\n'" & arr[i] & "',"
    var after: string = "\n],"

    result &= indent(condition, 4, " ") & after

proc goPlzBuild*(
    name: string,
    deps: seq[string],
    visibility: seq[string]
): string =
    ## Generate the `go_library()` declaration for please build file.
    var buildRule: string = ""

    result = "go_library("
    buildRule &= "\nname = '" & name & "',"
    buildRule &= "\nsrcs = ['" & name & ".go'],"

    if deps.len > 0:
        buildRule &= "\n" & arr("deps", deps)

    if visibility.len > 0:
        buildRule &= "\n" & arr("visibility", visibility)

    var after: string = "\n)\n"

    result &= indent(buildRule, 4, " ") & after
