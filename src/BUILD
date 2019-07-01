subinclude('//build_defs/nim')

nim_binary(
    name = 'wings',
    main = 'wings.nim',
    srcs = [
        'wingspkg/core.nim',
        'wingspkg/plz.nim',
        'wingspkg/lang/go.nim',
        'wingspkg/lang/kt.nim',
        'wingspkg/lang/ts.nim',
    ],
    visibility = ['PUBLIC'],
)
