// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
// Source: examples/input/student.wings

import Homework from './Homework';
import Emotion from './person/Emotion';

// Any person who is studying in a class
export default class Student {
  [key: string]: any;
  public ID: number = -1;
  public name: string = '';
  public curClass: string = '';
  public feeling: Emotion = Emotion.Meh;
  public isActive: boolean = false;
  public year: Date = new Date();
  public graduation: Date = new Date();
  public homeworks: Homework[] = [];
  public something: Map<string, string> = new Map<string, string>();

  public constructor(obj?: any) {
    if (obj) {
      this.ID = obj.id || -1
      this.name = obj.name || ''
      this.curClass = obj.cur_class || ''
      this.feeling = obj.feeling || Emotion.Meh
      this.isActive = obj.is_active || false
      this.year = obj.year || new Date()
      this.graduation = obj.graduation || new Date()
      this.homeworks = obj.homeworks || []
      this.something = obj.something || new Map<string, string>()
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
      case 'curClass': {
        return 'cur_class';
      }
      case 'feeling': {
        return 'feeling';
      }
      case 'isActive': {
        return 'is_active';
      }
      case 'year': {
        return 'year';
      }
      case 'graduation': {
        return 'graduation';
      }
      case 'homeworks': {
        return 'homeworks';
      }
      case 'something': {
        return 'something';
      }
      default: {
        return key;
      }
    }
  }

  public addHomework(hw: Homework): void {
    this.Homeworks.push(hw);
  }
}