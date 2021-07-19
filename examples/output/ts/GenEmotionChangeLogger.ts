// This is a generated file
//
// If you would like to make any changes, please edit the source file instead.
// run `plz genFile -- examples/input/emotion_change_logger.wings -c:wings.json` upon completion.

import { Client } from 'pg';
import Emotion from './person/Emotion';

export default class GenEmotionChangeLogger {
  public static async create(): Promise<void> {
    const client = new Client();
    client.connect();

    const ifExists = `
      SELECT EXISTS(
        SELECT 1
        FROM EmotionChangeLogger
      );`;

    try {
      await client.query(ifExists);
      await client.query("ALTER TABLE EmotionChangeLogger ADD COLUMN IF NOT EXISTS time TIMESTAMPZ NOT NULL;")
      await client.query("ALTER TABLE EmotionChangeLogger ADD COLUMN IF NOT EXISTS uid INT PRIMARY NOT NULL;")
      await client.query("ALTER TABLE EmotionChangeLogger ADD COLUMN IF NOT EXISTS event INT NOT NULL;")
    } catch(err) {
      const createTable = `
        CREATE TABLE EmotionChangeLogger (
          time TIMESTAMPZ NOT NULL,
          uid INT PRIMARY NOT NULL,
          event INT NOT NULL
        );`
      await client.query(createTable);
    }
  }
}