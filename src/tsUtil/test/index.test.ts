import { equal } from 'assert';
import { WingsStructUtil } from '../index';
import Student from './Student';
import Homework from './Homework';
import Emotion from './person/Emotion';

describe('isIWingsStruct', () => {
  it('Student should pass isIWingsStruct', () => {
    equal(WingsStructUtil.isIWingsStruct(new Student()), true);
  });
  it('Homework should pass isIWingsStruct', () => {
    equal(WingsStructUtil.isIWingsStruct(new Homework()), true);
  });

  class NonWingsClass {}

  it('NonWingsClass should fail isWingsStruct', () => {
    equal(WingsStructUtil.isIWingsStruct(new NonWingsClass()), false);
  });

  it('Passing non object into isIWingsStruct', () => {
    equal(WingsStructUtil.isIWingsStruct(''), false);
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
    something: {
      'a': 'b',
      'b': 'c',
    }
  });
  const reversedObj = new Student(
    JSON.parse(
      WingsStructUtil.stringify(student)
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
    equal(original.toISOString(), reversed.toISOString());
  } else if (original instanceof Array) {
    equal(reversed instanceof Array, true);
    equal(original.filter(
      (item: any) =>
      reversed.indexOf(item) < 0).length,
      0,
    );
  } else if (original instanceof Map) {
    equal(
      reversed instanceof Map,
      true
    );
    equal(
      Object.keys(original).length,
      Object.keys(reversed).length
    );
  } else {
    equal(reversed, original);
  }
}
