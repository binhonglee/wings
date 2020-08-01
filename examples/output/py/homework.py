# This is a generated file
#
# If you would like to make any changes, please edit the source file instead.
# run `plz genFile -- examples/input/homework.wings -c:wings.json` upon completion.

import json
import examples.output.py.emotion
from datetime import datetime

# Work to be done at home
class Homework():
  id: int = 0
  name: str = ""
  due_date: datetime = datetime.now()
  given_date: datetime = datetime.now()
  feeling: list = []

  def __init__(self, data):
    self = json.loads(data)
  