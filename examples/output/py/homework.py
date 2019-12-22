
import json
import examples.output.py.emotion

# Work to be done at home
class Homework():
    id: int = 0
    name: str = ""
    due_date: DateTime = new Date()
    given_date: DateTime = new Date()
    feeling: list = []

    def init(self, data):
        self = json.loads(data)
    
