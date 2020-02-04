from stones/cases import Case
import tables
import ../lib/tconfig

const COMMENT: string = "#"
const FILENAME: Case = Case.Lower
const FILETYPE: string = "py"
const IMPLEMENT_FORMAT: string = "{#IMPLEMENT}"
const IMPORT_PATH_FORMAT: string = "{#IMPORT}"
const IMPORT_PATH_TYPE: ImportPathType = ImportPathType.Absolute
const IMPORT_PATH_PREFIX: string = ""
const IMPORT_PATH_SEPARATOR: char = '.'
const IMPORT_PATH_LEVEL: int = 0
const TEMPLATE_STRUCT: string = """
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

"""

const TEMPLATE_ENUM: string = """
from enum import Enum, auto

// #BEGIN_VAR
class {#NAME}(Enum):
  // #VAR {#VARNAME_PASCAL} = auto()
// #END_VAR

"""

let TYPES: Table[string, TypeInterpreter] = {
  "int": initTypeInterpreter("int", "int", "", "0"),
  "flt": initTypeInterpreter("flt", "float", "", "0"),
  "dbl": initTypeInterpreter("dbl", "double", "", "0"),
  "str": initTypeInterpreter("str", "str", "", "\"\""),
  "bool": initTypeInterpreter("bool", "bool", "", "False"),
  "date": initTypeInterpreter("date", "datetime", "datetime:datetime", "datetime.now()"),
  "!imported": initTypeInterpreter("!imported", "{#TYPE_PASCAL}", "", "new {#TYPE_PASCAL}()"),
  "!unimported": initTypeInterpreter("!unimported", "{#TYPE_PASCAL}", "", "new {#TYPE_PASCAL}()"),
}.toTable()

let CUSTOM_TYPES: Table[string, CustomTypeInterpreter] = {
  "[]": interpretType(
    initTypeInterpreter("[]{TYPE}", "list", "", "[]")
  ),
  "Map<": interpretType(
    initTypeInterpreter("Map<{TYPE1},{TYPE2}>", "dict", "", "{}")
  ),
}.toTable()

let PY_CONFIG*: TConfig = initTConfig(
  cmt = COMMENT,
  ct = CUSTOM_TYPES,
  c = FILENAME,
  ft = FILETYPE,
  ifmt = IMPLEMENT_FORMAT,
  ipfmt = IMPORT_PATH_FORMAT,
  ipt = IMPORT_PATH_TYPE,
  pfx = IMPORT_PATH_PREFIX,
  sep = IMPORT_PATH_SEPARATOR,
  level = IMPORT_PATH_LEVEL,
  temp = {
    "struct": TEMPLATE_STRUCT,
    "enum": TEMPLATE_ENUM,
  }.toTable(),
  ty = TYPES,
)
