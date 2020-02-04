from stones/cases import Case
import tables
import ../lib/tconfig

const COMMENT: string = "#"
const FILENAME: Case = Case.Lower
const FILETYPE: string = "nim"
const IMPLEMENT_FORMAT: string = " of {#IMPLEMENT}"
const IMPORT_PATH_FORMAT: string = "{#IMPORT}"
const IMPORT_PATH_TYPE: ImportPathType = ImportPathType.Relative
const IMPORT_PATH_PREFIX: string = ""
const IMPORT_PATH_SEPARATOR: char = '/'
const IMPORT_PATH_LEVEL: int = 0
const TEMPLATE_STRUCT: string = """
// #BEGIN_IMPORT
import json
// #IMPORT1 import {#IMPORT_1}
// #IMPORT2 from {#IMPORT_1} import {#IMPORT_2}
// #END_IMPORT

// #BEGIN_VAR
type
  {#NAME}* = ref object{#IMPLEMENT}
    ## {#COMMENT}
    // #VAR {#VARNAME_CAMEL}*: {#TYPE}
// #END_VAR
// #BEGIN_FUNCTIONS
  // #FUNCTIONS {#FUNCTIONS}
// #END_FUNCTIONS

"""

const TEMPLATE_ENUM: string = """
// #BEGIN_VAR
type
  {#NAME}* = enum
    // #VAR {#VARNAME_PASCAL}
// #END_VAR

"""

let TYPES: Table[string, TypeInterpreter] = {
  "int": initTypeInterpreter("int", "int", "", ""),
  "flt": initTypeInterpreter("flt", "float", "", ""),
  "dbl": initTypeInterpreter("dbl", "float64", "", ""),
  "str": initTypeInterpreter("str", "string", "", ""),
  "bool": initTypeInterpreter("bool", "bool", "", ""),
  "date": initTypeInterpreter("date", "DateTime", "", ""),
  "!imported": initTypeInterpreter("!imported", "{#TYPE_PASCAL}", "", ""),
  "!unimported": initTypeInterpreter("!unimported", "{#TYPE_PASCAL}", "", ""),
}.toTable()

let CUSTOM_TYPES: Table[string, CustomTypeInterpreter] = {
  "[]": interpretType(
    initTypeInterpreter("[]{TYPE}", "seq[{TYPE1}]", "", "")
  ),
  "Map<": interpretType(
    initTypeInterpreter("Map<{TYPE1},{TYPE2}>", "Table[{TYPE1}, {TYPE2}]", "tables", "")
  ),
}.toTable()

let NIM_CONFIG*: TConfig = initTConfig(
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
