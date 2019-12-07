# This is a generated file
# 
# If you would like to make any changes, please edit the source file instead.
# run `nimble genFile "{SOURCE_FILE}"` upon completion.
# Source: examples/input/homework.wings

import json
import times
import ./emotion


# Homework - Work to be done at home
type
    Homework* = object
        ID* : int
        name* : string
        dueDate* : DateTime
        givenDate* : DateTime
        feeling* : seq[Emotion]

proc parse*(homework: var Homework, data: string): void =
    let jsonOutput = parseJson(data)
    
    homework.ID = jsonOutput["id"].getInt()
    homework.name = jsonOutput["name"].getStr()
    homework.dueDate = now()
    homework.givenDate = now()
    homework.feeling = jsonOutput["feeling"].getElems()