// #BEGIN_IMPORT
// #IMPORT2 import {#IMPORT_1} from '{#IMPORT_2}';
// #END_IMPORT

// {#COMMENT}
export default class {#NAME_PASCAL} implements {#IMPLEMENT} {
    [key: string]: any;
// #BEGIN_VAR
    // #VAR public {#VARNAME_PASCAL}: {#TYPE} = {#TYPE_INIT};
// #END_VAR

    public init(data: any): boolean {
        try {
// #BEGIN_INIT
            // #INIT this.{#VARNAME_PASCAL} = data.{#VARNAME_JSON};
// #END_INIT
        } catch (e) {
            return false;
        }
        return true;
    }

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
