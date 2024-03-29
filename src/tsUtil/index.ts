export interface IWingsStruct {
  toJsonKey(key: string): string;
}

export class WingsStructUtil {
  public static isIWingsStruct(arg: any): arg is IWingsStruct {
    return (arg as IWingsStruct).toJsonKey !== undefined;
  }

  public static stringify(obj: any, escapeString = false): string {
    let toReturn = '{';

    if (typeof obj === 'object' &&
      !(obj instanceof Number) &&
      !(obj instanceof String) &&
      !(obj instanceof Boolean)
    ) {
      Object.keys(obj).forEach(key => {
        toReturn += this.wrap(obj.toJsonKey(key)) + ':' + this.valString(obj[key], escapeString) + ',';
      });
    } else {
      return this.valString(obj, escapeString);
    }

    return toReturn.slice(0, -1) + '}';
  }

  private static wrap(toWrap: string | String) {
    return '\"' + toWrap + '\"';
  }

  private static valString(val: any, escapeString: boolean): string {
    switch (typeof val) {
      case 'number': {
        return String(val);
      }
      case 'string': {
        if (escapeString) {
          val = stringEscape(val as string);
        }
        return this.wrap(val);
      }
      case 'boolean': {
        return String(val);
      }
      default: {
        if (this.isIWingsStruct(val)) {
          return this.stringify(val, escapeString);
        } else if (val instanceof Date) {
          return this.wrap(val.toISOString());
        } else if (val instanceof Array) {
          let toReturn = '[';
          for (const item of val) {
            toReturn += this.stringify(item, escapeString) + ',';
          }
          if (val.length > 0) {
            toReturn = toReturn.slice(0, -1);
          }
          toReturn += ']';
          return toReturn;
        } else if (val instanceof Map) {
          let toReturn = '{';
          val.forEach((v, k) => {
            toReturn += this.stringify(k, escapeString) + ':' + this.stringify(v, escapeString) + ',';
          });
          if (val.size > 0) {
            toReturn = toReturn.slice(0, -1);
          }
          toReturn += '}';
          return toReturn;
        } else if (val instanceof String) {
          return this.wrap(val);
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

function parseWingsArray<T>(
  TConstruct: new (_: any) => T, obj?: any[]
): T[] {
  let toReturn = [];
  for (const item of obj) {
    toReturn.push(new TConstruct(item));
  }
  return toReturn;
}

function parseRegularArray<T>(obj?: any[]): T[] {
  let toReturn = [];
  for (const item of obj) {
    toReturn.push(item);
  }
  return toReturn;
}

export function parseArray<T>(
  TConstruct: any, obj?: any[],
): T[] {
  if (
    TConstruct &&
    {}.toString.call(TConstruct) === '[object Function]'
  ) {
    return parseWingsArray<T>(TConstruct, obj)
  } else {
    return parseRegularArray(obj);
  }
}

export function stringEscape(val: string): string {
  return val.replace(/\\/g, "\\\\").replace(/'/g, "\\'").replace(/"/g, '\\"');
}

export function stringUnescape(val: string): string {
  return val
    .replace(/\\"/g, '"')
    .replace(/\\'/g, "'")
    .replace(/\\\\/g, "\\")
    .replace(/\n/g, "\\n");
}
