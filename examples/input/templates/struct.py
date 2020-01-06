// #BEGIN_IMPORT
import json
// #IMPORT1 import {#IMPORT_1}
// #IMPORT2 from {#IMPORT_1} import {#IMPORT_2}
// #END_IMPORT

// #BEGIN_VAR
# {#COMMENT}
class {#NAME}({#IMPLEMENT}):
  // #VAR {#VARNAME_SNAKE}: {#TYPE} = {#TYPE_INIT}
// #END_VAR

  def __init__(self, data):
    self = json.loads(data)
// #BEGIN_FUNCTIONS
  // #FUNCTIONS {#FUNCTIONS}
// #END_FUNCTIONS
