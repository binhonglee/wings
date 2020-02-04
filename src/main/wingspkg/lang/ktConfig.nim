from stones/cases import Case
import tables
import ../lib/tconfig

const COMMENT: string = "//"
const FILENAME: Case = Case.Pascal
const FILETYPE: string = "kt"
const IMPLEMENT_FORMAT: string = ": {#IMPLEMENT} "
const IMPORT_PATH_FORMAT: string = "{#IMPORT}"
const IMPORT_PATH_TYPE: ImportPathType = ImportPathType.Never
const IMPORT_PATH_PREFIX: string = ""
const IMPORT_PATH_SEPARATOR: char = '.'
const IMPORT_PATH_LEVEL: int = 0
const TEMPLATE_STRUCT: string = """
package {#1}
// #BEGIN_IMPORT

// #IMPORT1 import {#IMPORT_1}
// #END_IMPORT

// {#COMMENT}
class {#NAME} {#IMPLEMENT}{
// #BEGIN_VAR
  // #VAR var {#VARNAME_CAMEL}: {#TYPE} = {#TYPE_INIT}
// #END_VAR

// #BEGIN_JSON
  fun toJsonKey(key: string): string {
    when (key) {
      // #JSON "{#VARNAME_CAMEL}" -> return "{#VARNAME_JSON}"
      else -> return key
    }
  }
// #END_JSON
// #BEGIN_FUNCTIONS
// #FUNCTIONS {#FUNCTIONS}
// #END_FUNCTIONS
}

"""

const TEMPLATE_ENUM: string = """
package {#1}

// #BEGIN_VAR
enum class {#NAME} {
  // #VAR {#VARNAME_PASCAL}
}
// #END_VAR

"""

let TYPES: Table[string, TypeInterpreter] = {
  "int": initTypeInterpreter("int", "Int", "", "0"),
  "flt": initTypeInterpreter("flt", "Float", "", "0"),
  "dbl": initTypeInterpreter("dbl", "Double", "", "0"),
  "str": initTypeInterpreter("str", "String", "", "\"\""),
  "bool": initTypeInterpreter("bool", "Boolean", "", "false"),
  "date": initTypeInterpreter("date", "Date", "", "Date()"),
  "!imported": initTypeInterpreter("!imported", "{#TYPE_PASCAL}", "", "{#TYPE_PASCAL}()"),
  "!unimported": initTypeInterpreter("!unimported", "{#TYPE_PASCAL}", "", "{#TYPE_PASCAL}()"),
}.toTable()

let CUSTOM_TYPES: Table[string, CustomTypeInterpreter] = {
  "[]": interpretType(
    initTypeInterpreter(
      "[]{TYPE}",
      "ArrayList<{TYPE1}>",
      "",
      "arrayListOf<{TYPE1}>()"
    )
  ),
  "Map<": interpretType(
    initTypeInterpreter(
      "Map<{TYPE1},{TYPE2}>",
      "HashMap<{TYPE1}, {TYPE2}>",
      "",
      "hashMapOf<{TYPE1}, {TYPE2}>()"
    )
  ),
}.toTable()

let KT_CONFIG*: TConfig = initTConfig(
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
