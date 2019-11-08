# nim.nim

## Imports

- strutils
    - capitalizeAscii
    - contains
    - endsWith
    - indent
    - normalize
    - removePrefix
    - removeSuffix
    - replace
    - split
    - startsWith
- tables
    - getOrDefault
- [../util/varname](../util/varname.md)
    - camelCase
- [../util/log](../util/log.md)
- [../lib/wstruct](../lib/wstruct.md)
- [../lib/wenum](../lib/wenum.md)

## Functions

### `public`

#### `genWEnum: string`

Converts the given `WEnum` object to an enum file.

| Argument | Type    | Description                         |
| :------- | :------ | :---------------------------------- |
| `wenum`  | `WEnum` | Object with all information needed. |

#### `genWStruct: string`

Converts the given `WStruct` object to a struct file.

| Argument  | Type      | Description                         |
| :-------- | :-------- | :---------------------------------- |
| `wstruct` | `WStruct` | Object with all information needed. |
