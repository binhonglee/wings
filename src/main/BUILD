subinclude('@pleasings//nim')

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
        'wingspkg/lib/header.nim',
    ],
    visibility = ['PUBLIC'],
)
