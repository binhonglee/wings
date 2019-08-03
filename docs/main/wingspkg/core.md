# core.nim

## Imports

-   strutils
    -   capitalizeAscii
    -   contains
    -   join
    -   normalize
    -   parseEnum
    -   removeSuffix
    -   split
    -   splitWhitespace
-   tables
-   [lib/header](lib/header.md)
-   [lib/wenum](lib/wenum.md)
-   [lib/wstruct](lib/wstruct.md)
-   [util/wenumutil](util/wenumutil.md)
-   [util/wstructutil](util/wstructutil.md)

## Constants

| Name        | Type                 | Description                                                          |
| :---------- | :------------------- | :------------------------------------------------------------------- |
| `filetypes` | `Table[string, int]` | Table to iterate through as a collection of all supported filetypes. |

## Functions

### `public`

#### `fromFile: Table[string, string]`

Entry point to the file. It gets the file to read and returns a table of output to be written.

| Argument            | Type     | Description                        |
| :------------------ | :------- | :--------------------------------- |
| `filename`          | `string` | Filename of the file to read from. |
| `header` (Optional) | `string` | Customized header.                 |

### `private`

#### `newFileName: Table[string, string]`

Generate the appropriate filename based on the naming convention of the given file types. Output key represents the filetype while output value are the filename

| Argument   | Type     | Description                  |
| :--------- | :------- | :--------------------------- |
| `filename` | `string` | Filename of the source file. |
