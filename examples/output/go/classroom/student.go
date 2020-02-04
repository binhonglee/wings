// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
// Source: examples/input/student.wings

package classroom

import (
	person "github.com/binhonglee/wings/examples/output/go/person"
	"time"
)

// Student - Any person who is studying in a class
type Student struct {
	ID            int                  `json:"id"`
	Name          string               `json:"name"`
	CurClass      string               `json:"cur_class"`
	Feeling       person.Emotion       `json:"feeling"`
	IsActive      bool                 `json:"is_active"`
	Year          time.Time            `json:"year"`
	Graduation    time.Time            `json:"graduation"`
	Homeworks     []Homework           `json:"homeworks"`
	Something     map[string]string    `json:"something"`
}

// Students - An array of Student
type Students []Student