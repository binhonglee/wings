// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- examples/input/sample_interface.wings -c:wings.json` upon completion.

package go

import (
	person "github.com/binhonglee/wings/examples/output/go/person"
)

// SampleInterface - Just some interface
type SampleInterface interface {
	FunctionTwo() string
	FunctionOne(firstParam string, secondParam string) 
}