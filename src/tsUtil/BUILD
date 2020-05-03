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
  output_is_complete = False,
  needs_transitive_deps = True,
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
  deps = [
    ":index",
    ":install",
  ],
  output_is_complete = False,
  needs_transitive_deps = True,
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
  test_cmd = "echo \"Do nothing~\"",
  no_test_output = True,
  deps = [
    "//examples:genFiles",
    ":tsUtil",
  ],
  output_is_complete = False,
  needs_transitive_deps = True,
)
