from sequtils import toSeq
from strutils import contains, parseInt, removePrefix,
    spaces, replace, split, splitWhitespace, startsWith, strip
from tempconst import wrap, TK_SPACED
import streams
import sets
import tables
import log, strlib, genlib
import ./tconfig, ./templatable, ./winterface

const MK_BEGIN: string = "BEGIN_"
const MK_END: string = "END_"
const MK_PREFIX: string = "// #"

proc rows(format: string, replacements: seq[Table[string, string]]): string =
    result = ""
    var res: seq[seq[string]] = newSeq[seq[string]](replacements.len())
    var width: seq[int] = newSeq[int](0)

    for i in countup(0, replacements.len() - 1, 1):
        let line: seq[string] = seqCharToString(
            toSeq(format.items).replace(replacements[i])
        ).split(" " & wrap(TK_SPACED) & " ")
        let w: seq[int] = width(line)
        if width.len() > 0:
            for j in countup(0, w.len() - 1, 1):
                if w[j] > width[j]:
                    width[j] = w[j]
        else:
            width = w
        res[i] = line

    for r in res:
        var line: string = ""
        for i in countup(0, width.len() - 2, 1):
            line &= r[i] & spaces(width[i] - r[i].len() + 4)
        line &= r[r.len() - 1]
        if result.len() > 0:
            result &= "\n"
        result &= line

proc multiRow(kw: string, inputs: seq[Table[string, string]], t: string): string =
    result = ""
    let format: string = t.replace(MK_PREFIX & kw & " ", "")
    result = rows(format, inputs)

proc multiWords(keyword: string, inputs: HashSet[string], givenTemplate: string): string =
    result = ""
    var brokenDownInput: Table[int, seq[Table[string, string]]] =
        initTable[int, seq[Table[string, string]]]()
    for input in inputs:
        let temp: seq[string] = input.split(':')
        if not brokenDownInput.hasKey(temp.len()):
            brokenDownInput.add(temp.len(), newSeq[Table[string, string]](0))
        var words: Table[string, string] = initTable[string, string]()
        var i: int = 1
        for str in temp:
            words.add(wrap(keyword, $i), str)
            inc(i)
        brokenDownInput[temp.len()].add(words)

    var templateTypes: seq[string] = givenTemplate.split('\n')
    for templateType in templateTypes:
        if not templateType.contains(MK_PREFIX & keyword):
            continue

        var count: int = 0
        try:
            count = parseInt($(
                templateType.replace(
                    MK_PREFIX & keyword,
                    ""
                ).strip()[0]
            ))
        except:
            LOG(DEBUG, "'" & keyword & "' only have 1 version.")

        if not brokenDownInput.hasKey(count):
            continue

        let row: string = templateType.replace(
            MK_PREFIX & keyword & $count & " ", ""
        )
        if result.len() > 0:
            result &= "\n"
        result &= rows(row, brokenDownInput[count])

proc genFile*(templatable: Templatable, tconfig: TConfig, wingsType: WingsType): string =
    if not templatable.langBasedReps.hasKey(tconfig.filetype):
        LOG(
            FATAL,
            "`genFile()` should only be called on templatable containing that language type."
        )

    if not tconfig.templates.hasKey($wingsType):
        LOG(FATAL, "No template found for the given type and language.")

    let givenTemplate: StringStream = newStringStream(tconfig.templates[$wingsType])

    result = ""
    var line: string = ""
    var lineNo: int = 1
    while givenTemplate.readLine(line):
        if not line.contains(MK_PREFIX):
            result &= "\n" & line
        elif line.startsWith(MK_PREFIX & MK_BEGIN):
            var keyword = line
            keyword.removePrefix(MK_PREFIX & MK_BEGIN)
            var prefix: string = ""
            while givenTemplate.readLine(line) and not line.contains(
                MK_PREFIX & keyword
            ) and not line.startsWith(MK_PREFIX & MK_END & keyword):
                if prefix.len() > 0:
                    prefix &= "\n"
                prefix &= line
                inc(lineNo)
            var templateText: string = ""
            if not line.startsWith(MK_PREFIX & MK_END & keyword):
                templateText = line
                while givenTemplate.readLine(line) and line.contains(
                    MK_PREFIX & keyword
                ) and not line.startsWith(MK_PREFIX & MK_END & keyword):
                    if templateText.len() > 0:
                        templateText &= "\n"
                    templateText &= line
                    inc(lineNo)
            var postfix: string = ""
            if not line.startsWith(MK_PREFIX & MK_END & keyword):
                postfix = line
                while givenTemplate.readLine(line) and not line.startsWith(
                    MK_PREFIX & MK_END & keyword
                ):
                    if postfix.len() > 0:
                        postfix &= "\n"
                    postfix &= line
                    inc(lineNo)

            var output: string = ""
            if templatable.langBasedReps[tconfig.filetype].hasKey(wrap(keyword)):
                output = multiRow(
                    keyword,
                    @[templatable.langBasedReps[tconfig.filetype]],
                    templateText
                )
            elif templatable.langBasedMultireps[tconfig.filetype].hasKey(wrap(keyword)):
                output = multiWords(
                    keyword,
                    templatable.langBasedMultireps[tconfig.filetype][wrap(keyword)],
                    templateText
                )
            else:
                output = multiRow(keyword, templatable.fields, templateText)

            if postfix.len() > 0:
                output = output & "\n" & postfix
            if prefix.len() > 0:
                output = prefix & "\n" & output

            if output.len() > 0:
                result &= "\n" & output
        else:
            LOG(
                ERROR,
                "Multiline declarations should have `" &
                MK_PREFIX & MK_BEGIN & "{KEYWORD}` and `" &
                MK_PREFIX & MK_BEGIN & "{KEYWORD}` declarations"
            )

        inc(lineNo)
    var reps: Table[string, string] = templatable.replacements
    reps.merge(templatable.langBasedReps[tconfig.filetype])
    givenTemplate.close()
    result = seqCharToString(toSeq(result.items).replace(reps))
