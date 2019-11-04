# This is a generated file
# 
# If you would like to make any changes, please edit the source file instead.
# run `nimble genFile "{SOURCE_FILE}"` upon completion.
# Source: examples/student.struct.wings

import json
from datetime import date
import examples.py.emotion
import examples.py.homework

# Student - Any person who is studying in a class
class Student(People):
    id: int = -1
    name: str = ""
    cur_class: str = ""
    is_active: bool = True
    year: date = date.today()
    graduation: date = date.today()
    homeworks: list = []Homework()
    something: dict = Map<str,str>()
    
    def init(self, data):
        self = json.loads(data)