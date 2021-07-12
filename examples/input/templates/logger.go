package {#1}
// #BEGIN_IMPORT

import (
	// #IMPORT2 {#IMPORT_1} "{#IMPORT_2}"
	// #IMPORT1 "{#IMPORT_1}"
)
// #END_IMPORT
// #BEGIN_VAR

func Log{#NAME_PASCAL}(
	// #VAR {#VARNAME_LOWER} {#TYPE},
) bool {
  sqlStatement := `
    INSERT INTO {#NAME_PASCAL} ({#VARNAME_SNAKE_LIST})
    VALUES ({#VARNAME_COUNT_LIST})
  `
  err := db.QueryRow(sqlStatement, {#VARNAME_LOWER_LIST})
  return err != nil
}
// #END_VAR
// #BEGIN_FUNCTIONS

// #FUNCTIONS {#FUNCTIONS}
// #END_FUNCTIONS
