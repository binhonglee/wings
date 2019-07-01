# wings

A simple cross language struct and enum file generator. (You might want to use a linter with this to clean up some trailing whitespaces and uneven tabbings.)

Requirements:

- [Nim](https://nim-lang.org/)
  - [Nimble](https://github.com/nim-lang/nimble) - Bundled with Nim. (optional)
- [Please](https://please.build) (optional)

\*_Note: Replace `plz` with `./pleasew` if you do not have please installed._

Supported languages:

- [go](http://golang.org/)
- [TypeScript](https://www.typescriptlang.org)

\*_Note: Ironically has yet to support `Nim` itself._

Supported types:

| wings | go | Kotlin | TypeScript |
|:--|:--|:--|:--|
| int | int | Int | number |
| str | string | String | string |
| bool | bool | Boolean | boolean |
| date | time.Time | Date | Date |
| []type | []type | ArrayList\<type\> | [] |

Run `nimble genFile "{filepath}"` or `plz run //src:wings -- "{filepath}"` to generate the files.

## Struct

example/student.struct

```txt
go-filepath examples/go/classroom
kt-filepath examples/kt
ts-filepath examples/ts

go-import time
go-import homework:path/to/homework
ts-import People:./People
ts-import Homework:path/to/Homework
kt-import java.util.ArrayList

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

## Enum

example/emotion.enum

```txt
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

Basically the path location of where the generated file lives relative to where the build is ran (which if you use Please or Nimble as suggested, it will always be at the top level folder of this project - 'Wings/').

If the namespace for a specific language is not defined, the file for that language will not be generated.

## import

Usually the `include` or `import` statement required for some part of the file to work properly. (In this case, its mostly external classes or enums for custom typing.)

## implement

In many occassion, your struct or object might be implementing a separate interface class. Use this to specify the class that it is implementing. (There is not support for this in `go` since it would already inherently associate your struct to the interface if you implemented all the functions and variables defined in the interface.)

## {lang}Func

Specific functions for specific programming languages. Ideally, you should have a separate utility class that do all the other operations. This is mostly designed to be used for implementing functions in an interface that the struct / class is implementing.
