/*
 * This is a generated file
 * 
 * If you would like to make any changes, please edit the source file instead.
 * run `nimble genFile "{SOURCE_FILE}"` upon completion.
 * Source: examples/student.struct.wings
 */

package classroom

import (    
    emotion "github.com/binhonglee/wings/examples/go"
    "time"
)

// Student - Any person who is studying in a class
type Student struct {
    ID int `json:"id"`
    Name string `json:"name"`
    CurClass string `json:"cur_class"`
    Feeling emotion.Emotion `json:"feeling"`
    IsActive bool `json:"is_active"`
    Year time.Time `json:"year"`
    Graduation time.Time `json:"graduation"`
    Homeworks []Homework `json:"homeworks"`
    Something map[string]string `json:"something"`
}

// Students - An array of Student
type Students []Student