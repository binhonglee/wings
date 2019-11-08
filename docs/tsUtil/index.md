# index.ts

## Interface

### `IWingsStruct`

`toJsonKey`

Converts given variable names into their predefined JSON key (in the original `.struct` / `.enum` file).

| Argument | Type | Description |
| :------- | :--- | :---------- |
| `key` | `string` | Variable name to be converted into JSON key. |

## Class

### `WingsStructUtil`

_Note: All functions are static functions._

#### `public`

`isIWingsStruct: arg is IWingsStruct`

Returns if the object provided in `arg` is an `IWingsStruct`.

| Argument | Type | Description |
| :------- | :--- | :---------- |
| `arg` | `any` | Object to be tested. |

`stringify: string`

Returns a JSON in string format of the given object in `obj` .

| Argument | Type | Description |
| :------- | :--- | :---------- |
| `obj` | `any` | Object to be stringified. |

#### `private`

`valString: string`

Turns the given `val` into its appropriate string format to be included as part of the JSON output (for `stringify()`).

| Argument | Type | Description |
| :------- | :--- | :---------- |
| `val` | `any` | Value to be turned into a `string`. |

`wrap: string`

Wrap and return the given string with a double quote around it.

| Argument | Type | Description |
| :------- | :--- | :---------- |
| `toWrap` | `string` | String to be wrapped. |
