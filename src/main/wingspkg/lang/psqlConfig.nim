import tables
import ../lib/tconfig
import ../lib/dbtconfig
import ../lib/winterface

let TYPES: Table[string, TypeInterpreter] = {
  "dbl": initTypeInterpreter("dbl", "DOUBLE", "", "", ""),
  "bool": initTypeInterpreter("bool", "BOOL", "", "", ""),
  "flt": initTypeInterpreter("flt", "FLOAT", "", "", ""),
  "date": initTypeInterpreter("date", "TIMESTAMPZ", "", "", ""),
  "str": initTypeInterpreter("str", "TEXT", "", "", ""),
  "int": initTypeInterpreter("int", "INT", "", "", ""),
}.toTable()

let KEYWORDS: Table[DBKeyword, string] = {
  DBKeyword.key: "KEY",
  DBKeyword.nonnull: "NOT NULL",
  DBKeyword.primary: "PRIMARY",
  DBKeyword.serial: "SERIAL",
  DBKeyword.unique: "UNIQUE"
}.toTable()

let PSQL_CONFIG*: DBConfig = initDBConfig(
  "psql",
  TYPES,
  KEYWORDS,
)
