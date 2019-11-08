# header.nim

## Imports

- strutils
    - indent

## Functions

#### `genHeader: string`

Returns a string of a header generated based on given expected output filetype (since different programming languages have different way of writing comments).

_Note: There will always be a line at the end of the header pointing to the source file._

| Argument          | Type     | Description                                  |
| :---------------- | :------- | :------------------------------------------- |
| `filetype`        | `string` | Target programming languages for the header. |
| `source`          | `string` | The source file .                            |
| `text` (Optional) | `string` | Personalized header text.                    |
