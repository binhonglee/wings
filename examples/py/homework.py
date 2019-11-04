# This is a generated file
# 
# If you would like to make any changes, please edit the source file instead.
# run `nimble genFile "{SOURCE_FILE}"` upon completion.
# Source: examples/homework.struct.wings

import json
from datetime import date

# Homework - Work to be done at homeclass Homework(object):
    id: int = -1
    name: str = ""
    due_date: date = date.today()
    given_date: date = date.today()
    
    def init(self, data):
        self = json.loads(data)