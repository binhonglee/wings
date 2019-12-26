from strlib import Case
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

const TYPES: Table[string, string] = {
    "int": "Int",
    "flt": "Float",
    "dbl": "Double",
    "str": "String",
    "bool": "Boolean",
    "date": "Date",
    "!imported": "{#TYPE_PASCAL}",
    "!unimported": "{#TYPE_PASCAL}"
}.toTable()

const TYPE_INITS: Table[string, string] = {
    "int": "0",
    "flt": "0",
    "dbl": "0",
    "str": "\"\"",
    "bool": "false",
    "!imported": " {#TYPE_PASCAL}()",
    "!unimported": " {#TYPE_PASCAL}()"
}.toTable

const CUSTOM_TYPES: Table[string, TypeInterpreter] = {
    "[]": interpretType("[]{TYPE}", "ArrayList<{TYPE1}>"),
    "Map<": interpretType("Map<{TYPE1},{TYPE2}>", "HashMap<{TYPE1}, {TYPE2}>"),
}.toTable()

let KT_CONFIG*: TConfig = initTConfig(
    COMMENT,
    CUSTOM_TYPES,
    initTable[string, TypeInterpreter](),
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