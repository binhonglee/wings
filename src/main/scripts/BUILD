subinclude('//build_defs/nim')

nimscript(
  name = 'docs',
  main = 'docs.nims',
)

nimscript(
  name = 'release',
  main = 'release.nims',
)

nim_run_script(
  name = 'preCompile',
  main = 'preCompile.nims',
  outs = ['const.nim'],
  post_script = 'mv src/main/const.nim ./',
  visibility = ['//src/main:files'],
)
