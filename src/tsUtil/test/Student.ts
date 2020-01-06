import { IWingsStruct } from '../';

export default class Student implements IWingsStruct {
  [key: string]: any;
  public id: number = -1;
  public name: string = '';
  public curClass: string = '';
  public isActive: boolean = true;
  public year: Date = new Date();

  public init(data: any): boolean {
    try {
      this.id = data.id;
      this.name = data.name;
      this.curClass = data.cur_class;
      this.isActive = data.is_active;
      this.year = new Date(data.year);
    } catch (e) {
      return false;
    }
    return true;
  }

  public toJsonKey(key: string): string {
    switch (key) {
      case 'id': {
        return 'id';
      }
      case 'name': {
        return 'name';
      }
      case 'curClass': {
        return 'cur_class';
      }
      case 'isActive': {
        return 'is_active';
      }
      case 'year': {
        return 'year';
      }
      default: {
        return key;
      }
    }
  }
}
