# Design

## 🎯 Goals

Wings is designed to solve the problem of maintaining consistent data structures across multiple programming languages. The core goal is simple but powerful:

**Allow customizable cross-language object (struct) and enum code generation to maintain variable name and type consistency across your tech stack.**

Instead of manually maintaining identical structs in your Go backend, TypeScript frontend, and Python services, you define them once in `.wings` files and generate consistent code everywhere.

### Key Design Principles

- **Single Source of Truth**: Define data structures once in `.wings` files
- **Consistency**: Maintain identical field names, types, and structure across languages
- **Customization**: Support configurable templates and output options
- **Dependency Management**: Handle imports and dependencies between wings files
- **Language Agnostic**: Abstract away language-specific details in the source format

## 🔄 Processing Flow

Based on the existing Wings architecture, here's how files are processed:

### Overview Diagram

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Input Files    │    │   Processing    │    │   Output Files  │
│                 │    │                 │    │                 │
│ • .wings files  │───▶│ • Parse         │───▶│ • Generated Go  │
│ • wings.json    │    │ • Dependencies  │    │ • Generated TS  │
│ • Templates     │    │ • Transform     │    │ • Generated Py  │
└─────────────────┘    │ • Generate      │    │ • etc...        │
                       └─────────────────┘    └─────────────────┘
