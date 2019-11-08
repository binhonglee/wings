# config.nim

## Imports

- json
- os
    - fileExists
    - getCurrentDir
    - lastPathPart
    - parentDir
- strutils
    - join
- tables
- [./log](./log.md)

## Variable

| Name         | Type     | Description                                   |
| :----------- | :------- | :-------------------------------------------- |
| `CALLER_DIR` | `string` | The directory where the program is initiated. |

## Type

### `Config: object`

| Argument         | Type                    | Description                                           |
| :--------------- | :---------------------- | :---------------------------------------------------- |
| `header`         | `string`                | Header comment.                                       |
| `prefixes`       | `Table[string, string]` | Map of language to import prefix (only `go` for now). |
| `tabbing`        | `int`                   | Space count for tabbing (not currently used).         |
| `outputRootDirs` | `seq[string]`           | Header comment.                                       |

## Functions

#### `newConfig: Config`

Create a config to be used.

| Argument         | Type                    | Description                                           |
| :--------------- | :---------------------- | :---------------------------------------------------- |
| `header`         | `string`                | Header comment.                                       |
| `prefixes`       | `Table[string, string]` | Map of language to import prefix (only `go` for now). |
| `tabbing`        | `int`                   | Space count for tabbing (not currently used).         |
| `outputRootDirs` | `seq[string]`           | Header comment.                                       |

#### `parse: Config`

Parse the given config file in the path.

| Argument   | Type     | Description                               |
| :--------- | :------- | :---------------------------------------- |
| `filename` | `string` | Filename of the config file to be parsed. |