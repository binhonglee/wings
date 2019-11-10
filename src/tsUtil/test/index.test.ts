import { equal } from "assert";
import { WingsStructUtil } from "../index";
import Student from "./Student";
import Homework from "./Homework";
import Emotion from "./person/Emotion";

describe("isIWingsStruct", () => {
    it("Student should pass isIWingsStruct", () => {
        equal(WingsStructUtil.isIWingsStruct(new Student()), true);
    })
    it("Homework should pass isIWingsStruct", () => {
        equal(WingsStructUtil.isIWingsStruct(new Homework()), true);
    })
});

describe('stringify Student', () => {
    const student = new Student();
    student.init({
        id: 10000,
        name: 'Test Student Name',
        cur_class: 'Class Name',
        is_active: true,
        year: new Date(),
    });
    const reversedObj = new Student();
    reversedObj.init(JSON.parse(WingsStructUtil.stringify(student)));

    for (const key in student) {
        if (typeof key === 'string') {
            it(key, () => {
                if (student[key] instanceof Date) {
                    equal(reversedObj[key].getTime(), student[key].getTime());
                } else {
                    equal(reversedObj[key], student[key]);
                }
            });
        }
    }
});

describe('stringify Homework', () => {
    const homework = new Homework();
    homework.init({
        id: 10000,
        name: 'Test Homework Name',
        due_date: new Date(),
        given_date: new Date(),
        feeling: [Emotion.Accomplished, Emotion.Frustrated],
    });
    const reversedObj = new Homework();
    reversedObj.init(JSON.parse(WingsStructUtil.stringify(homework)));

    for (const key in homework) {
        if (typeof key === 'string') {
            it(key, () => {
                if (homework[key] instanceof Date) {
                    equal(reversedObj[key].getTime(), homework[key].getTime());
                } else if (homework[key] instanceof Array) {
                    equal(reversedObj[key] instanceof Array, true);
                    equal(homework[key].filter(
                        (item: any) =>
                            reversedObj[key].indexOf(item) < 0).length,
                        0,
                    );
                } else {
                    equal(reversedObj[key], homework[key]);
                }
            });
        }
    }
});
