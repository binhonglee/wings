from strutils import indent

proc arr*(name: string, arr: seq[string]): string =
    var condition: string = ""

    var before: string = name & " = ["
    for i in countup(0, arr.len - 1, 1):
        condition &= "\n'" & arr[i] & "',"
    var after: string = "\n],"

    return before & indent(condition, 4, " ") & after

proc goPlzBuild*(
    name: string,
    deps: seq[string],
    visibility: seq[string]
): string =
    var buildRule: string = ""

    var before: string = "go_library("
    buildRule &= "\nname = '" & name & "',"
    buildRule &= "\nsrcs = ['" & name & ".go'],"

    if deps.len > 0:
        buildRule &= "\n" & arr("deps", deps)

    if visibility.len > 0:
        buildRule &= "\n" & arr("visibility", visibility)

    var after: string = "\n)\n"

    return before & indent(buildRule, 4, " ") & after
