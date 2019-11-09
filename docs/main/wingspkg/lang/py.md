# py.nim

## Imports

- strutils
    - capitalizeAscii
    - endsWith
    - indent
    - replace
    - split
    - startsWith
    - unindent
- tables
    - getOrDefault
- [../lib/wstruct](../lib/wstruct.md)
- [../lib/wenum](../lib/wenum.md)
- [../util/config](../util/config.md)

## Functions

#### `genWEnum: string`

Converts the given `WEnum` object to an enum file.

| Argument | Type     | Description                         |
| :------- | :------- | :---------------------------------- |
| `wenum`  | `WEnum`  | Object with all information needed. |
| `config` | `Config` | User config.                        |

#### `genWStruct: string`

Converts the given `WStruct` object to a struct file.

| Argument  | Type      | Description                         |
| :-------- | :-------- | :---------------------------------- |
| `wstruct` | `WStruct` | Object with all information needed. |
| `config`  | `Config`  | User config.                        |
