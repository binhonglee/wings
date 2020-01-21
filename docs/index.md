# wings

A simple customizable cross language struct and enum file generator.

!!! info
    Unsupported types are initialized as custom struct / classes unless specified otherwise.

!!! warning "Nim `date`"
    It is currently unsupported since I haven't figure out how to parse ISOString time properly from `string` in Nim.

**Usage**

- Download the appropriate binary [here](https://github.com/binhonglee/wings/releases/tag/v0.0.2-alpha).
- Add binary to an included path and rename it to `wings`.
- Run `wings -c:{config_file} {filepath}` to generate the files.

or if you have [`nimble`](https://github.com/nim-lang/nimble) installed, you can just do `nimble install wings`.

## Struct

Input file:

```text
go-filepath examples/output/go/classroom
kt-filepath examples/output/kt
nim-filepath examples/output/nim
py-filepath examples/output/py
ts-filepath examples/output/ts

ts-import People:./People
import examples/input/emotion.wings
import examples/input/homework.wings

py-implement People
ts-implement People

# Any person who is studying in a class

struct Student {
  id          int       -1
  name        str
  cur_class   str
  feeling     Emotion   Emotion.Meh
  is_active   bool      true
  year        date
  graduation  date
  homeworks   []Homework
  something   Map<str,str>
}

ts-func(
  public addHomework(hw: Homework): void {
    this.Homeworks.push(hw);
  }
)
```

Output files:

```go tab="examples/go/classroom/student.go"
// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
// Source: examples/input/student.wings

package classroom

import (
	person "github.com/binhonglee/wings/examples/output/go/person"
)

// Student - Any person who is studying in a class
type Student struct {
	ID            int                  `json:"id"`
	Name          string               `json:"name"`
	CurClass      string               `json:"cur_class"`
	Feeling       person.Emotion       `json:"feeling"`
	IsActive      boolean              `json:"is_active"`
	Year          time.Time            `json:"year"`
	Graduation    time.Time            `json:"graduation"`
	Homeworks     []Homework           `json:"homeworks"`
	Something     map[string]string    `json:"something"`
}

// Students - An array of Student
type Students []Student
```

```kotlin tab="examples/kt/Student.kt"
// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
// Source: examples/input/student.wings

package kt

// Any person who is studying in a class
class Student {
  var ID: Int = -1
  var name: String = ""
  var curClass: String = ""
  var feeling: Emotion = Emotion.Meh
  var isActive: Boolean = true
  var year: Date =  Date()
  var graduation: Date =  Date()
  var homeworks: ArrayList<Homework> =  {#TYPE_PASCAL}()
  var something: HashMap<String, String> =  {#TYPE_PASCAL}()

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
