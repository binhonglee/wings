# wstruct.nim

## Imports

- strutils
    - contains
    - endsWith
    - join
    - removeSuffix
    - split
    - splitWhitespace
- sequtils
    - foldr
- sets
- tables
- [../util/config](../util/config.md)
- [../util/log](../util/log.md)
- [./winterface](./winterface.md)
    - IWings

## Type

### `WStruct: ref object of [IWings](./winterface)`

| Argument   | Type                    | Description                               |
| :--------- | :---------------------- | :---------------------------------------- |
| `comment`  | `string`                | Struct type comment.                      |
| `fields`   | `seq[string]`           | All the struct fields.                    |
| `function` | `Table[string, string]` | Map of filetype and each of its function. |

## Functions

#### `newWStruct: WStruct`

Returns an empty initialized `WStruct`.

#### `parseFile: bool`

Parse the `WStruct` from the given file to the given `WStruct` object.

| Argument   | Type                    | Description                                          |
| :--------- | :---------------------- | :--------------------------------------------------- |
| `wstruct`  | `WStruct`               | Target `WStruct` to parse the data from the file to. |
| `file`     | `File`                  | Source file to parse data from.                      |
| `filename` | `string`                | Name of source file.                                 |
| `filepath` | `Table[string, string]` | Filepath of the result file should be in.            |
| `config`   | `Config`                | User config.                                         |