```

### Stage-by-Stage Processing

#### Stage 1: Input Reading
- **Wings Files**: Read user-defined `.wings` files containing struct/enum definitions
- **Configuration**: Read `wings.json` for user preferences and settings
- **Templates**: Load language-specific template files (built-in or custom)
- **[Source](./api/wingspkg/core.html#fromFiles%2Cseq%5BT%5D%5Bstring%5D%2CConfig)**

#### Stage 2: Parse into IWings
- Convert `.wings` file syntax into structured `IWings` objects
- This creates an internal representation of the structs and enums
- Validates syntax and basic structure
- **[Source](./api/wingspkg/lib/winterface.html#parseFile%2Cstring%2Cbool)**

#### Stage 3: Check and Fulfill Dependencies
- **Dependency Analysis**: Scan for `import` statements in wings files
- **Circular Dependency Detection**: Wings doesn't allow circular dependencies
- **Ordered Processing**: Process files without dependencies first, then work up the chain
- **Skip Import Option**: If `skipImport` is true in config, skip generating dependency files
- **[Source](./api/wingspkg/lib/wiutil.html#dependencyGraph%2CTable%5Bstring%2CIWings%5D%2CConfig)**

#### Stage 4: Parse into Templatable
- Transform `IWings` objects into `Templatable` objects
- This step requires dependencies to be fulfilled first because it needs file paths/locations of imported types
- `Templatable` objects contain all the information needed for code generation
- **[Source](./api/wingspkg/lib/templatable.html#wingsToTemplatable%2CIWings%2CTConfig)**

#### Stage 5: Configuration Processing
- **Parse Config**: Convert `wings.json` into a `Config` object
- **Generate TConfig**: Create language-specific `TConfig` objects from the main config
- `TConfig` objects contain the template information for each target language
- **Sources**: [`wings.nim`](https://github.com/binhonglee/wings/blob/devel/src/main/wings.nim#L48-L51), [`config.nim`](./api/wingspkg/util/config.html#parse%2Cstring)

#### Stage 6: Generate Output Content
- Use the `Templatable` objects with `TConfig` templates to generate actual code
- Apply language-specific formatting and conventions
- Handle type mapping between wings types and target language types
- **Sources**: [`tutil.nim`](./api/wingspkg/lib/tutil.html#parse%2Cstring), [`templating.nim`](./api/wingspkg/lib/templating.html#genFile%2CTemplatable%2CTConfig%2CWingsType)

#### Stage 7: Create and Write Files
- Create output directories if they don't exist
- Write generated content to files (overwrites existing files)
- **Failure Point**: If files are write-protected, this step will fail
- **[Source](https://github.com/binhonglee/wings/blob/devel/src/main/wings.nim#L17-L28)**

## 🏗️ Core Components

### IWings Object
The intermediate representation created from parsing `.wings` files. Contains:
- Struct definitions with fields and types
- Enum definitions with values
- Import statements and dependencies
- Language-specific directives (filepath, imports, etc.)

### Templatable Object
The final internal representation before code generation. Contains:
- All information from IWings
- Resolved dependencies and file paths
- Processed field information ready for templating
- Language-agnostic representation of the data structures

### Config Object
Parsed from `wings.json`, contains:
- Header comments for generated files
- Language filters and output paths
- Custom acronyms and naming rules
- Import prefixes for different languages
- Logging and debugging settings

### TConfig Objects
Language-specific configuration objects that contain:
- Template definitions for each language
- Language-specific formatting rules
- Type mapping information
- Output file structure and naming conventions

## 🔧 Configuration System

The `wings.json` file controls various aspects of code generation:

### Available Configuration Options

| Option | Type | Description |
|--------|------|-------------|
| `header` | `[]string` | Header comments added to generated files |
| `acronyms` | `[]string` | Words to keep as ALL_CAPS in naming |
| `langFilter` | `[]string` | Limit generation to specific languages |
| `outputRootDirs` | `[]string` | Multiple root directories for output |
| `prefixes` | `map[string]string` | Import prefixes per language (especially for Go) |
| `skipImport` | `bool` | Skip processing imported files |
| `logging` | `int` | Logging verbosity level |
| `langConfigs` | `[]string` | Custom language template files |

### Example Configuration

```json
{
  "header": [
    "This is a generated file",
    "Source: {#SOURCE_FILE}"
  ],
  "acronyms": ["ID", "API", "URL"],
  "langFilter": ["go", "ts", "py"],
  "prefixes": {
    "go": "github.com/yourorg/yourproject"
  },
  "skipImport": false,
  "logging": 2
}
```

## 🌐 Language Template System

Wings uses a template-based approach for generating code in different languages:

### Template Structure
Each language has its own template files that define:
- How structs should be formatted
- How enums should be formatted
- Import statement patterns
- Naming conventions
- Type mappings

### Custom Templates
Users can provide custom language templates by:
- Specifying `langConfigs` in `wings.json`
- Pointing to custom template files
- Overriding built-in templates with custom logic

### Built-in Language Support
Wings includes built-in templates for:
- Go
- TypeScript
- Python
- Kotlin
- Nim

## 🔗 Dependency Management

### Import System
Wings files can import other wings files:
```wings
import shared/common.wings
import validation/rules.wings
```

### Dependency Resolution
- **No Circular Dependencies**: Wings prevents circular imports
- **Ordered Processing**: Dependencies are processed before files that depend on them
- **Path Resolution**: Import paths are resolved relative to the wings file location
- **Skip Option**: `skipImport` allows generating only the main file without dependencies

### Dependency Graph
Wings builds an internal dependency graph to:
- Detect circular dependencies (error condition)
- Determine processing order
- Ensure all imports are resolved
- Generate only necessary files

## 🎨 Code Generation Process

### Type Mapping
Wings maps its internal types to language-specific types:

| Wings Type | Go | TypeScript | Python | Kotlin | Nim |
|------------|----|-----------|---------|---------|----|
| `int` | `int` | `number` | `int` | `Int` | `int` |
| `str` | `string` | `string` | `str` | `String` | `string` |
| `bool` | `bool` | `boolean` | `bool` | `Boolean` | `bool` |
| `[]T` | `[]T` | `T[]` | `List[T]` | `List<T>` | `seq[T]` |
| `Map<K,V>` | `map[K]V` | `Map<K,V>` | `Dict[K,V]` | `Map<K,V>` | `Table[K,V]` |

### Field Processing
For each field in a struct:
- Apply naming conventions (snake_case → camelCase/PascalCase)
- Map types to target language
- Handle default values
- Generate JSON tags/keys
- Process optional vs required fields

### Output Generation
- Apply language-specific templates
- Generate imports and dependencies
- Create constructors/initializers
- Add custom methods if specified
- Format according to language conventions

## 📁 File Organization

### Input Structure
```
project/
├── wings/
│   ├── models/
│   │   ├── user.wings
│   │   └── product.wings
│   └── shared/
│       └── common.wings
├── wings.json
└── ...
```

### Output Structure
```
project/
├── generated/
│   ├── go/
│   │   ├── user.go
│   │   └── product.go
│   ├── typescript/
│   │   ├── User.ts
│   │   └── Product.ts
│   └── python/
│       ├── user.py
│       └── product.py
└── ...
```

## 🔍 Current Limitations & Considerations

### Known Constraints
- **No Circular Dependencies**: Wings doesn't support circular imports between wings files
- **Write Protection**: Generation fails if target files are write-protected
- **Template Dependency**: Advanced features require understanding of template system
- **Language Limitations**: Some language-specific features may not be supported

### Design Trade-offs
- **Consistency over Optimization**: Prioritizes consistent output over language-specific optimizations
- **Simplicity over Flexibility**: Keeps the wings syntax simple, which may limit complex use cases
- **Generate-time vs Runtime**: All processing happens at generation time, not runtime

## 🚀 Extension Points

### Custom Templates
- Users can create custom language templates
- Override built-in templates for specific needs
- Add support for new languages

### Configuration Flexibility
- Multiple output directories
- Language-specific prefixes and imports
- Custom header templates
- Flexible logging and debugging

### Future Extensibility
The architecture allows for potential future enhancements:
- Additional language support
- More sophisticated type systems
- Enhanced template features
- Better debugging and error reporting

## 📝 Template System Details

Wings uses a powerful template system that allows customization of output for different languages. This is for more advanced use case where you want your own way of formatting for the output files or if you use wings for languages that is not currently supported.

### Template Configuration Structure

Each language template is defined by a JSON configuration file with the following structure:

#### Required Fields
- **comment**: Language line prefix for comments (e.g., `//` in TypeScript or `#` in Python)
- **filename**: Case format for output filenames
- **filetype**: File extension for generated files (also used for deduplication)
- **importPath**: Object defining how import paths are handled
- **templates**: Object containing paths to struct and enum template files

