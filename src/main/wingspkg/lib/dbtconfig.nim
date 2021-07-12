import tables
import ./tconfig
import ./winterface

type DBConfig* = object
  dbtype*: string
  types*: Table[string, TypeInterpreter]
  keywords*: Table[DBKeyword, string]

type DBTConfig* = ref object of TConfig
  dbtype*: string
  keywords*: Table[DBKeyword, string]

proc initDBConfig*(
  dbtype: string = "",
  types: Table[string, TypeInterpreter] = initTable[string, TypeInterpreter](),
  keywords: Table[DBKeyword, string] = initTable[DBKeyword, string]()
): DBConfig =
  result = DBConfig()
  result.dbtype = dbtype
  result.types = types
  result.keywords = keywords

proc initDBTConfig(tconfig: TConfig): DBTConfig =
  result = DBTConfig()
  result.types = initTable[string, TypeInterpreter]()
  result.customTypes  = initTable[string, CustomTypeInterpreter]()
  result.keywords = initTable[DBKeyword, string]()
  result.dbtype = ""
  result.importPath = tconfig.importPath
  result.interfaceConfig = tconfig.interfaceConfig
  result.indentation = tconfig.indentation
  result.comment = tconfig.comment
  result.filename = tconfig.filename
  result.filetype = tconfig.filetype
  result.implementFormat = tconfig.implementFormat
  result.parseFormat = tconfig.parseFormat
  result.templates = tconfig.templates

proc toTConfig*(dbconfig: DBConfig, tconfig: TConfig): DBTConfig =
  ## This is intended to be used for field / type parsing and nothing else
  result = initDBTConfig(tconfig)
  result.customTypes = initTable[string, CustomTypeInterpreter]()
  result.types = dbconfig.types
  result.dbtype = dbconfig.dbtype
  result.keywords = dbconfig.keywords
