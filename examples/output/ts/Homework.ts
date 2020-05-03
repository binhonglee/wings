// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
// Source: examples/input/homework.wings

import { IWingsStruct } from 'wings-ts-util';
import Emotion from './person/Emotion';

// Work to be done at home
export default class Homework implements IWingsStruct {
  [key: string]: any;
  public ID: number = 0;
  public name: string = '';
  public dueDate: Date = new Date();
  public givenDate: Date = new Date();
  public feeling: Emotion[] = [];

  public constructor(obj?: any) {
    if (obj) {
      this.ID = obj.id !== undefined && obj.id !== null ? obj.id : 0;
      this.name = obj.name !== undefined && obj.name !== null ? obj.name : '';
      this.dueDate = obj.due_date !== undefined && obj.due_date !== null ? new Date(obj.due_date) : new Date();
      this.givenDate = obj.given_date !== undefined && obj.given_date !== null ? new Date(obj.given_date) : new Date();
      this.feeling = obj.feeling !== undefined && obj.feeling !== null ? obj.feeling : [];
    }
  }

  public toJsonKey(key: string): string {
    switch (key) {
      case 'ID': {
        return 'id';
      }
      case 'name': {
        return 'name';
      }
      case 'dueDate': {
        return 'due_date';
      }
      case 'givenDate': {
        return 'given_date';
      }
      case 'feeling': {
        return 'feeling';
      }
      default: {
        return key;
      }
    }
  }
}