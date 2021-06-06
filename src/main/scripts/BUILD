subinclude('//build_defs/nim')

nimscript(
  name = 'docs',
  main = 'docs.nims',
  deps = ['//src/main:wings_api_doc'],
)

nimscript(
  name = 'release',
  main = 'release.nims',
)

nim_run_script(
  name = 'preCompile',
  main = 'preCompile.nims',
  outs = ['const.nim'],
  out_path = 'src/main',
  deps = [':releaseConst'],
  visibility = ['//src/main:files'],
)

filegroup(
  name = 'releaseConst',
  srcs = ['releaseConst.nim'],
  visibility = ['PUBLIC'],
)
