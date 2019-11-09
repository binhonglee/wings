# wings.nim

## Imports

- os
    - createDir
    - fileExists
    - joinPath
    - paramCount
    - paramStr
    - parentDir
    - setCurrentDir
- strutils
    - startsWith
    - endsWith
- sets
- tables
- [wingspkg/core](wingspkg/core.md)
- [wingspkg/util/config](wingspkg/util/config.md)
- [wingspkg/util/log](wingspkg/util/log.md)

## Functions

#### `toFile: void`

Writing the generated output onto the files.

| Argument  | Type     | Description                                                |
| :-------- | :------- | :--------------------------------------------------------- |
| `path`    | `string` | Fullpath (including the filename) of the destination file. |
| `content` | `string` | Content to write into the specified file.                  |

#### `init: void`

Just a handler to go through each command line argument (and try to open them as a file).

| Argument | Type  | Description                                |
| :------- | :---  | :----------------------------------------- |
| `count`  | `int` | Number of command line arguments provided. |
