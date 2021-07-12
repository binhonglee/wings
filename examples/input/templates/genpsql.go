package {#1}
// #BEGIN_IMPORT

import (
	// #IMPORT2 {#IMPORT_1} "{#IMPORT_2}"
	// #IMPORT1 "{#IMPORT_1}"
)
// #END_IMPORT

func init{#NAME_CAMEL}() {
	ifTableExists := `
		SELECT EXISTS(
			SELECT 1
			FROM {#NAME_PASCAL}
		);`

	_, err := db.Exec(ifTableExists)

	if err != nil {
		createTable := `
			CREATE TABLE {#NAME_PASCAL} (
// #BEGIN_VAR
				// #VAR {#VARNAME_SNAKE} {#TYPE} {#DB_KEYWORDS},
// #END_VAR_1_TRIM
			);`
		_, err = db.Exec(createTable)

		if err != nil {
			panic("Failed to create `{#NAME_CAMEL}` table. ")
		}
	} else {
// #BEGIN_VAR
		// #VAR db.Exec("ALTER TABLE {#NAME_PASCAL} ADD COLUMN IF NOT EXISTS {#VARNAME_SNAKE} {#TYPE} {#DB_KEYWORDS};")
// #END_VAR
	}
}
// #BEGIN_FUNCTIONS

// #FUNCTIONS {#FUNCTIONS}
// #END_FUNCTIONS
