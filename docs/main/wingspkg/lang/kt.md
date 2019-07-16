# ts.nim

## Imports

-   strutils
    -   contains
    -   indent
    -   replace
    -   split

## Functions

### `public`

#### `enumFile: string`

Generate the Kotlin file based on the given enum file info.

| Name      | Type          | Description                        |
| :-------- | :------------ | :--------------------------------- |
| `name`    | `string`      | Name of the enum.                  |
| `values`  | `seq[string]` | Values of the enum.                |
| `package` | `string`      | The package where this enum is in. |

#### `structFile: string`

Generate the Kotlin file based on the given struct file info.

| Name        | Type          | Description                          |
| :---------- | :------------ | :----------------------------------- |
| `name`      | `string`      | Name of the struct.                  |
| `imports`   | `seq[string]` | File imports                         |
| `fields`    | `seq[string]` | Struct fields.                       |
| `functions` | `string`      | Additional self defined functions.   |
| `implement` | `string`      | An external interface to implement.  |
| `package`   | `string`      | The package where this struct is in. |

### `private`

#### `types: string`

Converts `wings` type to Kotlin type.

| Argument | Type     | Description               |
| :------- | :------- | :------------------------ |
| `name`   | `string` | The defined `wings` type. |

#### `typeInit: string`

Provides the default to be initialzed based on its `wings` type.

| Argument | Type     | Description               |
| :------- | :------- | :------------------------ |
| `name`   | `string` | The defined `wings` type. |
