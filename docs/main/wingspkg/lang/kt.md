# ts.nim

## Imports

- strutils
    - contains
    - endsWith
    - indent
    - removePrefix
    - removeSuffix
    - replace
    - split
    - startsWith
- tables
    - getOrDefault
- [../util/varname](../util/varname)
    - camelCase
- [../util/log](../util/log)
- [../lib/wstruct](../lib/wstruct)
- [../lib/wenum](../lib/wenum)

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
