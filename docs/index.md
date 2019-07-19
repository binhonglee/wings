# wings

A simple cross language struct and enum file generator. (You might want to use a linter with this to clean up some trailing whitespaces and uneven tabbings.)

## Requirements

-   [Nim](https://nim-lang.org/)
    -   [Nimble](https://github.com/nim-lang/nimble) - Bundled with Nim
-   [Please](https://please.build) (alternative to nimble)

\*_Note: Replace `plz` with `./pleasew` if you do not have please installed._

## Supported languages

-   [go](http://golang.org/)
-   [Kotlin](https://kotlinlang.org) (WIP)
-   [Nim](https://nim-lang.org/) (WIP)
-   [Python](https://www.python.org/)
-   [TypeScript](https://www.typescriptlang.org)
    -   [Utility package](https://github.com/binhonglee/wings-ts-util)

## Supported types

| wings    | Go          | Kotlin            | Nim         | Python | TypeScript |
| :------- | :---------- | :---------------- | :---------- | :----- | :--------- |
| `int`    | `int`       | `Int`             | `int`       | `int`  | `number`   |
| `str`    | `string`    | `String`          | `string`    | `str`  | `string`   |
| `bool`   | `bool`      | `Boolean`         | `bool`      | `bool` | `boolean`  |
| `date`   | `time.Time` | `Date`            | -           | `date` | `Date`     |
| `[]type` | `[]type`    | `ArrayList<type>` | `seq[type]` | `list` | `[]`       |

!!! info
    Unsupported types are initialized as custom struct / classes unless specified otherwise.

!!! warning "Nim `date`"
    It is currently unsupported since I haven't figure out how to parse ISOString time properly from `string` in Nim.

Run `plz run //src:wings -- "{filepath}"` to generate the files.

!!! warning "Issue with `nimble`"
    I also have a task made for nimble (`nimble genFile "{filepath}"`) but its currently broken for the latest version (see official issue [here](https://github.com/nim-lang/nimble/issues/633)). If you have an older version of nimble, it should work as intended.

## Struct

Input file:

```text
go-filepath classroom
kt-filepath another
nim-filepath folder
py-filepath python
ts-filepath some/files

go-import time
go-import homework:path/to/homework
kt-import java.util.ArrayList
nim-import times
py-import datetime:date
ts-import { IWingsStruct }:wings-ts-util
ts-import Homework:path/to/Homework

py-implement People
ts-implement People

Student {
    id          int          -1
    name        str
    cur_class   str
    is_active   bool         true
    year        date
    homeworks   []Homework
}

tsFunc(
    public addHomework(hw: Homework): void {
        this.Homeworks.push(hw);
    }
)
```

Output files:

```go tab="classroom/student.go"
/*
 * This is a generated file
 * 
 * If you would like to make any changes, please edit the source file instead.
 * run `nimble genFile "{SOURCE_FILE}"` upon completion.
 * 
 * Source: student.struct
 */

package classroom

import (    
    "time"
    homework "path/to/homework"
)

type Student struct {
    Id int `json:"id"`
    Name string `json:"name"`
    CurClass string `json:"cur_class"`
    IsActive bool `json:"is_active"`
    Year time.Time `json:"year"`
    Homeworks []homework.Homework `json:"homeworks"`
}

type Students []Student
```

```kotlin tab="another/Student.kt"
/*
 * This is a generated file
 * 
 * If you would like to make any changes, please edit the source file instead.
 * run `nimble genFile "{SOURCE_FILE}"` upon completion.
 * 
 * Source: student.struct
 */

package another

import java.util.ArrayList

class Student {
    var id: Int = -1
    var name: String = ""
    var curClass: String = ""
    var isActive: Boolean = true
    var year: Date = Date()
    var homeworks: ArrayList<Homework> = ArrayList<Homework>()

    fun toJsonKey(key: string): string {
        when (key) {
            "id" -> return "id"
            "name" -> return "name"
            "curClass" -> return "cur_class"
            "isActive" -> return "is_active"
            "year" -> return "year"
            "homeworks" -> return "homeworks"
            else -> return key
        }
    }
}
```

```nim tab="folder/student.nim"
# This is a generated file
# 
# If you would like to make any changes, please edit the source file instead.
# run `nimble genFile "{SOURCE_FILE}"` upon completion.
# 
# Source: student.struct

import json
import times

type
    Student* = object
        id* : int
        name* : string
        curClass* : string
        isActive* : bool
        year* : DateTime
        homeworks* : seq[Homework]

proc parse*(student: var Student, data: string): void =
    let jsonOutput = parseJson(data)
    
    student.id = jsonOutput["id"].getInt()
    student.name = jsonOutput["name"].getStr()
    student.curClass = jsonOutput["cur_class"].getStr()
    student.isActive = jsonOutput["is_active"].getBool()
    student.year = now()  # as you can see, this isn't working
    student.homeworks = jsonOutput["homeworks"].getElems()
```

```py tab="python/student.py"
# This is a generated file
# 
# If you would like to make any changes, please edit the source file instead.
# run `nimble genFile "{SOURCE_FILE}"` upon completion.
# 
# Source: student.struct

import json
from datetime import date

class Student(People):
    id: int = -1
    name: str = ""
    cur_class: str = ""
    is_active: bool = True
    year: date = date.today()
    homeworks: list = list()
    
    def init(self, data):
        self = json.loads(data)
```

```ts tab="some/files/Student.ts"
/*
 * This is a generated file
 * 
 * If you would like to make any changes, please edit the source file instead.
 * run `nimble genFile "{SOURCE_FILE}"` upon completion.
 * 
 * Source: student.struct
 */

import { IWingsStruct } from 'wings-ts-util';
import Homework from 'path/to/Homework';

export default class Student implements People {
    [key: string]: any;
    public id: number = -1;
    public name: string = '';
    public curClass: string = '';
    public isActive: boolean = true;
    public year: Date = new Date();
    public homeworks: [] = [];
    
    public init(data: any): boolean {
        try {
            this.id = data.id;
            this.name = data.name;
            this.curClass = data.cur_class;
            this.isActive = data.is_active;
            this.year = new Date(data.year);
            
            if (data.homeworks !== "null") {
                this.homeworks = data.homeworks;
            }
        } catch (e) {
            return false;
        }
        return true;
    }
    
    public toJsonKey(key: string): string {
        switch (key) {
            case 'id': {
                return 'id';
            }
            case 'name': {
                return 'name';
            }
            case 'curClass': {
                return 'cur_class';
            }
            case 'isActive': {
                return 'is_active';
            }
            case 'year': {
                return 'year';
            }
            case 'homeworks': {
                return 'homeworks';
            }
            default: {
                return key;
            }
        }
    }

    public addHomework(hw: Homework): void {
        this.Homeworks.push(hw);
    }
}
```

The format of the fields goes from left to right in such order "field name", "field type", "field JSON name", and "initialize as" (optional, not used in Go and Nim).

_*Note: There is no gurranttee that "initialize as" field goes through a proper conversion or localization based on the targetted output languages so ideally you want to make sure it works with all versions of output that will be using it._

## Enum

Input file:

```text
go-filepath path
kt-filepath to
nim-filepath some
py-filepath python
ts-filepath file/person

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

```go tab="path/emotion.go"
/*
 * This is a generated file
 * 
 * If you would like to make any changes, please edit the source file instead.
 * run `nimble genFile "{SOURCE_FILE}"` upon completion.
 * 
 * Source: emotion.enum
 */

package path

type Emotion int

const (    
    Accomplished = iota
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
)
```

```kotlin tab="to/Emotion.kt"
/*
 * This is a generated file
 * 
 * If you would like to make any changes, please edit the source file instead.
 * run `nimble genFile "{SOURCE_FILE}"` upon completion.
 * 
 * Source: emotion.enum
 */

package to

enum class Emotion {    
    Accomplished,
    Angry,
    Annoyed,
    Appalled,
    Excited,
    Exhausted,
    FeelsGood,
    Frustrated,
    Happy,
    Meh,
    Sad,
    Satisfied,
}
```

```nim tab="some/emotion.nim"
# This is a generated file
# 
# If you would like to make any changes, please edit the source file instead.
# run `nimble genFile "{SOURCE_FILE}"` upon completion.
# 
# Source: emotion.enum

type
    Emotion* = enum
        Accomplished,
        Angry,
        Annoyed,
        Appalled,
        Excited,
        Exhausted,
        FeelsGood,
        Frustrated,
        Happy,
        Meh,
        Sad,
        Satisfied,
```

```py tab="python/emotion.py"
# This is a generated file
# 
# If you would like to make any changes, please edit the source file instead.
# run `nimble genFile "{SOURCE_FILE}"` upon completion.
# 
# Source: emotion.enum

from enum import Enum, auto

class Emotion(Enum):
    Accomplished = auto()
    Angry = auto()
    Annoyed = auto()
    Appalled = auto()
    Excited = auto()
    Exhausted = auto()
    FeelsGood = auto()
    Frustrated = auto()
    Happy = auto()
    Meh = auto()
    Sad = auto()
    Satisfied = auto()
```

```ts tab="file/person/Emotion.ts"
/*
 * This is a generated file
 * 
 * If you would like to make any changes, please edit the source file instead.
 * run `nimble genFile "{SOURCE_FILE}"` upon completion.
 * 
 * Source: emotion.enum
 */

enum Emotion{    
    Accomplished,
    Angry,
    Annoyed,
    Appalled,
    Excited,
    Exhausted,
    FeelsGood,
    Frustrated,
    Happy,
    Meh,
    Sad,
    Satisfied,
}

export default Emotion;
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
