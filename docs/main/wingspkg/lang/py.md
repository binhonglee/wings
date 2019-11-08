# py.nim

## Imports

- strutils
    - capitalizeAscii
    - endsWith
    - indent
    - replace
    - split
    - startsWith
- tables
    - getOrDefault
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

### `private`

#### `types: string`

Converts `wings` type to Python type.

| Argument | Type     | Description                               |
| :------- | :------- | :---------------------------------------- |
| `name`   | `string` | The defined `wings` type to be converted. |

#### `typeInit: string`

Provides the default to be initialzed based on its `wings` type.

| Argument | Type     | Description               |
| :------- | :------- | :------------------------ |
| `name`   | `string` | The defined `wings` type. |

#### `wEnumFile: string`

Generate the Python file with the given info.

| Argument | Type          | Description         |
| :------- | :------------ | :------------------ |
| `name`   | `string`      | Name of the enum.   |
| `values` | `seq[string]` | Values of the enum. |

#### `wStructFile: string`

Generate the Python file with the given info.

| Argument    | Type          | Description                         |
| :---------- | :------------ | :---------------------------------- |
| `name`      | `string`      | Name of the struct.                 |
| `imports`   | `seq[string]` | File imports                        |
| `fields`    | `seq[string]` | Struct fields.                      |
| `functions` | `string`      | Additional self defined functions.  |
| `implement` | `string`      | An external interface to implement. |
