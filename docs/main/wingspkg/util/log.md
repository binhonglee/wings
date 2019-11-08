# log.nim

## Imports

- strutils
    - indent
- terminal

## Type

### `GenericException: object of Exception`

### `AlertLevel: enum`

| Name         | Value |
| :----------- | :---- |
| `FATAL`      | 0     |
| `ERROR`      | 1     |
| `SUCCESS`    | 2     |
| `DEPRECATED` | 3     |
| `WARNING`    | 4     |
| `INFO`       | 5     |

## Variable

| Name    | Type         | Description                           |
| :------ | :----------- | :------------------------------------ |
| `LEVEL` | `AlertLevel` | Global alert level (set from config). |

## Functions

### `LOG: void`

Log message (and possibly throw error).

| Argument    | Type         | Description                                       |
| :---------- | :----------- | :------------------------------------------------ |
| `level`     | `AlertLevel` | Level of alert (`FATAL` would throw exception).   |
| `message`   | `string`     | Logging message.                                  |
| `exception` | `typedesc`   | Exception to be thrown (if the level is `FATAL`). |

### `setLevel: void`

Setter for `LEVEL`.

| Argument | Type         | Description                      |
| :------- | :----------- | :------------------------------- |
| `level`  | `AlertLevel` | Set `LEVEL` to this given level. |
