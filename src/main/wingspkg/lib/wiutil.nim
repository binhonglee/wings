from stones/cases import Case, allCases
from stones/strlib import replace
from strutils import join, split
import stones/log
import tables
import ./winterface, ./tconfig, ./tempconst, ./templating, ./templatable
import ../util/filename, ../util/header, ../util/config

proc fulfillDependency(
  iwings: var IWings,
  dependency: string,
  imports: Table[string, string],
  langConfig: Table[string, TConfig],
  name: string,
  wingsType: WingsType,
): bool =
  ## Fulfill the required dependency (after dependant file is generated).
  if not iwings.dependencies.contains(dependency):
    result = false
  else:
    for importType in imports.keys:
      if langConfig[importType].importPath.pathType == ImportPathType.Never:
        continue
      var ipString: string = imports[importType]
      var i: int = 1
      var replaceMap: Table[string, string] = initTable[string, string]()
      var words: seq[string] = ipString.split(
        langConfig[importType].importPath.separator
      )
      for w in words:
        var word: string = w
        var s: string = wrap($(words.len() - i))
        if word == "." or word == "..":
          s &= ":"
          word = ""
        replaceMap.add(s, word)
        inc(i)
      if langConfig[importType].importPath.format.len() > 0:
        words.setLen(words.len() - langConfig[importType].importPath.level)
        replaceMap.add(
          wrap(TK_IMPORT),
          words.join($langConfig[importType].importPath.separator),
        )
        ipString = langConfig[importType].importPath.format.replace(replaceMap)

      if not iwings.typesImported.hasKey(importType):
        iwings.typesImported.add(importType, initTable[string, ImportedWingsType]())

      for k, v in allCases(name, Snake).pairs:
        replaceMap.add(wrap(TK_TYPE, $k), v)

      iwings.typesImported[importType].add(
        name,
        initImportedWingsType(
          langConfig[importType].types[TYPE_IMPORTED].targetType.replace(replaceMap),
          langConfig[importType].types[TYPE_IMPORTED].targetInit.replace(replaceMap),
          wingsType,
        ),
      )
      iwings.addImport(ipString, importType)

    var location: int = iwings.dependencies.find(dependency)
    iwings.dependencies.delete(location)
    result = true

proc dependencyGraph*(
  allWings: var Table[string, IWings],
  config: Config,
): Table[string, Table[string, string]] =
  ## Generate and fulfill all dependencies in its intended succession.
  var noDeps: seq[string] = newSeq[string](0)
  var filenameToObj: Table[string, IWings] = initTable[string, IWings]()
  var reverseDependencyTable: Table[string, seq[string]] =
    initTable[string, seq[string]]()
  result = initTable[string, Table[string, string]]()

  var index = 0;
  for wings in allWings.values:
    filenameToObj[wings.filename] = wings
    if wings.dependencies.len() == 0:
      noDeps.add(wings.filename)

    for dependency in wings.dependencies:
      if not reverseDependencyTable.hasKey(dependency):
        reverseDependencyTable[dependency] = newSeq[string](0)
      reverseDependencyTable[dependency].add(wings.filename)

    inc(index)

  # TODO: Multithread this?
  while noDeps.len() > 0:
    var wings: IWings = filenameToObj[noDeps.pop()]
    var name: string = wings.filename
    LOG(DEBUG, "Generating files from " & name & "...")

    if not (config.skipImport and wings.imported):
      var files: Table[string, string] = initTable[string, string]()
      for lang in config.langConfigs.keys:
        if wings.filepath.hasKey(lang):
          files.add(
            outputFilename(
              wings.filename,
              wings.filepath[lang],
              config.langConfigs[lang],
            ),
            genHeader(
              config.langConfigs[lang].comment,
              wings.filename,
              config.header,
            ) & genFile(
              wingsToTemplatable(
                wings,
                config.langConfigs[lang]
              ),
              config.langConfigs[lang],
              wings.wingsType
            )
          )
      result.add(name, files)

    if reverseDependencyTable.hasKey(name):
      for dependant in reverseDependencyTable[name]:
        var obj = filenameToObj[dependant]
        var importFilenames: Table[string, string] = initTable[string, string]()
        for lang in config.langConfigs.keys:
          if wings.filepath.hasKey(lang):
            let ip: string = importFilename(
              wings.filename,
              wings.filepath[lang],
              obj.filename,
              obj.filepath[lang],
              config.langConfigs[lang],
            )

            if ip.len() > 0:
              importFilenames.add(lang,ip)

        let fulfillDep: bool = obj.fulfillDependency(
          name,
          importFilenames,
          config.langConfigs,
          wings.name,
          wings.wingsType,
        )
        if not fulfillDep:
          LOG(
            ERROR,
            "Something went wrong when fulfilling a dependency of" &
            name &
            "for " &
            obj.name,
          )
        else:
          allWings[obj.filename] = obj

      reverseDependencyTable.del(name)

    allWings.del(wings.filename)

  if allWings.len() > 0:
    let next = dependencyGraph(allWings, config)

    for k in next.keys:
      result.add(k, next[k])
