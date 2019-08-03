# wstruct.nim

## Imports

-   strutils
    -   contains
    -   join
    -   removeSuffix
    -   split
    -   splitWhitespace
-   sequtils
    -   foldr
-   tables

## Type

### `WStruct: object`

| Argument    | Type                         | Description                                        |
| :---------- | :--------------------------- | :------------------------------------------------- |
| `name`      | `string`                     | Struct type name.                                  |
| `fields`    | `seq[string]`                | All the struct fields.                             |
| `function`  | `Table[string, string]`      | Map of filetype and each of its function.          |
| `implement` | `Table[string, string]`      | Map of filetype and each of its implement.         |
| `package`   | `Table[string, string]`      | Map of filetype and each of its package.           |
| `imports`   | `Table[string, seq[string]]` | Map of filetype and a sequence of their import(s). |

## Functions

### `public`

#### `newWStruct: WStruct`

Returns an empty initialized `WStruct`.

#### `parseFile: void`

Parse the `WStruct` from the given file to the given `WStruct` object.

| Argument   | Type                   | Description                                          |
| :--------- | :--------------------- | :--------------------------------------------------- |
| `wstruct`  | `WStruct`              | Target `WStruct` to parse the data from the file to. |
| `file`     | `File`                 | Source file to parse data from.                      |
| `filename` | `string`               | Name of source file.                                 |
| `package`  | `Table[string, string]` | Package of the result file should be in.             |
