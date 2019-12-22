
package classroom

import (
	emotion "examples/output/go"
)

// Student - Any person who is studying in a class
type Student struct {
	ID            int                  `json:"id"`
	Name          string               `json:"name"`
	CurClass      string               `json:"cur_class"`
	Feeling       Emotion              `json:"feeling"`
	IsActive      boolean              `json:"is_active"`
	Year          time.Time            `json:"year"`
	Graduation    time.Time            `json:"graduation"`
	Homeworks     []Homework           `json:"homeworks"`
	Something     map[string]string    `json:"something"`
}

// Students - An array of Student
type Students []Student
