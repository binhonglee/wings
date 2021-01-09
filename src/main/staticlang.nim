from os import paramCount, paramStr
import staticlang/main
import stones/log

proc genFiles(inputPath: string, outputPath: string): void =
  init(inputPath, outputPath)

if paramCount() != 2:
  LOG(FATAL, "Invalid number of parameters. There should be 2 params specified, the input path and the output path.")
else:
  genFiles(paramStr(1), paramStr(2))
