import { accessSync, constants, mkdirSync, readFileSync, rmdirSync, unlinkSync, writeFileSync } from 'fs';
import { folders, files } from './const';

folders.forEach(folder => {
  try {
    mkdirSync(folder);
  } catch (err) {
    console.log("Folder (" + folder + ") already exist. Skip creating it.")
  }
});

Object.keys(files).forEach(file => {
  let output = readFileSync(file, 'utf8');
  output = output.replace(/wings-ts-util/g, '../index');
  try {
    accessSync(files[file], constants.R_OK && constants.W_OK);
    unlinkSync(files[file]);
  } catch (err) {
    console.log("File (" + file + ") does not exist or unaccessible. Not deleting it.");
  }
  writeFileSync(files[file], output, 'utf8');
});
