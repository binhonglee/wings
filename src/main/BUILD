subinclude('//build_defs/nim')

nim_binary(
    name = 'wings',
    main = 'wings.nim',
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
    visibility = ['PUBLIC'],
)
