// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- examples/input/homework_logger.wings -c:wings.json` upon completion.

package go

import (
	"time"
)

func LogHomeworkLogger(
	id int,
	name string,
	duedate time.Time,
	givendate time.Time,
) bool {
  sqlStatement := `
    INSERT INTO HomeworkLogger (id, name, duedate, givendate)
    VALUES ($1, $2, $3, $4)
  `
  err := db.QueryRow(sqlStatement, id, name, duedate, givendate)
  return err != nil
}