# wings

A simple customizable cross language struct and enum file generator.

Click [here](./api) for code documentation index instead.

## Installation

### Script (easiest)

Just run the following in your terminal.

```sh
curl -s https://wings.sh/install.sh | sh
```

### Nimble (easy-ish)

If you have [`nimble`](https://github.com/nim-lang/nimble) installed, you can just do `nimble install wings`.

### GitHub Release (manual)

If you prefer to download them manually instead, you could do the following.

- Download the appropriate binary [here](https://github.com/binhonglee/wings/releases).
- Add binary to an included path and rename it to `wings`.
- Run `wings {filepath}` to generate the files. (eg. `wings /path/to/student.wings`)

*Note: While there are Windows binaries available for download from GitHub release page, they aren't thoroughly tested and some features (like self-updating) might not work as intended.*

### Compile from source (from scratch)

If you'd like to compile it from source, you can clone the repo and compile it with the release script.

```
git clone git@github.com:binhonglee/wings.git
cd wings/
./pleasew release
```

### VSCode (additional plugin)

If you are coding with VSCode, its recommended that you also install [this plugin](https://marketplace.visualstudio.com/items?itemName=binhonglee.vscode-wings) to get proper syntax highlighting on your wings files.

## Struct

Input file:

<div class="input_div">
<label class="input_label">student.wings</label>
<pre class="highlight" id="codeblock">
  <span class="kn">go-filepath</span> <span class="s">examples/go/classroom</span>
  <span class="kn">kt-filepath</span> <span class="s">examples/kt</span>
  <span class="kn">nim-filepath</span> <span class="s">examples/nim</span>
  <span class="kn">py-filepath</span> <span class="s">examples/py</span>
  <span class="kn">ts-filepath</span> <span class="s">examples/ts</span>

  <span class="kn">py-import</span> <span class="nx">examples.output.py.people</span>
  <span class="kn">ts-import</span> <span class="nx">{ IWingsStruct }</span><span class="kn">:</span><span class="kt">wings-ts-util</span>
  <span class="kn">import</span> <span class="s">examples/input/emotion.wings</span>
  <span class="kn">import</span> <span class="s">examples/input/homework.wings</span>

  <span class="kn">py-implement</span> <span class="nx">People</span>
  <span class="kn">ts-implement</span> <span class="nx">IWingsStruct</span>

  <span class="c1"># Any person who is studying in a class</span>

  <span class="kn">struct</span> <span class="nx">Student</span> <span class="kn">{</span>
    <span class="n">id</span>          <span class="kt">int</span>       <span class="mi">-1</span>
    <span class="n">name</span>        <span class="kt">str</span>
    <span class="n">cur_class</span>   <span class="kt">str</span>
    <span class="n">feeling</span>     <span class="nx">Emotion</span>   <span class="p">Emotion.Meh</span>
    <span class="n">is_active</span>   <span class="kt">bool</span>
    <span class="n">year</span>        <span class="kt">date</span>
    <span class="n">graduation</span>  <span class="kt">date</span>
    <span class="n">homeworks</span>   <span class="nx">[]Homework</span>
    <span class="n">something</span>   <span class="nx">Map<</span><span class="kt">str</span><span class="nx">,</span><span class="kt">str</span><span class="nx">></span>
  <span class="kn">}</span>

  <span class="nc">ts-func(</span>
    <span class="kt">public</span> <span class="nx">addHomework</span><span class="p">(</span><span class="nx">hw</span><span class="p">:</span> <span class="kt">Homework</span><span class="p">):</span> <span class="kn">void</span> <span class="p">{</span>
      <span class="kn">this</span><span class="kn">.</span><span class="nx">Homeworks</span><span class="kn">.</span><span class="nx">push</span><span class="p">(</span><span class="nx">hw</span><span class="p">)</span><span class="kn">;</span>
    <span class="p">}</span>
  <span class="nc">)</span>
</pre>
</div>

Output files:

=== "examples/go/classroom/student.go"
    ```go
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

=== "examples/kt/Student.kt"
    ```kotlin
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

=== "examples/nim/student.nim"
    ```nim
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

=== "examples/py/student.py"
    ```py
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

=== "examples/ts/Student.ts"
    ```ts
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

<div class="input_div">
<label class="input_label">emotion.wings</label>
<pre class="highlight" id="codeblock">
  <span class="kn">go-filepath</span> <span class="s">examples/go</span>
  <span class="kn">kt-filepath</span> <span class="s">examples/kt</span>
  <span class="kn">nim-filepath</span> <span class="s">examples/nim</span>
  <span class="kn">py-filepath</span> <span class="s">examples/py</span>
  <span class="kn">ts-filepath</span> <span class="s">examples/ts/person</span>

  <span class="c1">//Ignored comment</span>
  <span class="c1">// Another ignored comment</span>

  <span class="kn">enum</span> <span class="nx">Emotion</span> <span class="kn">{</span>
    <span class="n">Accomplished</span>
    <span class="n">Angry</span>
    <span class="n">Annoyed</span>
    <span class="n">Appalled</span>
    <span class="n">Excited</span>
    <span class="n">Exhausted</span>
    <span class="n">FeelsGood</span>
    <span class="n">Frustrated</span>
    <span class="n">Happy</span>
    <span class="n">Meh</span>
    <span class="n">Sad</span>
    <span class="n">Satisfied</span>
  <span class="kn">}</span>
</pre>
</div>

Output files:

=== "examples/go/emotion.go"
    ```go
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

=== "examples/kt/Emotion.kt"
    ```kotlin
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

=== "examples/nim/emotion.nim"
    ```nim
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

=== "examples/py/emotion.py"
    ```py
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

=== "examples/ts/person/Emotion.ts"
    ```ts
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

If you are interested in testing out an experimental feature, we also have some basic support for abstract functions on interface documented [here](./experimental/#interface).
