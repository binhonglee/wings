// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- "{SOURCE_FILE}" -c:wings.json` upon completion.
// Source: examples/input/homework.wings

import Emotion from './person/Emotion';

// Work to be done at home
export default class Homework {
    [key: string]: any;
    public ID: number = 0;
    public name: string = '';
    public dueDate: Date = new Date();
    public givenDate: Date = new Date();
    public feeling: Emotion[] = [];

    public init(data: any): boolean {
        try {
            this.ID = data.id;
            this.name = data.name;
            this.dueDate = data.due_date;
            this.givenDate = data.given_date;
            this.feeling = data.feeling;
        } catch (e) {
            return false;
        }
        return true;
    }

    public toJsonKey(key: string): string {
        switch (key) {
            case 'ID': {
                return 'id';
            }
            case 'name': {
                return 'name';
            }
            case 'dueDate': {
                return 'due_date';
            }
            case 'givenDate': {
                return 'given_date';
            }
            case 'feeling': {
                return 'feeling';
            }
            default: {
                return key;
            }
        }
    }
}