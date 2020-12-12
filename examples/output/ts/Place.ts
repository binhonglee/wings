// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- examples/input/place.wings -c:wings.json` upon completion.

import { IWingsStruct } from 'wings-ts-util';

// One of many location for a Day (in a Trip).
export default class Place implements IWingsStruct {
  [key: string]: any;
  public ID: Number = 0;
  public label: String = '';
  public url: String = '';
  public description: String = '';

  public constructor(obj?: any) {
    if (obj) {
      this.ID = obj.id !== undefined && obj.id !== null ? obj.id : 0;
      this.label = obj.label !== undefined && obj.label !== null ? obj.label : '';
      this.url = obj.url !== undefined && obj.url !== null ? obj.url : '';
      this.description = obj.description !== undefined && obj.description !== null ? obj.description : '';
    }
  }

  public toJsonKey(key: string): string {
    switch (key) {
      case 'ID': {
        return 'id';
      }
      case 'label': {
        return 'label';
      }
      case 'url': {
        return 'url';
      }
      case 'description': {
        return 'description';
      }
      default: {
        return key;
      }
    }
  }
}