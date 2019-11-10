export interface IWingsStruct {
    toJsonKey(key: string): string;
}

export class WingsStructUtil {
    public static isIWingsStruct(arg: any): arg is IWingsStruct {
        try {
            return (arg as IWingsStruct).toJsonKey !== undefined;
        } catch (e) {
            return false;
        }
    }

    public static stringify(obj: any): string {
        let toReturn = '{';
        for (const key in obj) {
            if (typeof key === 'string') {
                if (typeof obj[key] !== 'function') {
                    toReturn += this.wrap(obj.toJsonKey(key)) + ':' + this.valString(obj[key]) + ',';
                }
            }
        }

        // This means that 'obj' is not iterable.
        if (toReturn.length < 2) {
            return obj;
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
                if (val instanceof Date) {
                    return this.wrap(val.toISOString());
                } else if (val instanceof Array) {
                    if (val.length === 0) {
                        return 'null';
                    } else {
                        let toReturn = '[';
                        for (const item of val) {
                            toReturn += this.stringify(item) + ',';
                        }
                        toReturn = toReturn.slice(0, -1);
                        toReturn += ']';
                        return toReturn;
                    }
                } else if (this.isIWingsStruct(val)) {
                    return this.stringify(val);
                } else {
                    throw new TypeError();
                }
            }
        }
    }
}
