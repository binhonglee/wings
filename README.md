# wings

A customizable cross language struct and enum file generator.

[![Build Status](https://travis-ci.org/binhonglee/wings.svg?branch=master)](https://travis-ci.org/binhonglee/wings)
[![codecov](https://codecov.io/gh/binhonglee/wings/branch/master/graph/badge.svg)](https://codecov.io/gh/binhonglee/wings)
[![CodeFactor](https://www.codefactor.io/repository/github/binhonglee/wings/badge)](https://www.codefactor.io/repository/github/binhonglee/wings)

## Requirements

- [Nim](https://nim-lang.org/)
- [Please](https://please.build)
- [MkDocs](https://www.mkdocs.org/) (Documentation)

\*_Note: There are also other packages needed for deployment due to cross compilation (like `gcc-multilib`, `gcc-arm-linux-gnueabihf`, `mingw-w64` etc...)._

## Development Tools (scripts)

- Run mkdocs development server for realtime feedback on changes made `docs` folder _(requires `mkdocs`)_
  - `plz docs`
- Build release binaries for distribution
  - `plz release`
- Generate / Update the `lang` folder [(`src/main/wingspkg/lang`)](https://github.com/binhonglee/wings/tree/devel/src/main/wingspkg/lang) based on the files in the [`examples/input/templates`](https://github.com/binhonglee/wings/tree/devel/examples/input/templates) folder
  - `plz lang`
- Run tests
  - `./scripts/test.sh` (This isn't a proper test for everything. Recommend reading the script, < 20 lines, before running it.)

For some more comprehensive set up / testing procedure, [`.travis.yml`](https://github.com/binhonglee/wings/blob/devel/.travis.yml) file might be a good place to start looking into.

\*_Note: Replace `plz` with `./pleasew` if you do not have please installed._

\*_More note: `please` might face some permission issues when run in WSL though this is not a `please` specific issue. Will update with more detailed debugging instructions when I have more time._

## Supported languages

- [go](http://golang.org/)
- [Kotlin](https://kotlinlang.org)
- [Nim](https://nim-lang.org/)
- [Python](https://www.python.org/)
- [TypeScript](https://www.typescriptlang.org)
    - [Utility package](https://github.com/binhonglee/wings/tree/devel/src/tsUtil)

## Further Documentations

- [Usage explanation and examples](https://wings.sh).
- [API docs](https://wings.sh/main).
