# This is a generated file
#
# If you would like to make any changes, please edit the source file instead.
# run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
# Source: examples/input/student.wings

import json
import examples.output.py.homework
import examples.output.py.emotion
from datetime import datetime

# Any person who is studying in a class
class Student(People):
  id: int = -1
  name: str = ""
  cur_class: str = ""
  feeling: Emotion = Emotion.Meh
  is_active: bool = False
  year: datetime = datetime.now()
  graduation: datetime = datetime.now()
  homeworks: list = []
  something: dict = {}

  def __init__(self, data):
    self = json.loads(data)
  