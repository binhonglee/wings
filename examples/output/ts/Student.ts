// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- examples/input/student.wings -c:wings.json` upon completion.

import { parseMap } from 'wings-ts-util';
import Homework from './Homework';
import { parseArray } from 'wings-ts-util';
import Emotion from './person/Emotion';
import { IWingsStruct } from 'wings-ts-util';

// Any person who is studying in a class
export default class Student implements IWingsStruct {
  [key: string]: any;
  public ID: Number = -1;
  public name: String = '';
  public curClass: String = '';
  public feeling: Emotion = Emotion.Meh;
  public isActive: Boolean = false;
  public year: Date = new Date();
  public graduation: Date = new Date();
  public homeworks: Homework[] = [];
  public ids: Number[] = [];
  public something: Map<String, String> = new Map<String, String>();

  public constructor(obj?: any) {
    if (obj) {
      this.ID = obj.id !== undefined && obj.id !== null ? obj.id : -1;
      this.name = obj.name !== undefined && obj.name !== null ? obj.name : '';
      this.curClass = obj.cur_class !== undefined && obj.cur_class !== null ? obj.cur_class : '';
      this.feeling = obj.feeling !== undefined && obj.feeling !== null ? obj.feeling : Emotion.Meh;
      this.isActive = obj.is_active !== undefined && obj.is_active !== null ? obj.is_active : false;
      this.year = obj.year !== undefined && obj.year !== null ? new Date(obj.year) : new Date();
      this.graduation = obj.graduation !== undefined && obj.graduation !== null ? new Date(obj.graduation) : new Date();
      this.homeworks = obj.homeworks !== undefined && obj.homeworks !== null ? parseArray<Homework>(Homework, obj.homeworks) : [];
      this.ids = obj.ids !== undefined && obj.ids !== null ? parseArray<Number>(Number, obj.ids) : [];
      this.something = obj.something !== undefined && obj.something !== null ? parseMap<String>(obj.something) : new Map<String, String>();
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
      case 'ids': {
        return 'ids';
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