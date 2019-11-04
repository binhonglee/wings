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
    student.isActive = jsonOutput["is_active"].getBool()
    student.year = now()
    student.graduation = now()
    student.homeworks = jsonOutput["homeworks"].getElems()
    student.something = jsonOutput["something"].getElems()