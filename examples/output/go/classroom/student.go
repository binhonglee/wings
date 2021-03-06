// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- examples/input/student.wings -c:wings.json` upon completion.

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
	Ids           []int                `json:"ids"`
	Something     map[string]string    `json:"something"`
}

// Students - An array of Student
type Students []Student