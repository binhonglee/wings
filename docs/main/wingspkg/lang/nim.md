# nim.nim

## Imports

-   strutils
    -   capitalizeAscii
    -   contains
    -   indent
    -   normalize
    -   replace
    -   split
-   tables
    -   getOrDefault
-   [../lib/varname](../lib/varname)
    -   camelCase
-   [../lib/wstruct](../lib/wstruct)
-   [../lib/wenum](../lib/wenum)

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

Converts `wings` type to Nim type.

| Argument | Type     | Description                               |
| :------- | :------- | :---------------------------------------- |
| `name`   | `string` | The defined `wings` type to be converted. |

#### `typeAssign: string`

Assign the `content` the way it should be based on the `name` (type).

| Argument  | Type     | Description               |
| :-------- | :------- | :------------------------ |
| `name`    | `string` | The defined `wings` type. |
| `content` | `string` | Content to be assigned.   |

#### `wEnumFile: string`

Generate the Nim file with the given info.

| Argument | Type          | Description         |
| :------- | :------------ | :------------------ |
| `name`   | `string`      | Name of the enum.   |
| `values` | `seq[string]` | Values of the enum. |

#### `wStructFile: string`

Generate the Nim file with the given info.

| Argument    | Type          | Description                        |
| :---------- | :------------ | :--------------------------------- |
| `name`      | `string`      | Name of the struct.                |
| `imports`   | `seq[string]` | File imports                       |
| `fields`    | `seq[string]` | Struct fields.                     |
| `functions` | `string`      | Additional self defined functions. |
