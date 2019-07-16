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

## Functions

### `public`

#### `enumFile: string`

Generate the Go file based on the given enum file info.

| Argument  | Type          | Description                        |
| :-------- | :------------ | :--------------------------------- |
| `name`    | `string`      | Name of the enum.                  |
| `values`  | `seq[string]` | Values of the enum.                |
| `package` | `string`      | The package where this enum is in. |

#### `structFile: string`

Generate the Go file based on the given struct file info.

| Argument    | Type          | Description                          |
| :---------- | :------------ | :----------------------------------- |
| `name`      | `string`      | Name of the struct.                  |
| `imports`   | `seq[string]` | File imports                         |
| `fields`    | `seq[string]` | Struct fields.                       |
| `functions` | `string`      | Additional self defined functions.   |
| `package`   | `string`      | The package where this struct is in. |

### `private`

#### `types: string`

Converts `wings` type to Go type.

| Argument | Type     | Description                               |
| :------- | :------- | :---------------------------------------- |
| `name`   | `string` | The defined `wings` type to be converted. |
