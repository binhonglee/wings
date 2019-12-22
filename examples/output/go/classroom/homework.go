
package classroom

import (
	emotion "examples/output/go"
)

// Homework - Work to be done at home
type Homework struct {
	ID           int          `json:"id"`
	Name         string       `json:"name"`
	DueDate      time.Time    `json:"due_date"`
	GivenDate    time.Time    `json:"given_date"`
	Feeling      []Emotion    `json:"feeling"`
}

    // Test - This comment should be included.
    func Test() int {
        return 0
    }

// Homeworks - An array of Homework
type Homeworks []Homework
