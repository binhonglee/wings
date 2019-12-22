from strlib import Case
import tables
import ../lib/tconfig

const FILENAME: Case = Case.Pascal
const FILETYPE: string = "ts"
const IMPLEMENT_FORMAT: string = "implements {#IMPLEMENT} "
const IMPORT_PATH_FORMAT: string = "{#0}:{#IMPORT}"
const IMPORT_PATH_TYPE: ImportPathType = ImportPathType.Relative
const IMPORT_PATH_PREFIX: string = ""
const IMPORT_PATH_SEPARATOR: char = '/'
const IMPORT_PATH_LEVEL: int = 0
const TEMPLATE_STRUCT: string = """
// #BEGIN_IMPORT
// #IMPORT2 import {#IMPORT_1} from '{#IMPORT_2}';
// #END_IMPORT

// {#COMMENT}
// #BEGIN_VAR
export default class {#NAME_PASCAL} {#IMPLEMENT}{
    [key: string]: any;
    // #VAR public {#VARNAME_CAMEL}: {#TYPE} = {#TYPE_INIT};
// #END_VAR

// #BEGIN_INIT
    public init(data: any): boolean {
        try {
            // #INIT this.{#VARNAME_CAMEL} = data.{#VARNAME_JSON};
        } catch (e) {
            return false;
        }
        return true;
    }
// #END_INIT

// #BEGIN_JSON
    public toJsonKey(key: string): string {
        switch (key) {
            // #JSON case '{#VARNAME_CAMEL}': {
            // #JSON     return '{#VARNAME_JSON}';
            // #JSON }
            default: {
                return key;
            }
        }
    }
// #END_JSON
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
