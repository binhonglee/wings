# wenum.nim

## Imports

- strutils
    - splitWhitespace
- tables
- [../util/config](../util/config.md)
- [../util/log](../util/log.md)
- [./winterface](./winterface.md)
    - IWings

## Type

### `WEnum: ref object of [IWings](./winterface)`

| Argument  | Type                    | Description                              |
| :-------- | :---------------------- | :--------------------------------------- |
| `values`  | `seq[string]`           | All the enum values.                     |

## Functions

#### `newWEnum: WEnum`

Returns an empty initialized `WEnum`.

#### `parseFile: bool`

Parse the `WEnum` from the given file to the given `WEnum` object.

| Argument   | Type                    | Description                                        |
| :--------- | :---------------------- | :------------------------------------------------- |
| `wenum`    | `WEnum`                 | Target `WEnum` to parse the data from the file to. |
| `file`     | `File`                  | Source file to parse data from.                    |
| `filename` | `string`                | Name of source file.                               |
| `package`  | `Table[string, string]` | Package of the result file should be in.           |
| `config`   | `Config`                | User config.                                       |
