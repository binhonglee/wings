# winterface.nim

## Imports

- sets
- tables

## Type

### `IWings: ref object of RootObj`

| Argument       | Type                         | Description                                        |
| :------------- | :--------------------------- | :------------------------------------------------- |
| `name`         | `string`                     | Struct type name.                                  |
| `filename`     | `string`                     | Filename of the source wings file.                 |
| `dependencies` | `seq[string]`                | External wings files imported.                     |
| `filepath`     | `Table[string, string]`      | Map of filetype and each of its package.           |
| `imports`      | `Table[string, seq[string]]` | Map of filetype and a sequence of their import(s). |

## Functions

#### `fulfillDependency: bool`

Fulfill the required dependency (after dependant file is generated).

| Argument   | Type                  | Description                                             |
| :--------- | :-------------------- | :------------------------------------------------------ |
| iwings     | IWings                | Wings interface to fulfill dependency.                  |
| dependency | string                | Dependency to be fulfilled.                             |
| imports    | Table[string, string] | Filepaths of the generated files to be added as import. |
