# wings

A simple cross language struct and enum file generator. (You might want to use a linter with this to clean up some trailing whitespaces and uneven tabbings.)

## Requirements

-   [Nim](https://nim-lang.org/)
    -   [Nimble](https://github.com/nim-lang/nimble) - Bundled with Nim. (optional)
-   [Please](https://please.build) (alternative to nimble)

\*_Note: Replace `plz` with `./pleasew` if you do not have please installed._

## Supported languages

-   [go](http://golang.org/)
-   [Kotlin](https://kotlinlang.org) (Untested)
-   [Nim](https://nim-lang.org/)
-   [TypeScript](https://www.typescriptlang.org)
    -   [Useful utility package](https://github.com/binhonglee/wings-ts-util)

## Supported types

| wings    | go          | Kotlin              | Nim         | TypeScript |
| :------- | :---------- | :------------------ | :---------- | :--------- |
| `int`    | `int`       | `Int`               | `int`       | `number`   |
| `str`    | `string`    | `String`            | `string`    | `string`   |
| `bool`   | `bool`      | `Boolean`           | `bool`      | `boolean`  |
| `date`   | `time.Time` | `Date`              | `DateTime`  | `Date`     |
| `[]type` | `[]type`    | `ArrayList\<type\>` | `seq[type]` | `[]`       |

_Unsupported types are initialized as custom struct / classes unless specified otherwise._

Run `nimble genFile "{filepath}"` or `plz run //src:wings -- "{filepath}"` to generate the files.

## Struct

example/student.struct

```text
go-filepath examples/go/classroom
kt-filepath examples/kt
ts-filepath examples/ts
nim-filepath examples/nim

go-import time
go-import homework:path/to/homework
ts-import People:./People
ts-import Homework:path/to/Homework
kt-import java.util.ArrayList
nim-import times

ts-implement People

Student {
    id          int         id          -1
    name        str         name
    class       str         class
    isActive    bool        is_active   true
    year        date        year
    homeworks   []Homework  homeworks
}

tsFunc(
    public addHomework(hw: Homework): void {
        this.Homeworks.push(hw);
    }
)
```

The format of the fields goes from left to right in such order "field name", "field type", "field JSON name", and "initialize as" (optional, not used in Go and Nim).

_*Note: There is no gurranttee that "initialize as" field goes through a proper conversion or localization based on the targetted output languages so ideally you want to make sure it works with all versions of output that will be using it._

## Enum

example/emotion.enum

```text
go-filepath examples/go
kt-filepath examples/kt
ts-filepath examples/ts/person

Emotion {
    Accomplished
    Angry
    Annoyed
    Appalled
    Excited
    Exhausted
    FeelsGood
    Frustrated
    Happy
    Meh
    Sad
    Satisfied
}
```

## filepath

Basically the path location of where the generated file lives relative to where the build is ran (which if you use Please or Nimble as suggested, it will always be at the top level folder of this project - `wings/`).

If the namespace for a specific language is not defined, the file for that language will not be generated.

## import

Usually the `include` or `import` statement required for some part of the file to work properly. (In this case, its mostly external classes or enums for custom typing.)

## implement

In many occassion, your struct or object might be implementing a separate interface class. Use this to specify the class that it is implementing. (There is not support for this in `go` since it would already inherently associate your struct to the interface if you implemented all the functions and variables defined in the interface.)

## {lang}Func

Specific functions for specific programming languages. Ideally, you should have a separate utility classes that do all the other operations. This is mostly designed to be used for defining functions in an interface that the struct / class is implementing.
