# This is a generated file
#
# If you would like to make any changes, please edit the source file instead.
# run `plz genFile -- examples/input/student.wings -c:wings.json` upon completion.

import json
import tables
import ./homework
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
  