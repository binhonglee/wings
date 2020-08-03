# Template

This is for more advanced use case where you want your own way of formatting for the output files or if you use wings for languages that is not currently supported. Check out the [examples/input/template](https://github.com/binhonglee/wings/tree/devel/examples/input/templates) folder for an example of how it works for currently supported languages (start from the json files).

_\* indicates required field. Non-required fields will have its default value specified._

## comment*: `str`

Language line prefix for comments (eg. `//` in TypeScript or `#` in Python).

## filename*: [`Case`](https://binhonglee.github.io/stones/stones/cases.html#Case)

The Case / format in which the output filename should be in.

## filetype*: `str`

This is used for deduplication of language template files and also to be appended to the generated filename ending as filetype.

## implementFormat: `str`

```
default: "{#IMPLEMENT}"
```

The string in which is used in the specific language to declare that the current class extends or implements an existing different class.

## importPath*: `obj`

### format: `str`

```
default: "{#IMPORT}"
```

The format in which import path are written in.

### separator: `str`

```
default: '/'
```

The way files / folders are joined. Some programming languages uses '.' in import path instead of '/'.

### pathType*: `"never" || "absolute" || "relative"`

This is to define how the import path should be written for the imported files.

### prefix: `str`

```
default: ""
```

Prefix for import path. Will be overwritten by the `prefix` value in the project config if already defined there.

### level*: `int`

The level of folder the import should run and stop at. `0` is the lowest possible number which refers to the file itself, `1` refers to the folder the file is in and so on.

_\*Note: Only required when `pathType` is not set to `"never"`_

## indentation: `obj`

### spacing: `str`

```
default: ""
```

Define the "tab" width. This **WOULD NOT** replace the existing tabbing in your template files but rather is used to properly indent functions declared in the wings file.

### preIndent: `bool`

```
default: false
```

This is to define if the imported functions should be indented in the output file.

## parseFormat: `str`

```
default: ""
```

General fallback option for the more specific `targetParse` below if that's not defined.

## templates*: `obj`

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

```
default: ""
```

Initialization for target output type.

### requiredImport: `str`

```
default: ""
```

Specific import that is needed to be added when this type is in use.
