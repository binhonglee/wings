from strlib import Case
import tables
import ../lib/tconfig

const COMMENT: string = "//"
const FILENAME: Case = Case.Pascal
const FILETYPE: string = "ts"
const IMPLEMENT_FORMAT: string = "implements {#IMPLEMENT} "
const IMPORT_PATH_FORMAT: string = "{#0}:{#IMPORT}"
const IMPORT_PATH_TYPE: ImportPathType = ImportPathType.Relative
const IMPORT_PATH_PREFIX: string = ""
const IMPORT_PATH_SEPARATOR: char = '/'
const IMPORT_PATH_LEVEL: int = 0
const PARSE_FORMAT: string = "obj.{#VARNAME_JSON}"

const TEMPLATE_STRUCT: string = """
// #BEGIN_IMPORT
// #IMPORT2 import {#IMPORT_1} from '{#IMPORT_2}';
// #END_IMPORT

// {#COMMENT}
export default class {#NAME_PASCAL} {#IMPLEMENT}{
    [key: string]: any;
// #BEGIN_VAR
    // #VAR public {#VARNAME_CAMEL}: {#TYPE} = {#TYPE_INIT};
// #END_VAR

// #BEGIN_CONSTRUCTOR
    public constructor(obj?: any) {
        if (obj) {
            // #CONSTRUCTOR this.{#VARNAME_CAMEL} = obj.{#VARNAME_JSON} || {#TYPE_INIT}
        }
    }
// #END_CONSTRUCTOR

    public toJsonKey(key: string): string {
        switch (key) {
// #BEGIN_JSON
            // #JSON case '{#VARNAME_CAMEL}': {
            // #JSON     return '{#VARNAME_JSON}';
            // #JSON }
// #END_JSON
            default: {
                return key;
            }
        }
    }
// #BEGIN_FUNCTIONS

// #FUNCTIONS {#FUNCTIONS}
// #END_FUNCTIONS
}

"""

const TEMPLATE_ENUM: string = """
// #BEGIN_VAR
enum {#NAME_PASCAL} {
    // #VAR {#VARNAME_PASCAL},
}
// #END_VAR

export default {#NAME_PASCAL};

"""

const TYPES: Table[string, string] = {
    "int": "number",
    "flt": "number",
    "dbl": "number",
    "str": "string",
    "bool": "boolean",
    "date": "Date",
    "!imported": "{#TYPE_PASCAL}",
    "!unimported": "{#TYPE_PASCAL}"
}.toTable()

const TYPE_INITS: Table[string, string] = {
    "int": "0",
    "flt": "0",
    "dbl": "0",
    "str": "''",
    "bool": "false",
    "!imported": "new {#TYPE_PASCAL}()",
    "!unimported": "new {#TYPE_PASCAL}()"
}.toTable

const CUSTOM_TYPES: Table[string, TypeInterpreter] = {
    "[]": interpretType("[]{TYPE}", "{TYPE1}[]"),
    "Map<": interpretType("Map<{TYPE1},{TYPE2}>", "Map<{TYPE1}, {TYPE2}>"),
}.toTable()

const CUSTOM_TYPE_INITS: Table[string, TypeInterpreter] = {
    "[]": interpretType("[]{TYPE}", "[]"),
}.toTable()

let TS_CONFIG*: TConfig = initTConfig(
    cmt = COMMENT,
    ct = CUSTOM_TYPES,
    cti = CUSTOM_TYPE_INITS,
    c = FILENAME,
    ft = FILETYPE,
    ifmt = IMPLEMENT_FORMAT,
    ipfmt = IMPORT_PATH_FORMAT,
    ipt = IMPORT_PATH_TYPE,
    pfx = IMPORT_PATH_PREFIX,
    sep = IMPORT_PATH_SEPARATOR,
    level = IMPORT_PATH_LEVEL,
    pfmt = PARSE_FORMAT,
    temp = {
        "struct": TEMPLATE_STRUCT,
        "enum": TEMPLATE_ENUM,
    }.toTable(),
    ty = TYPES,
    ti = TYPE_INITS,
)
