type
  MissingFilenameError* = object of ValueError

type
  UnsupportedOSError* = object of ValueError

const arm*: string = "--cpu:arm -t:-marm -l:-marm"
const bit_32*: string = "--cpu:i386 -t:-m32 -l:-m32"
const bit_64*: string = "--cpu:amd64 -t:-m64 -l:-m64"

const windows*: string = "-d:mingw"
const linux*: string = "--os:linux"
const macosx*: string = "--os:macosx"

const options*: seq[string] =
  @[
    linux & " " & arm,
    linux & " " & bit_32,
    linux & " " & bit_64,
    windows & " " & bit_32,
    windows & " " & bit_64,
    macosx & " " & bit_32,
    macosx & " " & bit_64,
  ]

proc getFilename*(option: string): string =
  case option
  of linux & " " & arm:
    return "arm_linux"
  of linux & " " & bit_32:
    return "32bit_linux"
  of linux & " " & bit_64:
    return "64bit_linux"
  of windows & " " & bit_32:
    return "32bit_windows.exe"
  of windows & " " & bit_64:
    return "64bit_windows.exe"
  of macosx & " " & bit_32:
    return "32bit_macosx"
  of macosx & " " & bit_64:
    return "64bit_macosx"
  else:
    raise newException(
      MissingFilenameError,
      "Filename not found for compile variant. This usually happens when " &
      "a variant is added to the release script but its filename is not " &
      "defined in `getFilename()`."
    )

proc getVersion*(): string =
  if defined(linux) and defined(arm):
    result = options[0]
    echo "ARM Linux detected"
  elif defined(linux) and defined(i386):
    result = options[1]
    echo "32 bits Linux detected"
  elif defined(linux) and defined(amd64):
    result = options[2]
    echo "64 bits Linux detected"
  elif defined(windows) and defined(i386):
    result = options[3]
    echo "32 bits Windows detected"
  elif defined(windows) and defined(amd64):
    result = options[4]
    echo "64 bits Windows detected"
  elif defined(macosx) and defined(i386):
    result = options[5]
    echo "64 bits MacOS detected"
  elif defined(macosx) and defined(amd64):
    result = options[6]
    echo "64 bits MacOS detected"
  else:
    raise newException(
      UnsupportedOSError,
      "Unsupported OS version detected."
    )