#### Optional Fields
- **implementFormat**: String format for class extension/implementation (default: `"{#IMPLEMENT}"`)
- **indentation**: Object defining spacing and pre-indentation settings
- **parseFormat**: General fallback for parsing if specific targetParse isn't defined
- **types**: Array of type mapping objects

### Import Path Configuration
The `importPath` object controls how imports are handled:

- **format**: Import path format string (default: `"{#IMPORT}"`)
- **separator**: Path separator character (default: `/`)
- **pathType**: How import paths should be written (`"never"`, `"absolute"`, or `"relative"`)
- **prefix**: Prefix for import paths (can be overridden by project config)
- **level**: Folder level for import resolution (0 = file itself, 1 = containing folder, etc.)

### Type Mapping System
Custom types can be defined in the `types` array with:

- **wingsType**: Type name as used in Wings files
- **targetType**: Corresponding type in the target language
- **targetInit**: Initialization string for the target type (optional)
- **requiredImport**: Import statement needed when this type is used (optional)

### Template Variables
Wings provides several template variables for use in templates and headers:

- `{#SOURCE_FILE}`: Original Wings file path
- `{#IMPORT}`: Import path placeholder
- `{#IMPLEMENT}`: Class implementation/extension placeholder

### Custom Template Creation
Check out the [examples/input/template](https://github.com/binhonglee/wings/tree/devel/examples/input/templates) folder for an example of how it works for currently supported languages (start from the json files).

The template system allows for:
- Custom language support beyond the built-in languages
- Customized output formatting for existing languages
- Control over import handling and file structure
- Flexible type mapping between Wings and target languages

---

This design documentation reflects the actual architecture of Wings as described in the existing documentation, without adding speculative features or capabilities.
