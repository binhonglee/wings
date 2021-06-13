subinclude("//build_defs/nim")

nimscript(
    name = "docs",
    main = "docs.nims",
    deps = ["//src/main:wings_api_doc"],
)

nimscript(
    name = "release",
    main = "release.nims",
    refs = {
        "releaseConst": ":releaseConst",
    },
)

nim_run_script(
    name = "preCompile",
    outs = ["const.nim"],
    main = "preCompile.nims",
    out_path = "src/main",
    visibility = ["//src/main:files"],
)

filegroup(
    name = "releaseConst",
    srcs = ["releaseConst.nim"],
    visibility = ["PUBLIC"],
)
