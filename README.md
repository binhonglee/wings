# wings

[![Build Status](https://travis-ci.org/binhonglee/wings.svg?branch=master)](https://travis-ci.org/binhonglee/wings)
[![codecov](https://codecov.io/gh/binhonglee/wings/branch/master/graph/badge.svg)](https://codecov.io/gh/binhonglee/wings)
[![CodeFactor](https://www.codefactor.io/repository/github/binhonglee/wings/badge)](https://www.codefactor.io/repository/github/binhonglee/wings)
[![wakatime](https://wakatime.com/badge/github/binhonglee/wings.svg)](https://wakatime.com/badge/github/binhonglee/wings)

## Requirements

- [Nim](https://nim-lang.org/)
    - [Nimble](https://github.com/nim-lang/nimble) - Bundled with Nim
- [Please](https://please.build) (alternative to nimble)

\*_Note: Replace `plz` with `./pleasew` if you do not have please installed._

## Supported languages

- [go](http://golang.org/)
- [Kotlin](https://kotlinlang.org) (WIP)
- [Nim](https://nim-lang.org/) (WIP)
- [Python](https://www.python.org/) (WIP)
- [TypeScript](https://www.typescriptlang.org)
    - [Utility package](https://github.com/binhonglee/wings-ts-util)

## Supported types

| wings               | Go                | Kotlin                  | Nim                   | Python | TypeScript          |
| :------------------ | :---------------- | :---------------------- | :-------------------- | :----- | :------------------ |
| `int`               | `int`             | `Int`                   | `int`                 | `int`  | `number`            |
| `str`               | `string`          | `String`                | `string`              | `str`  | `string`            |
| `bool`              | `bool`            | `Boolean`               | `bool`                | `bool` | `boolean`           |
| `date`              | `time.Time`       | `Date`                  | -                     | `date` | `Date`              |
| `[]type`            | `[]type`          | `ArrayList<type>`       | `seq[type]`           | `list` | `[]`                |
| `Map<type1, type2>` | `map[type1]type2` | `HashMap<type1, type2>` | `Table[type1, type2]` | `dict` | `Map<type1, type2>` |

## Documentations

- [API and usage docs](https://wings.sh).
