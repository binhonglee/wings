import { Client } from 'pg';
// #BEGIN_IMPORT
// #IMPORT2 import {#IMPORT_1} from '{#IMPORT_2}';
// #END_IMPORT

export default class {#NAME_PASCAL} {
  public static async log(
// #BEGIN_VAR
    // #VAR {#VARNAME_CAMEL}: {#TYPE} = {#TYPE_INIT},
// #END_VAR
  ): Promise<boolean> {
    const client = new Client();
    client.connect();

    const sqlStatement = 'INSERT INTO {#NAME_PASCAL} ({#VARNAME_SNAKE_LIST}) VALUES({#VARNAME_COUNT_LIST})';
    const values = [{#VARNAME_CAMEL_LIST}];

    try {
      await client.query(sqlStatement, values);
      return true;
    } catch (err) {
      return false;
    }
  }
}
