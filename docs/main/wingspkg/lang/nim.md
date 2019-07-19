# nim.nim

## Imports

-   strutils
    -   contains
    -   indent
    -   replace
    -   split

## Functions

### `public`

#### `enumFile: string`

Generate the Nim file based on the given enum file info.

| Argument | Type          | Description         |
| :------- | :------------ | :------------------ |
| `name`   | `string`      | Name of the enum.   |
| `values` | `seq[string]` | Values of the enum. |

#### `structFile: string`

Generate the Nim file based on the given struct file info.

| Argument    | Type          | Description                        |
| :---------- | :------------ | :--------------------------------- |
| `name`      | `string`      | Name of the struct.                |
| `imports`   | `seq[string]` | File imports                       |
| `fields`    | `seq[string]` | Struct fields.                     |
| `functions` | `string`      | Additional self defined functions. |

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
