import { equal } from "assert";
import { WingsStructUtil } from "../index";
import Student from "./Student";

describe("isIWingsStruct", () => {
    it("Student should pass isIWingsStruct", () => {
        equal(WingsStructUtil.isIWingsStruct(new Student()), true);
    })
});

describe('stringify', () => {
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
