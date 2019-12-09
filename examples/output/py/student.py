# This is a generated file
# 
# If you would like to make any changes, please edit the source file instead.
# run `nimble genFile "{SOURCE_FILE}"` upon completion.
# Source: examples/input/student.wings

import json
from datetime import date
import examples.output.py.homework
import examples.output.py.emotion

#Any person who is studying in a class
class Student(People):
    id: int = -1
    name: str = ""
    cur_class: str = ""
    feeling: Emotion = Emotion.Meh
    is_active: bool = True
    year: date = date.today()
    graduation: date = date.today()
    homeworks: list = list()
    something: dict = {}
    
    def init(self, data):
        self = json.loads(data)