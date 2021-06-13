subinclude("//build_defs/nim")

nim_binary(
    name = "static",
    srcs = [
        "const.nim",
    ],
    main = "main.nim",
    opts = ["-d:ssl"],
    deps = [
        "//src/main:stones",
        "//src/main/wingspkg/lib",
    ],
)
