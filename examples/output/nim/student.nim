
import json
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
    
