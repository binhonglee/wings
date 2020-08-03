export interface IWingsStruct {
  toJsonKey(key: string): string;
}

export class WingsStructUtil {
  public static isIWingsStruct(arg: any): arg is IWingsStruct {
    return (arg as IWingsStruct).toJsonKey !== undefined;
  }

  public static stringify(obj: any): string {
    let toReturn = '{';

    if (typeof obj === 'object') {
      Object.keys(obj).forEach(key => {
        toReturn += this.wrap(obj.toJsonKey(key)) + ':' + this.valString(obj[key]) + ',';
      });
    } else {
      return this.valString(obj);
    }

    return toReturn.slice(0, -1) + '}';
  }

  private static wrap(toWrap: string) {
    return '\"' + toWrap + '\"';
  }

  private static valString(val: any): string {
    switch (typeof val) {
      case 'number': {
        return String(val);
      }
      case 'string': {
        return this.wrap(val);
      }
      case 'boolean': {
        return String(val);
      }
      default: {
        if (this.isIWingsStruct(val)) {
          return this.stringify(val);
        } else if (val instanceof Date) {
          return this.wrap(val.toISOString());
        } else if (val instanceof Array) {
          let toReturn = '[';
          for (const item of val) {
            toReturn += this.stringify(item) + ',';
          }
          if (val.length > 0) {
            toReturn = toReturn.slice(0, -1);
          }
          toReturn += ']';
          return toReturn;
        } else if (val instanceof Map) {
          let toReturn = '{';
          val.forEach((v, k) => {
            toReturn += this.stringify(k) + ':' + this.stringify(v) + ',';
          });
          if (val.size > 0) {
            toReturn = toReturn.slice(0, -1);
          }
          toReturn += '}';
          return toReturn;
      } else {
          return String(val);
        }
      }
    }
  }
}

export function parseMap<V>(obj?: any): Map<string, V> {
  let toReturn = new Map<string, V>();

  Object.keys(obj).forEach(key => {
    toReturn.set(key, obj[key]);
  });

  return toReturn;
}
