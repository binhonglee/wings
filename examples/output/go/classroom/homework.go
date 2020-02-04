// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
// Source: examples/input/homework.wings

package classroom

import (
	person "github.com/binhonglee/wings/examples/output/go/person"
	"time"
)

// Homework - Work to be done at home
type Homework struct {
	ID           int                 `json:"id"`
	Name         string              `json:"name"`
	DueDate      time.Time           `json:"due_date"`
	GivenDate    time.Time           `json:"given_date"`
	Feeling      []person.Emotion    `json:"feeling"`
}

// Test - This comment should be included.
func Test() int {
	return 0
}

// Homeworks - An array of Homework
type Homeworks []Homework