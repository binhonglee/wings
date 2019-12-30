from genlib import getResult
from strlib import Case
from strutils import contains, endsWith, removePrefix, split, startsWith
import log
import tables
import ./tempconst

const DEFAULT_SEPARATOR*: char = '/'
const DEFAULT_COMMENT*: string = "//"

type
    ImportPathType* = enum
        ## Supported import path types.
        Never = 0,
        Absolute = 1,
        Relative = 2,

type
    ImportPath = object
        format*: string
        pathType*: ImportPathType
        prefix*: string
        separator*: char
        level*: int

type
    TypeInterpreter* = object
        ## Post processed custom types
        prefix*: string
        separators*: string
        postfix*: string
        output*: string

type
    TConfig* = object
        ## Object of template config.
        comment*: string
        customTypes*: Table[string, TypeInterpreter]
        customTypeInits*: Table[string, TypeInterpreter]
        filename*: Case
        filetype*: string
        implementFormat*: string
        importPath*: ImportPath
        parseFormat*: string
        templates*: Table[string, string]
        types*: Table[string, string]
        typeInits*: Table[string, string]

proc initTypeInterpreter(
    prefix: string = "",
    separators: string = "",
    postfix: string = "",
    output: string = "",
): TypeInterpreter =
    result = TypeInterpreter()
    result.prefix = prefix
    result.separators = separators
    result.postfix = postfix
    result.output = output

proc interpretType*(inputType: string, outputType: string): TypeInterpreter =
    ## Interpret custom types.
    if not inputType.contains(TYPE_PREFIX):
        LOG(
            ERROR,
            "Types without '" &
            TYPE_PREFIX &
            "' should never be passed into interpretType()"
        )
    result = initTypeInterpreter()

    let splittedInput: seq[string] = inputType.split(TYPE_PREFIX)
    if splittedInput.len() == 1:
        if not inputType.startsWith(TYPE_POSTFIX):
            LOG(ERROR, "Types with only 1 external type should use {TYPE} instead of {TYPE#}")

        result.postfix = getResult[string](splittedInput[0], TYPE_POSTFIX, removePrefix)
    elif splittedInput.len() == 2:
        result.prefix = splittedInput[0]
        result.postfix = getResult[string](splittedInput[1], TYPE_POSTFIX, removePrefix)
    else:
        var count: int = 1
        if splittedInput[0].startsWith($count & TYPE_POSTFIX):
            result.separators = getResult[string](
                splittedInput[0],
                $count & TYPE_POSTFIX,
                removePrefix
            )
            inc(count)
        else:
            result.prefix = splittedInput[0]

        while count < splittedInput.len() - 1:
            if result.separators.len() < 1:
                result.separators = getResult[string](
                    splittedInput[count],
                    $count & TYPE_POSTFIX,
                    removePrefix
                )
            elif result.separators != getResult[string](
                splittedInput[count],
                $count & TYPE_POSTFIX,
                removePrefix
            ):
                LOG(FATAL, "Use of multiple different separators is currently unsupported.")
            inc(count)

        result.postfix = getResult[string](
            splittedInput[count],
            $count & TYPE_POSTFIX,
            removePrefix
        )
    result.output = outputType

proc initTConfig*(
    cmt: string = DEFAULT_COMMENT,
    ct: Table[string, TypeInterpreter] = initTable[string, TypeInterpreter](),
    cti: Table[string, TypeInterpreter] = initTable[string, TypeInterpreter](),
    c: Case = Case.Default,
    ft: string = "",
    ifmt: string = "",
    ipfmt: string = "",
    ipt: ImportPathType = ImportPathType.Never,
    pfx: string = "",
    sep: char = DEFAULT_SEPARATOR,
    level: int = 0,
    pfmt: string = "",
    temp: Table[string, string] = initTable[string, string](),
    ty: Table[string, string] = initTable[string, string](),
    ti: Table[string, string] = initTable[string, string](),
): TConfig =
    ## Create an initialized template config.
    result = TConfig()
    result.comment = cmt
    result.customTypes = ct
    result.customTypeInits = cti
    result.filename = c
    result.filetype = ft
    result.implementFormat = ifmt
    result.importPath = ImportPath()
    result.importPath.format = ipfmt
    result.importPath.pathType = ipt
    result.importPath.prefix = pfx
    result.importPath.separator = sep
    result.importPath.level = level
    result.parseFormat = pfmt
    result.templates = temp
    result.types = ty
    result.typeInits = ti
