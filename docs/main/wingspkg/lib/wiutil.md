# wiutil.nim

## Imports

- tables
- [./winterface](./winterface.md)
- [./wenum](./wenum.md)
- [./wstruct](./wstruct.md)
- [../util/filename](../util/filename.md)
- [../util/header](../util/header.md)
- [../util/config](../util/config.md)
- [../lang/go](../lang/go.md)
- [../lang/kt](../lang/kt.md)
- [../lang/nim](../lang/nim.md)
- [../lang/py](../lang/py.md)
- [../lang/ts](../lang/ts.md)
- [../util/log](../util/log.md)

## Functions

#### `genWEnumFiles: Table[string, string]`

Generate the enum files for all the natively supported output types.

| Argument | Type     | Description                              |
| :------- | :------- | :--------------------------------------- |
| `wenum`  | `WEnum`  | `WEnum` object source for the out files. |
| `config` | `Config` | User config.                             |

#### `genWStructFiles: Table[string, string]`

Generate the struct files for all the natively supported output types.

| Argument  | Type      | Description                                |
| :-------- | :-------- | :----------------------------------------- |
| `wstruct` | `WStruct` | `WStruct` object source for the out files. |
| `config`  | `Config`  | User config.                               |

#### `genFiles: Table[string, string]`

Generate the corresponding files (WEnum or WStruct) for all the natively supported output types.

| Argument | Type     | Description                               |
| :------- | :------- | :---------------------------------------- |
| `this`   | `IWings` | `IWings` object source for the out files. |
| `config` | `Config` | User config.                              |