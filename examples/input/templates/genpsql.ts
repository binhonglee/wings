import { Client } from 'pg';
// #BEGIN_IMPORT
// #IMPORT2 import {#IMPORT_1} from '{#IMPORT_2}';
// #END_IMPORT

export default class Gen{#NAME_PASCAL} {
  public static async create(): Promise<void> {
    const client = new Client();
    client.connect();

    const ifExists = `
      SELECT EXISTS(
        SELECT 1
        FROM {#NAME_PASCAL}
      );`;

    try {
      await client.query(ifExists);
// #BEGIN_VAR
      // #VAR await client.query("ALTER TABLE {#NAME_PASCAL} ADD COLUMN IF NOT EXISTS {#VARNAME_SNAKE} {#TYPE} {#DB_KEYWORDS};")
// #END_VAR
    } catch(err) {
      const createTable = `
        CREATE TABLE {#NAME_PASCAL} (
// #BEGIN_VAR
          // #VAR {#VARNAME_SNAKE} {#TYPE} {#DB_KEYWORDS},
// #END_VAR_1_TRIM
        );`
      await client.query(createTable);
    }
  }
}
// #BEGIN_FUNCTIONS

// #FUNCTIONS {#FUNCTIONS}
// #END_FUNCTIONS
