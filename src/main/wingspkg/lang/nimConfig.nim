# DO NOT MANUALLY EDIT THIS FILE
#
# This file is automatically generated based on the config files located in `examples/input/template/`.

from stones/cases import Case
import tables
import ../lib/tconfig

const COMMENT: string = "#"
const FILENAME: Case = Case.Lower
const FILETYPE: string = "nim"
const IMPLEMENT_FORMAT: string = " of {#IMPLEMENT} "
const IMPORT_PATH_FORMAT: string = "{#IMPORT}"
const IMPORT_PATH_TYPE: ImportPathType = ImportPathType.Relative
const IMPORT_PATH_PREFIX: string = ""
const IMPORT_PATH_SEPARATOR: char = '/'
const IMPORT_PATH_LEVEL: int = 0
const PARSE_FORMAT: string = ""
const INTERFACE_SUPPORTED: bool = false
const PARAM_FORMAT: string = ""
const PARAM_JOINER: string = ""
const PRE_INDENT: bool = false
const INDENTATION_SPACING: string = "  "

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

const TEMPLATE_INTERFACE: string = """

"""

const TEMPLATE_LOGGER: string = """

"""

let TYPES: Table[string, TypeInterpreter] = {
  "dbl": initTypeInterpreter("dbl", "float64", "", "", ""),
  "bool": initTypeInterpreter("bool", "bool", "", "", ""),
  "flt": initTypeInterpreter("flt", "float", "", "", ""),
  "date": initTypeInterpreter("date", "DateTime", "", "", ""),
  "str": initTypeInterpreter("str", "string", "", "", ""),
  "!imported": initTypeInterpreter("!imported", "{#TYPE_PASCAL}", "", "", ""),
  "int": initTypeInterpreter("int", "int", "", "", ""),
  "!unimported": initTypeInterpreter("!unimported", "{#TYPE_PASCAL}", "", "", ""),
}.toTable()

let CUSTOM_TYPES: Table[string, CustomTypeInterpreter] = {
  "Map<": interpretType(
    initTypeInterpreter("Map<{TYPE1},{TYPE2}>", "Table[{TYPE1}, {TYPE2}]", "tables", "", "")
  ),
  "[]": interpretType(
    initTypeInterpreter("[]{TYPE}", "seq[{TYPE1}]", "", "", "")
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
  isp = INDENTATION_SPACING,
  pi = PRE_INDENT,
  isup = INTERFACE_SUPPORTED,
  prmFmt = PARAM_FORMAT,
  prmJnr = PARAM_JOINER,
  pfmt = PARSE_FORMAT,
  temp = {
    "struct": TEMPLATE_STRUCT,
    "enum": TEMPLATE_ENUM,
    "interface": TEMPLATE_INTERFACE,
    "logger": TEMPLATE_LOGGER,
  }.toTable(),
  ty = TYPES,
)
