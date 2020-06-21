# wings

A simple customizable cross language struct and enum file generator.

!!! info
    Unsupported types are initialized as custom struct / classes unless specified otherwise.

!!! warning "Nim `date`"
    It is currently unsupported since I haven't figure out how to parse ISOString time properly from `string` in Nim.

**Usage**

- Download the appropriate binary [here](https://github.com/binhonglee/wings/releases/tag/v0.0.3-alpha).
- Add binary to an included path and rename it to `wings`.
- Run `wings -c:{config_file} {filepath}` to generate the files.

or if you have [`nimble`](https://github.com/nim-lang/nimble) installed, you can just do `nimble install wings`.

[Here](https://marketplace.visualstudio.com/items?itemName=binhonglee.vscode-wings)'s a simple vscode plugin that provides syntax highlighting for wings.

## Struct

Input file:

```text
go-filepath examples/go/classroom
kt-filepath examples/kt
nim-filepath examples/nim
py-filepath examples/py
ts-filepath examples/ts

py-import examples.output.py.people
ts-import { IWingsStruct }:wings-ts-util
import examples/input/emotion.wings
import examples/input/homework.wings

py-implement People
ts-implement IWingsStruct

# Any person who is studying in a class

struct Student {
  id          int       -1
  name        str
  cur_class   str
  feeling     Emotion   Emotion.Meh
  is_active   bool
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
	"time"
)

// Student - Any person who is studying in a class
type Student struct {
	ID            int                  `json:"id"`
	Name          string               `json:"name"`
	CurClass      string               `json:"cur_class"`
	Feeling       person.Emotion       `json:"feeling"`
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
  var isActive: Boolean = false
  var year: Date = Date()
  var graduation: Date = Date()
  var homeworks: ArrayList<Homework> = arrayListOf<Homework>()
  var something: HashMap<String, String> = hashMapOf<String, String>()

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
# run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
# Source: examples/input/student.wings

import json
import ./homework
import tables
import ./emotion

type
  Student* = ref object
    ## Any person who is studying in a class
    ID*: int
    name*: string
    curClass*: string
    feeling*: Emotion
    isActive*: bool
    year*: DateTime
    graduation*: DateTime
    homeworks*: seq[Homework]
    something*: Table[string, string]
```

```py tab="examples/py/student.py"
# This is a generated file
#
# If you would like to make any changes, please edit the source file instead.
# run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
# Source: examples/input/student.wings

import json
import examples.output.py.homework
import examples.output.py.people
import examples.output.py.emotion
from datetime import datetime

# Any person who is studying in a class
class Student(People):
  id: int = -1
  name: str = ""
  cur_class: str = ""
  feeling: Emotion = Emotion.Meh
  is_active: bool = False
  year: datetime = datetime.now()
  graduation: datetime = datetime.now()
  homeworks: list = []
  something: dict = {}

  def __init__(self, data):
    self = json.loads(data)
```

```ts tab="examples/ts/Student.ts"
// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
// Source: examples/input/student.wings

import { parseMap } from 'wings-ts-util';
import Homework from './Homework';
import { IWingsStruct } from 'wings-ts-util';
import Emotion from './person/Emotion';

// Any person who is studying in a class
export default class Student implements IWingsStruct {
  [key: string]: any;
  public ID: number = -1;
  public name: string = '';
  public curClass: string = '';
  public feeling: Emotion = Emotion.Meh;
  public isActive: boolean = false;
  public year: Date = new Date();
  public graduation: Date = new Date();
  public homeworks: Homework[] = [];
  public something: Map<string, string> = new Map<string, string>();

  public constructor(obj?: any) {
    if (obj) {
      this.ID = obj.id !== undefined && obj.id !== null ? obj.id : -1;
      this.name = obj.name !== undefined && obj.name !== null ? obj.name : '';
      this.curClass = obj.cur_class !== undefined && obj.cur_class !== null ? obj.cur_class : '';
      this.feeling = obj.feeling !== undefined && obj.feeling !== null ? obj.feeling : Emotion.Meh;
      this.isActive = obj.is_active !== undefined && obj.is_active !== null ? obj.is_active : false;
      this.year = obj.year !== undefined && obj.year !== null ? new Date(obj.year) : new Date();
      this.graduation = obj.graduation !== undefined && obj.graduation !== null ? new Date(obj.graduation) : new Date();
      this.homeworks = obj.homeworks !== undefined && obj.homeworks !== null ? obj.homeworks : [];
      this.something = obj.something !== undefined && obj.something !== null ? parseMap<string>(obj.something) : new Map<string, string>();
    }
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

//Ignored comment
// Another ignored comment

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
// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
// Source: examples/input/emotion.wings

package person

type Emotion int

const (
	Accomplished = iota
	Angry = iota
	Annoyed = iota
	Appalled = iota
	Excited = iota
	Exhausted = iota
	FeelsGood = iota
	Frustrated = iota
	Happy = iota
	Meh = iota
	Sad = iota
	Satisfied = iota
)
```

```kotlin tab="examples/kt/Emotion.kt"
// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
// Source: examples/input/emotion.wings

package kt

enum class Emotion {
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

```nim tab="examples/nim/emotion.nim"
# This is a generated file
#
# If you would like to make any changes, please edit the source file instead.
# run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
# Source: examples/input/emotion.wings

type
  Emotion* = enum
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
```

```py tab="examples/py/emotion.py"
# This is a generated file
#
# If you would like to make any changes, please edit the source file instead.
# run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
# Source: examples/input/emotion.wings

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
// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
// Source: examples/input/emotion.wings

enum Emotion {
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
