
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
    
