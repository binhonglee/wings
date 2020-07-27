subinclude('//build_defs/nim')

nim_binary(
  name = 'static',
  main = 'main.nim',
  srcs = [
    'const.nim',
  ],
  deps = [
    '//src/main/wingspkg/lib',
    '//src/main:stones',
  ],
)
