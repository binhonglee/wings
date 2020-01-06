# wings-ts-util

## Requirements

- [TypeScript](https://www.typescriptlang.org/)

## Usage

```sh
npm install -D wings-ts-util
```

person.struct

```text
ts-filepath path/to/tsfile

ts-import { IWingsStruct }:wings-ts-util

ts-implement IWingsStruct

Person {
  id    int   -1
  name  str
}
```

TypeScript

```ts
import { WingsStructUtil } from wings-ts-util;
import Person from 'path/to/tsfile';

export class SomeClass {
  public static someFunction(someone: Person): string {
    return WingsStructUtil.stringify(someone);
  }

  public static personIsWingsStruct(someone: Person): bool {
    return WingsStructUtil.isIWingsStruct(someone);
  }
}
```
