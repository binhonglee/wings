subinclude('//build_defs/nim')

nim_binary(
    name = 'wings',
    main = 'wings.nim',
    deps = [':files'],
)

nim_doc(
    name = 'wings_doc',
    main = 'wings.nim',
    deps = [':files'],
    url = 'https://github.com/binhonglee/wings',
)

filegroup(
    name = 'files',
    srcs = [
        'wingspkg/core.nim',
        'wingspkg/plz.nim',
        'wingspkg/lang/go.nim',
        'wingspkg/lang/kt.nim',
        'wingspkg/lang/nim.nim',
        'wingspkg/lang/py.nim',
        'wingspkg/lang/ts.nim',
        'wingspkg/lib/wenum.nim',
        'wingspkg/lib/winterface.nim',
        'wingspkg/lib/wiutil.nim',
        'wingspkg/lib/wstruct.nim',
        'wingspkg/util/config.nim',
        'wingspkg/util/filename.nim',
        'wingspkg/util/header.nim',
        'wingspkg/util/log.nim',
        'wingspkg/util/varname.nim',
    ],
    visibility =  [
        ':wings',
        ':wings_doc',
    ]
)