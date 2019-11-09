# varname.nim

## Imports

- strutils
    - capitalizeAscii
    - split
- sequtils
    - foldr

## Functions

#### `camelCase: string`

Converts the input string to camelCase.

| Argument   | Type     | Description                          |
| :--------- | :------- | :----------------------------------- |
| `variable` | `string` | String to be converted to camelCase. |

#### `setAcronyms: string`

Set the specific set of words (usually acronyms) that will use all caps instead of just capitalized.

| Argument            | Type          | Description                    |
| :------------------ | :------------ | :----------------------------- |
| `configAcronyms` | `seq[string]` | Custom words from user config. |
