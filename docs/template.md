# Template

This is for more advanced used where you want your own way of formatting for output file or if you use wings for languages that is not currently supported. Check out the [examples/input/template](https://github.com/binhonglee/wings/tree/master/examples/input/templates) folder for an example of how it works for currently supported languages.

_\* indicates required field. Non-required fields will have its default value specified below._

## comment*: `str`

Language line prefix for comments (eg. `//` in TypeScript or `#` in Python).

## filename*: [`Case`](https://binhonglee.github.io/stones/stones/cases.html#Case)

The Case / format in which the output filename should be in.

## filetype*: `str`

This is used for deduplication of language template files and also to be appended to the generated filename ending as filetype.

## importPath*: `obj`

### format*: `str`

The format in which import path are written in. Default is just `{#IMPORT}`.

### pathType: `"never" || "absolute" || "relative"`

`DEFAULT`: `"never"`

This is to define how the import path should be written for the imported files.

### prefix: `str`

`DEFAULT`: `""`

Prefix for import path. Will be overwritten by the `prefix` value in the project config if already defined there.

### level: `int`

`DEFAULT`: `0`

The level of folder the import should run and stop at. `0` is the lowest possible number which refers to the file itself, `1` refers to the folder the file is in and so on.

## implementFormat: `str`

`DEFAULT`: `""`

The string in which is used in the specific language to declare that the current class extends or implements an existing different class.

## importedFormat: `str`

`DEFAULT`: `""`

This is for when a wings type is imported from another wings type and certain languages (like `go`) has different type declaration for imported type vs type declared in the same package.

## indentation: `obj`

### spacing: `str`

`DEFAULT`: `""`

Define the "tab" width. This **WOULD NOT** replace the existing tabbing in your template files but rather is used to properly indent functions declared in the wings file.

### preIndent: `bool`

`DEFAULT`: `false`

This is to define if the imported functions should be indented in the output file.

## templates*: `obj`

(WIP: Support downloading remote files.)

### struct*: `str`

Filepath to the struct template file.

### enum*: `str`

Filepath to the enum template file.

## types*: `obj[]`

### wingsType*: `str`

Type to be parsed from wings file.

### targetType*: `str`

Generated type for output language.

### targetInit: `str`

`DEFAULT`: `""`

Initialization for target output type.

### requiredImport: `str`

`DEFAULT`: `""`

Specific import that is needed to be added when this type is in use.
