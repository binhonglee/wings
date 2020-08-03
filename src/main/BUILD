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

nim_doc(
  name = 'wings_api_doc',
  main = 'wings.nim',
  out = 'docs/api/',
  index = True,
  index_out = "docs/api/index.html",
  url = 'https://wings.sh',
  commit = 'devel',
  devel = 'devel',
  deps = [
    ':files',
    ':stones',
  ],
  visibility = [
    '//src/main/scripts:docs',
  ]
)

nimble_install(
  name = "stones",
  pkg_name = "stones",
  revision = "#devel",
  visibility = [
    ':wings',
    ':wings_api_doc',
    '//src/main/staticlang:static',
  ],
)

filegroup(
  name = 'files',
  srcs = ['//src/main/scripts:preCompile'],
  visibility = [
    ':wings',
    ':wings_api_doc',
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
