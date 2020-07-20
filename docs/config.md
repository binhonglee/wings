# Config

These are the fields of the config file (`-c:<FILENAME>`). Currently its only supported in `json` format. Checkout the file in the repository ([here](https://github.com/binhonglee/wings/blob/devel/wings.json)) for reference.

## acronyms: `[]str`

You can specify specific cases where a word in a parameter name should be full caps instead of just camelCase or PascalCase. For eg, `ID` instead of `id` or `Id`.

See [here](https://binhonglee.github.io/stones/stones/cases.html#setAcronyms%2CHashSet%5Bstring%5D) for more information about how its used.

## header: `[]str`

This is the header comment to be added to the generated files. The array of strings will be joined with a `\n` character so you can have multiline comment by having each line of comment as a separate string in this array.

```json
{
    "header": [
        "Line 1",
        "Line 2",
        "etc..."
    ]
}
```

## langConfigs: `[]str`

The array of language config files to use. If this is left empty, it will just fallback to built-in supported [language template files](./template.md).

## langFilter: `[]str`

This is a filter to limit the language of output files to be generated. If left empty, all languages with the correct given [language template files](./template.md) will be generated. This is mostly for use if when you have multiple repository that sync with wings file but doesn't want duplicated unwanted generated file at different repository (eg. both frontend and backend repo would have the same wings file but you only want the TypeScript file in frontend and Go file in the backend so you set up different filter in each of the `wings.json`).

## logging: `int`

The `int` value represents how verbose the logging do you expect. Logging levels are defined [here](https://binhonglee.github.io/stones/stones/log.html#AlertLevel) as an Enum.

## outputRootDirs: `[]str`

There are scenario where you want to write the generated files to a different root path or write them to multiple different filepaths. You can clarify here which folder should be considered the root folder when creating the generated files. Empty string would mean the caller folder. Error will be thrown if a folder defined here cannot be found.

_Note: The call should be made in the deeper of the different folder hierarchies._

## prefixes: `Map<str,str>`

This is mainly created for `go` since the import path isn't just relative from the file calling it nor the top level location of the project folder but rather, something that can be defined in the `go.mod` file. This allows `go` to have customized import path prefix.

```json
{
    "prefixes": {
        "go": "github.com/binhonglee/wings"
    }
}
```

## skipImport: `bool`

When `skipimport` is set to `true`, wings will skip parsing and generating imported wings file(s) and only generate from the wings file given.
