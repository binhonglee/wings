# This is a generated file
#
# If you would like to make any changes, please edit the source file instead.
# run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
# Source: examples/input/homework.wings

import json
import examples.output.py.emotion

# Work to be done at home
class Homework():
  id: int = 0
  name: str = ""
  due_date: DateTime = date.today()
  given_date: DateTime = date.today()
  feeling: list = []

  def __init__(self, data):
    self = json.loads(data)
  