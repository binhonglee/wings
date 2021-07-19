// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- examples/input/homework_logger.wings -c:wings.json` upon completion.

package go

import (
	person "github.com/binhonglee/wings/examples/output/go/person"
	"time"
)

func initHomeworkLogger() {
	ifTableExists := `
		SELECT EXISTS(
			SELECT 1
			FROM HomeworkLogger
		);`

	_, err := db.Exec(ifTableExists)

	if err != nil {
		createTable := `
			CREATE TABLE HomeworkLogger (
				id INT UNIQUE SERIAL PRIMARY,
				name TEXT NOT NULL,
				emotion INT NOT NULL,
				due_date TIMESTAMPZ NOT NULL,
				given_date TIMESTAMPZ NOT NULL
			);`
		_, err = db.Exec(createTable)

		if err != nil {
			panic("Failed to create `HomeworkLogger` table. ")
		}
	} else {
		db.Exec("ALTER TABLE HomeworkLogger ADD COLUMN IF NOT EXISTS id INT UNIQUE SERIAL PRIMARY;")
		db.Exec("ALTER TABLE HomeworkLogger ADD COLUMN IF NOT EXISTS name TEXT NOT NULL;")
		db.Exec("ALTER TABLE HomeworkLogger ADD COLUMN IF NOT EXISTS emotion INT NOT NULL;")
		db.Exec("ALTER TABLE HomeworkLogger ADD COLUMN IF NOT EXISTS due_date TIMESTAMPZ NOT NULL;")
		db.Exec("ALTER TABLE HomeworkLogger ADD COLUMN IF NOT EXISTS given_date TIMESTAMPZ NOT NULL;")
	}
}