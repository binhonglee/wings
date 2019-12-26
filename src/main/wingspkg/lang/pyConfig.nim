from strlib import Case
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

    def init(self, data):
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

const TYPES: Table[string, string] = {
    "int": "int",
    "flt": "float",
    "dbl": "double",
    "str": "str",
    "bool": "bool",
    "date": "DateTime",
    "!imported": "{#TYPE_PASCAL}",
    "!unimported": "{#TYPE_PASCAL}"
}.toTable()

const TYPE_INITS: Table[string, string] = {
    "int": "0",
    "flt": "0",
    "dbl": "0",
    "str": "\"\"",
    "bool": "false",
    "date": "date.today()",
    "!imported": "new {#TYPE_PASCAL}()",
    "!unimported": "new {#TYPE_PASCAL}()"
}.toTable

const CUSTOM_TYPES: Table[string, TypeInterpreter] = {
    "[]": interpretType("[]{TYPE}", "list"),
    "Map<": interpretType("Map<{TYPE1},{TYPE2}>", "dict"),
}.toTable()

const CUSTOM_TYPE_INITS: Table[string, TypeInterpreter] = {
    "[]": interpretType("[]{TYPE}", "[]"),
    "Map<": interpretType("Map<{TYPE1},{TYPE2}>", "{}"),
}.toTable()

let PY_CONFIG*: TConfig = initTConfig(
    COMMENT,
    CUSTOM_TYPES,
    CUSTOM_TYPE_INITS,
    FILENAME,
    FILETYPE,
    IMPLEMENT_FORMAT,
    IMPORT_PATH_FORMAT,
    IMPORT_PATH_TYPE,
    IMPORT_PATH_PREFIX,
    IMPORT_PATH_SEPARATOR,
    IMPORT_PATH_LEVEL,
    {
        "struct": TEMPLATE_STRUCT,
        "enum": TEMPLATE_ENUM,
    }.toTable(),
    TYPES,
    TYPE_INITS,
)