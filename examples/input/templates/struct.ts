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
      // #CONSTRUCTOR this.{#VARNAME_CAMEL} = obj.{#VARNAME_JSON} !== undefined && obj.{#VARNAME_JSON} !== null ? {#TYPE_PARSE} : {#TYPE_INIT};
    }
  }
// #END_CONSTRUCTOR

  public toJsonKey(key: string): string {
    switch (key) {
// #BEGIN_JSON
      // #JSON case '{#VARNAME_CAMEL}': {
      // #JSON   return '{#VARNAME_JSON}';
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
