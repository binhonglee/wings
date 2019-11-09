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
- sets
- tables
- [./log](./log.md)
- [./varname](./varname.md)
    - setAcronyms

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
| `outputRootDirs` | `HashSet[string]`       | Output directory root path.                           |

## Functions

#### `newConfig: Config`

Create a config to be used.

| Argument         | Type                    | Description                                           |
| :--------------- | :---------------------- | :---------------------------------------------------- |
| `header`         | `string`                | Header comment.                                       |
| `prefixes`       | `Table[string, string]` | Map of language to import prefix (only `go` for now). |
| `tabbing`        | `int`                   | Space count for tabbing (not currently used).         |
| `outputRootDirs` | `HashSet[string]`       | Output directory root path.                           |

#### `parse: Config`

Parse the given config file in the path.

| Argument   | Type     | Description                               |
| :--------- | :------- | :---------------------------------------- |
| `filename` | `string` | Filename of the config file to be parsed. |