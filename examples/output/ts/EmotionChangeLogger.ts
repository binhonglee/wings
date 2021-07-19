// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- examples/input/emotion_change_logger.wings -c:wings.json` upon completion.

import { Client } from 'pg';
import Emotion from './person/Emotion';

export default class EmotionChangeLogger {
  public static async log(
    time: Date = new Date(),
    uid: Number = 0,
    event: Emotion = new Emotion(),
  ): Promise<boolean> {
    const client = new Client();
    client.connect();

    const sqlStatement = 'INSERT INTO EmotionChangeLogger (time, uid, event) VALUES($1, $2, $3)';
    const values = [time, uid, event];

    try {
      await client.query(sqlStatement, values);
      return true;
    } catch (err) {
      return false;
    }
  }
}