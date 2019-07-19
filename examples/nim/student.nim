# This is a generated file
# 
# If you would like to make any changes, please edit the source file instead.
# run `nimble genFile "{SOURCE_FILE}"` upon completion.
# 
# Source: examples/student.struct

import json
import times

type
    Student* = object
        id* : int
        name* : string
        curClass* : string
        isActive* : bool
        year* : DateTime
        homeworks* : seq[Homework]

proc parse*(student: var Student, data: string): void =
    let jsonOutput = parseJson(data)
    
    student.id = jsonOutput["id"].getInt()
    student.name = jsonOutput["name"].getStr()
    student.curClass = jsonOutput["cur_class"].getStr()
    student.isActive = jsonOutput["is_active"].getBool()
    student.year = now()
    student.homeworks = jsonOutput["homeworks"].getElems()