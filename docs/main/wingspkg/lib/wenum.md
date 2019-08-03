# wenum.nim

## Imports

-   strutils
    -   splitWhitespace
-   tables

## Type

### `WEnum: object`

| Argument  | Type                    | Description                              |
| :-------- | :---------------------- | :--------------------------------------- |
| `name`    | `string`                | Enum type name.                          |
| `values`  | `seq[string]`           | All the enum values.                     |
| `package` | `Table[string, string]` | Map of filetype and each of its package. |

## Functions

### `public`

#### `newWEnum: WEnum`

Returns an empty initialized `WEnum`.

#### `parseFile: void`

Parse the `WEnum` from the given file to the given `WEnum` object.

| Argument   | Type                    | Description                                        |
| :--------- | :---------------------- | :------------------------------------------------- |
| `wenum`    | `WEnum`                 | Target `WEnum` to parse the data from the file to. |
| `file`     | `File`                  | Source file to parse data from.                    |
| `filename` | `string`                | Name of source file.                               |
| `package`  | `Table[string, string]` | Package of the result file should be in.           |
