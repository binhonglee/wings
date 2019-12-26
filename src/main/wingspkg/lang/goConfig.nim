from strlib import Case
import tables
import ../lib/tconfig

const COMMENT: string = "//"
const FILENAME: Case = Case.Lower
const FILETYPE: string = "go"
const IMPORT_PATH_FORMAT: string = "{#1}:{#IMPORT}"
const IMPORT_PATH_TYPE: ImportPathType = ImportPathType.Absolute
const IMPORT_PATH_PREFIX: string = ""
const IMPORT_PATH_SEPARATOR: char = '/'
const IMPORT_PATH_LEVEL: int = 1
const TEMPLATE_STRUCT: string = """
package {#1}

// #BEGIN_IMPORT
import (
	// #IMPORT2 {#IMPORT_1} "{#IMPORT_2}"
	// #IMPORT1 "{#IMPORT_1}"
)
// #END_IMPORT

// #BEGIN_VAR
// {#NAME_PASCAL} - {#COMMENT}
type {#NAME_PASCAL} struct {
	// #VAR {#VARNAME_PASCAL} {#SPACED} {#TYPE} {#SPACED} `json:"{#VARNAME_JSON}"`
}
// #END_VAR
// #BEGIN_FUNCTIONS
// #FUNCTIONS {#FUNCTIONS}
// #END_FUNCTIONS

// {#NAME_PASCAL}s - An array of {#NAME_PASCAL}
type {#NAME_PASCAL}s []{#NAME_PASCAL}

"""

const TEMPLATE_ENUM: string = """
package {#1}

type {#NAME} int

// #BEGIN_VAR
const (
	// #VAR {#VARNAME_PASCAL} = iota
)
// #END_VAR

"""

const TYPES: Table[string, string] = {
    "int": "int",
    "flt": "float",
    "dbl": "double",
    "str": "string",
    "bool": "boolean",
    "date": "time.Time",
    "!imported": "PATH0.{#TYPE_PASCAL}",
    "!unimported": "{#TYPE_PASCAL}",
}.toTable()

const CUSTOM_TYPES: Table[string, TypeInterpreter] = {
    "[]": interpretType("[]{TYPE}", "[]{TYPE1}"),
    "Map<": interpretType("Map<{TYPE1},{TYPE2}>", "map[{TYPE1}]{TYPE2}"),
}.toTable()

let GO_CONFIG*: TConfig = initTConfig(
    COMMENT,
    CUSTOM_TYPES,
    initTable[string, TypeInterpreter](),
    FILENAME,
    FILETYPE,
    "",
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
)
