# This is a generated file
# 
# If you would like to make any changes, please edit the source file instead.
# run `nimble genFile "{SOURCE_FILE}"` upon completion.
# 
# Source: examples/student.struct

import times

type
    Student* = object
        id* : int
        name* : string
        class* : string
        is_active* : bool
        year* : DateTime
        homeworks* : seq[Homework]
