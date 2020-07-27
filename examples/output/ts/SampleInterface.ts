// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
// Source: examples/input/sample_interface.wings

import Emotion from './person/Emotion';

// Just some interface
export default interface SampleInterface {
  functionTwo(): string;
  functionOne(firstParam: string, secondParam: string): void;
}