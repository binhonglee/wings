subinclude('//build_defs/nim')

nim_binary(
  name = 'wings',
  main = 'wings.nim',
  deps = [
    ':files',
    ':stones',
  ],
)

nimble_install(
  name = "stones",
  pkg_name = "stones",
  revision = "#devel",
  visibility = [':wings'],
)

filegroup(
  name = 'files',
  srcs = [],
  visibility = [
    ':wings',
    ':wings_doc',
  ],
  deps = [
    '//src/main/wingspkg',
    '//src/main/wingspkg/lang',
    '//src/main/wingspkg/lib',
    '//src/main/wingspkg/util',
  ],
  exported_deps = [
    '//src/main/wingspkg',
    '//src/main/wingspkg/lang',
    '//src/main/wingspkg/lib',
    '//src/main/wingspkg/util',
  ],
)
