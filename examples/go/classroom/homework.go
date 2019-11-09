/*
 * This is a generated file
 * 
 * If you would like to make any changes, please edit the source file instead.
 * run `nimble genFile "{SOURCE_FILE}"` upon completion.
 * Source: examples/homework.struct.wings
 */

package classroom

import (    
    "time"
)

// Homework - Work to be done at home
type Homework struct {
    ID           int          `json:"id"`
    Name         string       `json:"name"`
    DueDate      time.Time    `json:"due_date"`
    GivenDate    time.Time    `json:"given_date"`
}

// Test - This comment should be included.
func Test() int {
    return 0
}

// Homeworks - An array of Homework
type Homeworks []Homework