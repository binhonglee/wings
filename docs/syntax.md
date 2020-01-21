# Syntax Keywords

Simple explanation on how the syntax works with wings. Rows that are unbounded and / or with undefined keywords will lead to an error being thrown.

## `{lang}-filepath`

Basically the path location of where the generated file lives relative to where the build is ran (which if you use Please or Nimble as suggested, it will always be at the top level folder of this project - `wings/`).

If the namespace for a specific language is not defined, the file for that language will not be generated.

## `{lang}-import`

Usually the `include` or `import` statement required for some part of the file to work properly. (In this case, its mostly external classes or enums for custom typing.)

## `import`

Similar to the above but this is specific to `include` or `import` another `wings` file.

## `{lang}-implement`

In many occassion, your struct or object might be implementing a separate interface class. Use this to specify the class that it is implementing. (There is not support for this in `go` since it would already inherently associate your struct to the interface if you implemented all the functions and variables defined in the interface.)

## `{lang}-func`

Specific functions for specific programming languages. Ideally, you should have a separate utility classes that do all the other operations. This is mostly designed to be used for defining functions in an interface that the struct / class is implementing.

## `#`

Comments for struct (usually description). This comment will be carried forward and included in the generated file.

## `//`

Comment in file. Unlike `#`, lines that begins with `//` will be ignored by the parser unless it is written inside the `{lang}Func()` where it would then be copied over to the generated file exactly the way it is. (Tabbing does not matter.)
