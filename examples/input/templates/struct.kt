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
