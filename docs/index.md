# wings

A simple cross language struct and enum file generator. (You might want to use a linter with this to clean up some trailing whitespaces and uneven tabbings.)

!!! info
    Unsupported types are initialized as custom struct / classes unless specified otherwise.

!!! warning "Nim `date`"
    It is currently unsupported since I haven't figure out how to parse ISOString time properly from `string` in Nim.

**Usage**

- Download the appropriate binary [here](https://github.com/binhonglee/wings/releases/tag/v0.0.2-alpha).
- Add binary to the included path (and rename it to `wings`).
- Run `wings -c:{config_file} {filepath}` to generate the files.

## Struct

Input file:

```text
go-filepath examples/go/classroom
kt-filepath examples/kt
nim-filepath examples/nim
py-filepath examples/py
ts-filepath examples/ts

ts-import People:./People
import examples/emotion.enum.wings
import examples/homework.struct.wings

py-implement People
ts-implement People

# Student - Any person who is studying in a class

struct Student {
    id          int         -1
    name        str
    cur_class   str
    feeling     Emotion     Emotion.Meh
    is_active   bool        true
    year        date
    graduation  date
    homeworks   []Homework
    something   Map<str,str>
}

tsFunc(
    public addHomework(hw: Homework): void {
        this.Homeworks.push(hw);
    }
)
```

Output files:

```go tab="examples/go/classroom/student.go"
/*
 * This is a generated file
 *
 * If you would like to make any changes, please edit the source file instead.
 * run `nimble genFile "{SOURCE_FILE}"` upon completion.
 * Source: examples/student.struct.wings
 */

package classroom

import (
    emotion "github.com/binhonglee/wings/examples/go"
    "time"
)

// Student - Any person who is studying in a class
type Student struct {
    ID            int                  `json:"id"`
    Name          string               `json:"name"`
    CurClass      string               `json:"cur_class"`
    Feeling       emotion.Emotion      `json:"feeling"`
    IsActive      bool                 `json:"is_active"`
    Year          time.Time            `json:"year"`
    Graduation    time.Time            `json:"graduation"`
    Homeworks     []Homework           `json:"homeworks"`
    Something     map[string]string    `json:"something"`
}

// Students - An array of Student
type Students []Student
```

```kotlin tab="examples/kt/Student.kt"
/*
 * This is a generated file
 *
 * If you would like to make any changes, please edit the source file instead.
 * run `nimble genFile "{SOURCE_FILE}"` upon completion.
 * Source: examples/student.struct.wings
 */

package kt

import java.util.ArrayList
import java.util.HashMap

// Student - Any person who is studying in a class
class Student {
    var ID: Int = -1
    var name: String = ""
    var curClass: String = ""
    var feeling: Emotion = Emotion.Meh
    var isActive: Boolean = true
    var year: Date = Date()
    var graduation: Date = Date()
    var homeworks: ArrayList<Homework> = ArrayList<Homework>()
    var something: HashMap<String, String> = HashMap<String, String>()

    fun toJsonKey(key: string): string {
        when (key) {
            "ID" -> return "id"
            "name" -> return "name"
            "curClass" -> return "cur_class"
            "feeling" -> return "feeling"
            "isActive" -> return "is_active"
            "year" -> return "year"
            "graduation" -> return "graduation"
            "homeworks" -> return "homeworks"
            "something" -> return "something"
            else -> return key
        }
    }
}
```

```nim tab="examples/nim/student.nim"
# This is a generated file
#
# If you would like to make any changes, please edit the source file instead.
# run `nimble genFile "{SOURCE_FILE}"` upon completion.
# Source: examples/student.struct.wings

import json
import ./homework
import times
import tables
import ./emotion


# Student - Any person who is studying in a class
type
    Student* = object
        ID* : int
        name* : string
        curClass* : string
        feeling* : Emotion
        isActive* : bool
        year* : DateTime
        graduation* : DateTime
        homeworks* : seq[Homework]
        something* : Table[string, string]

proc parse*(student: var Student, data: string): void =
    let jsonOutput = parseJson(data)

    student.ID = jsonOutput["id"].getInt()
    student.name = jsonOutput["name"].getStr()
    student.curClass = jsonOutput["cur_class"].getStr()
    student.feeling = newEmotion(jsonOutput["feeling"].getStr())
    student.isActive = jsonOutput["is_active"].getBool()
    student.year = now()
    student.graduation = now()
    student.homeworks = jsonOutput["homeworks"].getElems()
    student.something = jsonOutput["something"].getElems()
```

```py tab="examples/py/student.py"
# This is a generated file
#
# If you would like to make any changes, please edit the source file instead.
# run `nimble genFile "{SOURCE_FILE}"` upon completion.
# Source: examples/student.struct.wings

import json
from datetime import date
import examples.py.emotion
import examples.py.homework

# Student - Any person who is studying in a class
class Student(People):
    id: int = -1
    name: str = ""
    cur_class: str = ""
    feeling: Emotion = Emotion.Meh
    is_active: bool = True
    year: date = date.today()
    graduation: date = date.today()
    homeworks: list = list()
    something: dict = {}

    def init(self, data):
        self = json.loads(data)
```

```ts tab="examples/ts/Student.ts"
/*
 * This is a generated file
 *
 * If you would like to make any changes, please edit the source file instead.
 * run `nimble genFile "{SOURCE_FILE}"` upon completion.
 * Source: examples/student.struct.wings
 */

import Homework from './Homework';
import People from './People';
import Emotion from './person/Emotion';

// Student - Any person who is studying in a class
export default class Student implements People {
    [key: string]: any;
    public ID: number = -1;
    public name: string = '';
    public curClass: string = '';
    public feeling: Emotion = Emotion.Meh;
    public isActive: boolean = true;
    public year: Date = new Date();
    public graduation: Date = new Date();
    public homeworks: Homework[] = [];
    public something: Map<string, string> = new Map();

    public init(data: any): boolean {
        try {
            this.ID = data.id;
            this.name = data.name;
            this.curClass = data.cur_class;
            this.feeling = data.feeling;
            this.isActive = data.is_active;
            this.year = new Date(data.year);
            this.graduation = new Date(data.graduation);

            if (data.homeworks !== null) {
                this.homeworks = data.homeworks;
            }
            this.something = data.something;
        } catch (e) {
            return false;
        }
        return true;
    }

    public toJsonKey(key: string): string {
        switch (key) {
            case 'ID': {
                return 'id';
            }
            case 'name': {
                return 'name';
            }
            case 'curClass': {
                return 'cur_class';
            }
            case 'feeling': {
                return 'feeling';
            }
            case 'isActive': {
                return 'is_active';
            }
            case 'year': {
                return 'year';
            }
            case 'graduation': {
                return 'graduation';
            }
            case 'homeworks': {
                return 'homeworks';
            }
            case 'something': {
                return 'something';
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
go-filepath examples/go
kt-filepath examples/kt
nim-filepath examples/nim
py-filepath examples/py
ts-filepath examples/ts/person

enum Emotion {
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

```go tab="examples/go/emotion.go"
/*
 * This is a generated file
 *
 * If you would like to make any changes, please edit the source file instead.
 * run `nimble genFile "{SOURCE_FILE}"` upon completion.
 * Source: examples/emotion.enum.wings
 */

package go

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

```kotlin tab="examples/kt/Emotion.kt"
/*
 * This is a generated file
 *
 * If you would like to make any changes, please edit the source file instead.
 * run `nimble genFile "{SOURCE_FILE}"` upon completion.
 * Source: examples/emotion.enum.wings
 */

package kt

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

```nim tab="examples/nim/emotion.nim"
# This is a generated file
#
# If you would like to make any changes, please edit the source file instead.
# run `nimble genFile "{SOURCE_FILE}"` upon completion.
# Source: examples/emotion.enum.wings

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

```py tab="examples/py/emotion.py"
# This is a generated file
#
# If you would like to make any changes, please edit the source file instead.
# run `nimble genFile "{SOURCE_FILE}"` upon completion.
# Source: examples/emotion.enum.wings

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

```ts tab="examples/ts/person/Emotion.ts"
/*
 * This is a generated file
 *
 * If you would like to make any changes, please edit the source file instead.
 * run `nimble genFile "{SOURCE_FILE}"` upon completion.
 * Source: examples/emotion.enum.wings
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

## Wings Syntax Keyword

Simple explanation on how the syntax works with wings. Rows with unbounded and undefined keywords will lead to error being thrown.

### `{lang}-filepath`

Basically the path location of where the generated file lives relative to where the build is ran (which if you use Please or Nimble as suggested, it will always be at the top level folder of this project - `wings/`).

If the namespace for a specific language is not defined, the file for that language will not be generated.

### `{lang}-import`

Usually the `include` or `import` statement required for some part of the file to work properly. (In this case, its mostly external classes or enums for custom typing.)

### `import`

Similar to the above but this is specific to `include` or `import` another `wings` file.

### `{lang}-implement`

In many occassion, your struct or object might be implementing a separate interface class. Use this to specify the class that it is implementing. (There is not support for this in `go` since it would already inherently associate your struct to the interface if you implemented all the functions and variables defined in the interface.)

### `{lang}Func`

Specific functions for specific programming languages. Ideally, you should have a separate utility classes that do all the other operations. This is mostly designed to be used for defining functions in an interface that the struct / class is implementing.

### `#`

Comments for struct (usually description). This comment will be carried forward and included in the generated file.

### `//`

Comment in file. Unlike `#`, lines that begins with `//` will be ignored by the parser unless it is written inside the `{lang}Func()` where it would then be copied over to the generated file exactly the way it is. (Tabbing does not matter.)

## Config

### logging: `int`

The `int` value represents how verbose the logging do you expect. Logging levels are defined [here](main/wingspkg/util/log.md) as an Enum.

### header: `[]str`

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

### prefixes: `Map<str, str>`

This is mainly created for `go` since the import path isn't just relative from the file calling it nor the top level location of the project folder but rather, something that can be defined in the `go.mod` file. This allows `go` to have customized import path prefix.

```json
{
    "prefixes": {
        "go": "github.com/binhonglee/wings"
    }
}
```

### acronyms: `[]str`

You can specify specific cases where a word in a parameter name should be full caps instead of just camelCase or PascalCase. For eg, `ID` instead of `id` or `Id`.

### outputRootDirs: `[]str`

There are scenario where you want to write the generated files to a different root path or write them to multiple different filepaths. You can clarify here which folder should be considered the root folder when creating the generated files. Empty string would mean the caller folder. Error will be thrown if a folder defined here cannot be found.

_Note: The call should be made in the deeper of the different folder hierarchies._
