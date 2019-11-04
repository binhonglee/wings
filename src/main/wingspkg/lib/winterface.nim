import sets
import tables

type
    IWings* = ref object of RootObj
        name*: string
        filename*: string
        dependencies*: seq[string]
        filepath*: Table[string, string]
        imports*: Table[string, HashSet[string]]

proc addImport(iwings: var IWings, newImport: string, importLang: string): void =
    if not iwings.imports.hasKey(importLang):
        iwings.imports.add(importLang, initHashSet[string]())

    iwings.imports[importLang].incl(newImport)

proc fulfillDependency*(iwings: var IWings, dependency: string, imports: Table[string, string]): bool =
    if not iwings.dependencies.contains(dependency):
        result = false
    else:
        for importType in imports.keys:
            if importType == "kt":
                continue
            iwings.addImport(imports[importType], importType)

        var location: int = iwings.dependencies.find(dependency)
        iwings.dependencies.delete(location)
        result = true
