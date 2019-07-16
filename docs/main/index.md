# wings.nim

## Imports

-   os
    -   paramCount
    -   paramStr
-   tables
-   [wingspkg/core](wingspkg/core.md)

## Functions

### `private`

#### `toFile: void`

Writing the generated output onto the files.

| Argument | Type | Description |
| :------- | :--- | :---------- |
| `path` | `string` | Fullpath (including the filename) of the destination file. |
| `content` | `string` | Content to write into the specified file. |

#### `fromFile: void`

Read from struct / enum file.

| Argument | Type | Description |
| :------- | :--- | :---------- |
| `filepath` | `string` | Full path (can be either relative or absolute) of where the file to read is at. |

#### `init: void`

Just a handler to go through each command line argument (and try to open them as a file).

| Argument | Type | Description |
| :------- | :--- | :---------- |
| `count` | `int` | Number of command line arguments provided. |
