# go.nim

## Imports

-   strutils
    -   capitalizeAscii
    -   contains
    -   toLowerAscii
    -   replace
    -   indent
    -   split
    -   unindent
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

Converts `wings` type to Go type.

| Argument | Type     | Description                               |
| :------- | :------- | :---------------------------------------- |
| `name`   | `string` | The defined `wings` type to be converted. |

#### `wEnumFile: string`

Generate the Go file with the given info.

| Argument  | Type          | Description                        |
| :-------- | :------------ | :--------------------------------- |
| `name`    | `string`      | Name of the enum.                  |
| `values`  | `seq[string]` | Values of the enum.                |
| `package` | `string`      | The package where this enum is in. |

#### `wStructFile: string`

Generate the Go file with the given info.

| Argument    | Type          | Description                          |
| :---------- | :------------ | :----------------------------------- |
| `name`      | `string`      | Name of the struct.                  |
| `imports`   | `seq[string]` | File imports                         |
| `fields`    | `seq[string]` | Struct fields.                       |
| `functions` | `string`      | Additional self defined functions.   |
| `package`   | `string`      | The package where this struct is in. |
