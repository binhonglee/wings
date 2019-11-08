# filename.nim

## Imports

- os
    - unixToNativePath
- tables
- strutils
    - capitalizeAscii
    - join
    - split
- sequtils
    - foldr
- [./log](./log.md)

## Functions

#### `filename: Table[string, string]`

Generate the filename map of filetype to filename.

| Argument         | Type                    | Description                                             |
| :--------------- | :---------------------- | :------------------------------------------------------ |
| `filename`       | `string`                | Original filename.                                      |
| `filepath`       | `Table[string, string]` | Map of filetype to its output filepath.                 |
| `customJoin`     | `Table[string, char]`   | Path joiner char.                                       |
| `filetypeSuffix` | `bool`                  | If filetype suffix should be appended to filename.      |
| `useNativePath`  | `bool`                  | Turn unix path to native path (especially for Windows). |

#### `outputFilename: Table[string, string]`

Generate the filename map of filetype to filename for output path.

| Argument         | Type                    | Description                                             |
| :--------------- | :---------------------- | :------------------------------------------------------ |
| `filename`       | `string`                | Original filename.                                      |
| `filepath`       | `Table[string, string]` | Map of filetype to its output filepath.                 |

#### `importFilename: Table[string, string]`

Generate the filename map of filetype to filename for import use.

| Argument         | Type                    | Description                                      |
| :--------------- | :---------------------- | :----------------------------------------------- |
| `filename`       | `string`                | Original filename.                               |
| `filepath`       | `Table[string, string]` | Map of filetype to its output filepath.          |
| `callerFilepath` | `Table[string, string]` | Map of filetype to source filepath importing it. |
| `prefixes`       | `Table[string, string]` | Map of filetype to its import prefix.            |
