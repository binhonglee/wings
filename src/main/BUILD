subinclude("//build_defs/nim")

nim_binary(
    name = "wings",
    main = "wings.nim",
    opts = ["-d:ssl"],
    deps = [
        ":files",
        ":stones",
    ],
)

nim_doc(
    name = "wings_api_doc",
    out = "docs/api/",
    commit = "devel",
    devel = "devel",
    index = True,
    index_out = "docs/api/index.html",
    main = "wings.nim",
    url = "https://wings.sh",
    visibility = [
        "//src/main/scripts:docs",
    ],
    deps = [
        ":files",
        ":stones",
    ],
)

nimble_install(
    name = "stones",
    pkg_name = "stones",
    revision = "#devel",
    visibility = [
        ":wings",
        ":wings_api_doc",
        "//src/main/staticlang:static",
    ],
)

filegroup(
    name = "files",
    srcs = ["//src/main/scripts:preCompile"],
    exported_deps = [
        "//src/main/scripts:releaseConst",
        "//src/main/wingspkg",
        "//src/main/wingspkg/lang",
        "//src/main/wingspkg/lib",
        "//src/main/wingspkg/util",
    ],
    visibility = [
        ":wings",
        ":wings_api_doc",
    ],
)
