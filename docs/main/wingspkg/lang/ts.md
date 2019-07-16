# ts.nim

## Imports

-   strutils
    -   contains
    -   indent
    -   intToStr
    -   split

## Functions

### `public`

#### `enumFile: string`

Generate the TypeScript file based on the given enum file info.

| Name      | Type          | Description                        |
| :-------- | :------------ | :--------------------------------- |
| `name`    | `string`      | Name of the enum.                  |
| `values`  | `seq[string]` | Values of the enum.                |

#### `structFile: string`

Generate the TypeScript file based on the given struct file info.

| Name        | Type          | Description                          |
| :---------- | :------------ | :----------------------------------- |
| `name`      | `string`      | Name of the struct.                  |
| `imports`   | `seq[string]` | File imports                         |
| `fields`    | `seq[string]` | Struct fields.                       |
| `functions` | `string`      | Additional self defined functions.   |
| `implement`   | `string`    | An external interface to implement.  |

### `private`

#### `types: string`

Converts `wings` type to TypeScript type.

| Argument | Type     | Description               |
| :------- | :------- | :------------------------ |
| `name`   | `string` | The defined `wings` type. |

#### `typeInit: string`

Provides the default to be initialzed based on its `wings` type.

| Argument | Type     | Description               |
| :------- | :------- | :------------------------ |
| `name`   | `string` | The defined `wings` type. |

#### `typeAssign: string`

Assign the `content` the way it should be based on the `name` (type).

| Argument  | Type     | Description               |
| :-------- | :------- | :------------------------ |
| `name`    | `string` | The defined `wings` type. |
| `content` | `string` | Content to be assigned.   |
