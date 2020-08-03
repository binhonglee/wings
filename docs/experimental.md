# Experimental

This page generally documents features that are experimental with no guarantee that its support will remain as the project goes on. As they get more stable, each sections will be moved to its own appropriate page.

## Remote Template

To use a remote language config file (template) instead of a local one, you can add something like the following to your `wings.json`. Hash field is optional. If a hash is not defined, it will not be checked. If a hash is defined and it does not match the hash of the downloaded file, it will not be parsed.

```json
"remoteLangConfigs": [{
  "url": "https://raw.githubusercontent.com/binhonglee/wings/devel/examples/input/templates/go.json",
  "hash": "F6F38AE46ACB6A79EB333D360EF3705CBF76CDC1"
}, {
  "url": "https://raw.githubusercontent.com/binhonglee/wings/devel/examples/input/templates/kt.json",
  "hash": "7885BBF682B5A931468A0A6BA51B47EA9CB31C79"
}, {
  "url": "https://raw.githubusercontent.com/binhonglee/wings/devel/examples/input/templates/nim.json",
  "hash": "BF55F9715D5997EE718DF811AB5F7194A76DF404"
}, {
  "url": "https://raw.githubusercontent.com/binhonglee/wings/devel/examples/input/templates/py.json",
  "hash": "CC07CDD6622A39E0E09A13E6107FC3BBBC8A428B"
}, {
  "url": "https://raw.githubusercontent.com/binhonglee/wings/devel/examples/input/templates/ts.json",
  "hash": "9E59AB2883F3C1DE2E6338622E067588420A069C"
}]
```

## Interface

Input file:

<div class="input_div">
<label class="input_label">sample_interface.wings</label>
<pre class="highlight" id="codeblock">
  <span class="kn">go-filepath</span> <span class="s">examples/go</span>
  <span class="kn">kt-filepath</span> <span class="s">examples/kt</span>
  <span class="kn">ts-filepath</span> <span class="s">examples/ts</span>

  <span class="kn">import</span> <span class="s">examples/input/emotion.wings</span>

  <span class="c1"># Just some interface</span>

  <span class="kn">interface</span> <span class="nx">Student</span> <span class="kn">{</span>
  <span class="kn">}</span>

  wings-func(
    public functionOne (firstParam: str, secondParam: str) void
    public functionTwo () str
  )

</pre>
</div>

Output files:

=== "examples/go/sampleinterface.go"
    ```go
    // This is a generated file
    //
    // If you would like to make any changes, please edit the source file instead.
    // run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
    // Source: examples/input/sample_interface.wings

    package go

    import (
      person "github.com/binhonglee/wings/examples/output/go/person"
    )

    // SampleInterface - Just some interface
    type SampleInterface interface {
      FunctionTwo() string
      FunctionOne(firstParam string, secondParam string) 
    }
    ```

=== "examples/kt/SampleInterface.kt"
    ```kotlin
    // This is a generated file
    //
    // If you would like to make any changes, please edit the source file instead.
    // run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
    // Source: examples/input/sample_interface.wings

    package kt

    // Just some interface
    interface SampleInterface {
      fun functionTwo(): String
      fun functionOne(firstParam: String, secondParam: String): Unit
    }
    ```

=== "examples/ts/SampleInterface.ts"
    ```ts
    // This is a generated file
    //
    // If you would like to make any changes, please edit the source file instead.
    // run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
    // Source: examples/input/sample_interface.wings

    import Emotion from './person/Emotion';

    // Just some interface
    export default interface SampleInterface {
      functionTwo(): string;
      functionOne(firstParam: string, secondParam: string): void;
    }
    ```
