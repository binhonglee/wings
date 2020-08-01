# This is a generated file
#
# If you would like to make any changes, please edit the source file instead.
# run `plz genFile -- examples/input/homework.wings -c:wings.json` upon completion.

import json
import ./emotion

type
  Homework* = ref object
    ## Work to be done at home
    ID*: int
    name*: string
    dueDate*: DateTime
    givenDate*: DateTime
    feeling*: seq[Emotion]
  