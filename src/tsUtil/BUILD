filegroup(
    name = "npm_files",
    srcs = [
        "package.json",
        "package-lock.json",
    ],
    visibility = [
        ":install",
        ":tsUtil",
    ],
)

genrule(
    name = "install",
    outs = ["node_modules"],
    cmd = " && ".join([
        "CURRENT=$(pwd)",
        "cd $PKG_DIR/",
        "npm install",
        "mv node_modules $CURRENT/node_modules",
    ]),
    needs_transitive_deps = True,
    output_is_complete = False,
    deps = [":npm_files"],
)

filegroup(
    name = "index",
    srcs = [
        "index.ts",
    ],
    visibility = [
        ":tsUtil",
    ],
)

genrule(
    name = "tsUtil",
    srcs = ["tsconfig.json"],
    outs = ["dist"],
    cmd = " && ".join([
        "CURRENT=$(pwd)",
        "cd $PKG_DIR/",
        "npm run build",
        "mv dist $CURRENT/dist",
    ]),
    needs_transitive_deps = True,
    output_is_complete = False,
    deps = [
        ":index",
        ":install",
    ],
)

gentest(
    name = "mocha",
    srcs = [
        ".mocharc.json",
        "scripts/testPrep.ts",
        "test/index.test.ts",
    ],
    cmd = " && ".join([
        "cd $PKG_DIR/",
        "npm run cover",
    ]),
    needs_transitive_deps = True,
    no_test_output = True,
    output_is_complete = False,
    test_cmd = "echo \"Do nothing~\"",
    deps = [
        ":tsUtil",
        "//examples:genFiles",
    ],
)
