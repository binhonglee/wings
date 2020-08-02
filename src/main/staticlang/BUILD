subinclude('//build_defs/nim')

nim_binary(
  name = 'static',
  main = 'main.nim',
  srcs = [
    'const.nim',
  ],
  opts = ['-d:ssl'],
  deps = [
    '//src/main/wingspkg/lib',
    '//src/main:stones',
  ],
)
