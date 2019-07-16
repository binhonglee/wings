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
-   [lang/go](lang/go.md)
-   [lang/ts](lang/ts.md)
-   [lang/kt](lang/kt.md)
-   [lang/nim](lang/nim.md)

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

#### `enumFile: Table[string, string]`

Read content of a `.enum` file and generate the desired enum file(s). Output key represents output filetype while output value are generated enum file content.

| Argument   | Type                    | Description                                        |
| :--------- | :---------------------- | :------------------------------------------------- |
| `file`     | `File`                  | File to read from.                                 |
| `filename` | `string`                | Full path of the source file.                      |
| `package`  | `Table[string, string]` | Table with filetypes as key and filepath as value. |

#### `newFileName: Table[string, string]`

Generate the appropriate filename based on the naming convention of the given file types. Output key represents the filetype while output value are the filename

| Argument   | Type     | Description                  |
| :--------- | :------- | :--------------------------- |
| `filename` | `string` | Filename of the source file. |

#### `structFile: Table[string, string]`

Read content of a `.struct` file and generate the desired struct file(s). Output key represents output filetype while output value are generated struct file content.

| Argument   | Type                    | Description                                                        |
| :--------- | :---------------------- | :----------------------------------------------------------------- |
| `file`     | `File`                  | File to read from.                                                 |
| `filename` | `string`                | Full path of the source file (including the filename).             |
| `package`  | `Table[string, string]` | A table with output filetypes as key and output filepath as value. |
