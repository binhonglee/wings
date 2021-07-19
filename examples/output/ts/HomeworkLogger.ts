// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- examples/input/homework_logger.wings -c:wings.json` upon completion.

import { Client } from 'pg';
import Emotion from './person/Emotion';

export default class HomeworkLogger {
  public static async log(
    ID: Number = 0,
    name: String = '',
    emotion: Emotion = new Emotion(),
    dueDate: Date = new Date(),
    givenDate: Date = new Date(),
  ): Promise<boolean> {
    const client = new Client();
    client.connect();

    const sqlStatement = 'INSERT INTO HomeworkLogger (id, name, emotion, due_date, given_date) VALUES($1, $2, $3, $4, $5)';
    const values = [ID, name, emotion, dueDate, givenDate];

    try {
      await client.query(sqlStatement, values);
      return true;
    } catch (err) {
      return false;
    }
  }
}