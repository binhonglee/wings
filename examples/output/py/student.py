
import json
import examples.output.py.homework
import examples.output.py.emotion

# Any person who is studying in a class
class Student(People):
    id: int = 0
    name: str = ""
    cur_class: str = ""
    feeling: Emotion = new Emotion()
    is_active: bool = false
    year: DateTime = new Date()
    graduation: DateTime = new Date()
    homeworks: list = []
    something: dict = {}

    def init(self, data):
        self = json.loads(data)
    
