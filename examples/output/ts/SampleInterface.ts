// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- examples/input/sample_interface.wings -c:wings.json` upon completion.

import Emotion from './person/Emotion';

// Just some interface
export default interface SampleInterface {
  functionTwo(): String;
  functionOne(firstParam: String, secondParam: String): void;
}