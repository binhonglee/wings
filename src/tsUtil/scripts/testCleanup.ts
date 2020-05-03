import { rmdirSync, unlinkSync } from 'fs';
import { folders, files } from './const';

Object.keys(files).forEach(file => {
  unlinkSync(files[file]);
});

folders.forEach(folder => {
  rmdirSync(folder);
});
