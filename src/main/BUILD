subinclude('//build_defs/nim')

nim_binary(
  name = 'wings',
  main = 'wings.nim',
  opts = ['-d:ssl'],
  deps = [
    ':files',
    ':stones',
  ],
)

nimble_install(
  name = "stones",
  pkg_name = "stones",
  revision = "#devel",
  visibility = [
    ':wings',
    '//src/main/staticlang:static',
  ],
)

filegroup(
  name = 'files',
  srcs = ['//src/main/scripts:preCompile'],
  visibility = [
    ':wings',
  ],
  deps = [
    '//src/main/wingspkg',
    '//src/main/wingspkg/lang',
    '//src/main/wingspkg/lib',
    '//src/main/wingspkg/util',
    '//src/main/scripts:preCompile',
  ],
  exported_deps = [
    '//src/main/wingspkg',
    '//src/main/wingspkg/lang',
    '//src/main/wingspkg/lib',
    '//src/main/wingspkg/util',
  ],
)
