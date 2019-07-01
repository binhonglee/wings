/* This is a generated file
 *
 * If you would like to make any changes, please edit the source file instead.
 * run `nimble genFile "{SOURCE_FILE}"` upon completion.
 * Source: examples/student.struct
 */

import People from './People';
import Homework from 'path/to/Homework';

export default class Student implements People {
    [key: string]: any;
    public id: number;
    public name: string;
    public class: string;
    public isActive: boolean;
    public year: Date;
    public homeworks: [];
    
    constructor() {
        this.id = -1;
        this.name = '';
        this.class = '';
        this.isActive = true;
        this.year = new Date();
        this.homeworks = [];
    }
    
    public init(
        id: number,
        name: string,
        class: string,
        isActive: boolean,
        year: Date,
        homeworks: [],
    ): void {
        this.id = id;
        this.name = name;
        this.class = class;
        this.isActive = isActive;
        this.year = year;
        this.homeworks = homeworks;
    }
    
    public toJsonKey(key: string): string {
        switch (key) {
            case 'id': {
                return 'id';
            }
            case 'name': {
                return 'name';
            }
            case 'class': {
                return 'class';
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
