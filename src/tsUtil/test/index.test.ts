import { describe, it } from "mocha";
import { strictEqual } from 'assert';
import { WingsStructUtil } from '../index';
import Student from './Student';
import Homework from './Homework';
import Emotion from './person/Emotion';

describe('isIWingsStruct', () => {
  it('Student should pass isIWingsStruct', () => {
    strictEqual(WingsStructUtil.isIWingsStruct(new Student()), true);
  });
  it('Homework should pass isIWingsStruct', () => {
    strictEqual(WingsStructUtil.isIWingsStruct(new Homework()), true);
  });

  class NonWingsClass {}

  it('NonWingsClass should fail isWingsStruct', () => {
    strictEqual(WingsStructUtil.isIWingsStruct(new NonWingsClass()), false);
  });

  it('Passing non object into isIWingsStruct', () => {
    strictEqual(WingsStructUtil.isIWingsStruct(''), false);
  });
});

describe('stringify Student', () => {
  const student = new Student({
    id: 10000,
    name: 'Test Student Name',
    cur_class: 'Class Name',
    is_active: true,
    feeling: Emotion.Meh,
    year: new Date(),
    homeworks: [
      new Homework({
        id: 2353456,
        name: 'Test "Homework1" Name',
        due_date: new Date(),
        given_date: new Date(),
        feeling: [Emotion.Accomplished, Emotion.Frustrated],
      }),
      new Homework({
        id: 7856,
        name: 'Test Homework2 Name',
        due_date: new Date(),
        given_date: new Date(),
        feeling: [Emotion.Accomplished, Emotion.Frustrated],
      }),
    ],
    ids: [1, 2, 3, 5],
    something: {
      'a': 'b',
      'b': 'c',
    }
  });
  const reversedObj = new Student(
    JSON.parse(
      WingsStructUtil.stringify(student, true)
    )
  );

  for (const key in student) {
    if (typeof key === 'string') {
      it(key, () => {
        test(student[key], reversedObj[key])
      });
    }
  }
});

describe('stringify Homework', () => {
  const homework = new Homework({
    id: 10000,
    name: 'Test Homework Name',
    due_date: new Date(),
    given_date: new Date(),
    feeling: [Emotion.Accomplished, Emotion.Frustrated],
  });
  const reversedObj = new Homework(
    JSON.parse(
      WingsStructUtil.stringify(homework)
    )
  );

  for (const key in homework) {
    if (typeof key === 'string') {
      it(key, () => {
        test(homework[key], reversedObj[key]);
      });
    }
  }
});

function test(original?: any, reversed?: any) {
  if (original instanceof Date) {
    strictEqual(original.toISOString(), reversed.toISOString());
  } else if (original instanceof Array) {
    strictEqual(reversed instanceof Array, true);
    strictEqual(
      original.length,
      reversed.length,
    );
  } else if (original instanceof Map) {
    strictEqual(
      reversed instanceof Map,
      true
    );
    strictEqual(
      Object.keys(original).length,
      Object.keys(reversed).length
    );
  } else {
    strictEqual(reversed, original);
  }
}
