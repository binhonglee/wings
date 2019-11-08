# core.nim

## Imports

- strutils
    - capitalizeAscii
    - contains
    - endsWith
    - join
    - normalize
    - parseEnum
    - removeSuffix
    - split
    - splitWhitespace
-   tables
-   [lib/wenum](lib/wenum.md)
-   [lib/wstruct](lib/wstruct.md)
-   [lib/winterface](lib/winterface.md)
-   [lib/wiutil](lib/wiutil.md)
-   [util/config](util/config.md)
-   [util/log](util/log.md)

## Functions

#### (DEPRECATED) `fromFile: Table[string, string]`

Entry point to the file. It gets the file to read and returns a table of output to be written.

| Argument   | Type     | Description                        |
| :--------- | :------- | :--------------------------------- |
| `filename` | `string` | Filename of the file to read from. |
| `header`   | `string` | Customized header.                 |

#### `fromFiles: Table[string, Table[string, string]]`

Entry point to the file. It gets all the files to read and returns a table of output to be written.

| Argument    | Type          | Description                         |
| :---------- | :------------ | :---------------------------------- |
| `filenames` | `seq[string]` | Filename of the files to read from. |
| `config`    | `Config`      | User config.                        |
