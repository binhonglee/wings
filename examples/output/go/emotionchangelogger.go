// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- examples/input/emotion_change_logger.wings -c:wings.json` upon completion.

package go

import (
	person "github.com/binhonglee/wings/examples/output/go/person"
	"time"
)

func LogEmotionChangeLogger(
	time time.Time,
	uid int,
	event person.Emotion,
) bool {
  sqlStatement := `
    INSERT INTO EmotionChangeLogger (time, uid, event)
    VALUES ($1, $2, $3)
  `
  err := db.QueryRow(sqlStatement, time, uid, event)
  return err != nil
}