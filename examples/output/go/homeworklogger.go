// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- examples/input/homework_logger.wings -c:wings.json` upon completion.

package go

import (
	person "github.com/binhonglee/wings/examples/output/go/person"
	"time"
)

func LogHomeworkLogger(
	id int,
	name string,
	emotion person.Emotion,
	duedate time.Time,
	givendate time.Time,
) bool {
  sqlStatement := `
    INSERT INTO HomeworkLogger (id, name, emotion, due_date, given_date)
    VALUES ($1, $2, $3, $4, $5)
  `
  err := db.QueryRow(sqlStatement, id, name, emotion, duedate, givendate)
  return err != nil
}