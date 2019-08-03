/*
 * This is a generated file
 * 
 * If you would like to make any changes, please edit the source file instead.
 * run `nimble genFile "{SOURCE_FILE}"` upon completion.
 * 
 * Source: examples/student.struct
 */

import People from './People';
import { Homework } from 'path/to/Homework';

export default class Student implements People {
    [key: string]: any;
    public id: number = -1;
    public name: string = '';
    public curClass: string = '';
    public isActive: boolean = true;
    public year: Date = new Date();
    public homeworks: Homework[] = [];
    
    public init(data: any): boolean {
        try {
            this.id = data.id;
            this.name = data.name;
            this.curClass = data.cur_class;
            this.isActive = data.is_active;
            this.year = new Date(data.year);
            
            if (data.homeworks !== null) {
                this.homeworks = data.homeworks;
            }
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
            case 'homeworks': {
                return 'homeworks';
            }
            default: {
                return key;
            }
        }
    }

    public addHomework(hw: Homework): void {
        this.Homeworks.push(hw);
    }
}
