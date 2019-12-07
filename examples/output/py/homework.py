# This is a generated file
# 
# If you would like to make any changes, please edit the source file instead.
# run `nimble genFile "{SOURCE_FILE}"` upon completion.
# Source: examples/input/homework.wings

import json
from datetime import date
import examples.output.py.emotion

# Homework - Work to be done at home
class Homework(object):
    id: int = -1
    name: str = ""
    due_date: date = date.today()
    given_date: date = date.today()
    feeling: list = list()
    
    def init(self, data):
        self = json.loads(data)