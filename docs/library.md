# Using Wings as a Nimble Library

Wings can be used programmatically as a Nim library.

## Installation

```bash
nimble install wings
```

## API Structure

### Core Modules
- `wingspkg/core` - Main processing functions
- `wingspkg/util/config` - Configuration management
- `wingspkg/util/upgrade` - Version management

### Main API Function

The primary function for code generation is `fromFiles()` from the core module:

```nim
import wingspkg/core
import wingspkg/util/config

# The main generation function
proc fromFiles(wingsFiles: seq[string], config: Config): Table[string, Table[string, string]]
```

This function:
- Takes a sequence of Wings file paths
- Takes a configuration object
- Returns a nested table structure: `[filename][filetype] -> generated_content`

## Configuration Management

### Loading Configuration

```nim
import wingspkg/util/config

# Parse configuration from JSON file
proc parse(configPath: string): Config

# Initialize default config
proc initConfig(): Config
```

### Configuration Type

## Complete Usage Example

```nim
import wingspkg/core
import wingspkg/util/config
import tables
import os

# Load configuration
var config = initConfig()  # Start with defaults
if fileExists("wings.json"):
  config = parse("wings.json")

# Process Wings files
let wingsFiles = @["schemas/user.wings", "schemas/api.wings"]
let outputFiles = fromFiles(wingsFiles, config)

# Write generated files
for filename in outputFiles.keys:
  for filetype in outputFiles[filename].keys:
    let content = outputFiles[filename][filetype]
    let outputPath = filename & "." & filetype
    
    # Create output directory if needed
    createDir(parentDir(outputPath))
    writeFile(outputPath, content)
    echo "Generated: ", outputPath
```

## Advanced Usage

### Custom Configuration

```nim
import wingspkg/util/config
import tables

# Create custom configuration
var config = initConfig()

# Modify configuration (exact field names depend on Config type definition)
config.langFilter = @["go", "ts"]  # Only generate Go and TypeScript
config.outputRootDirs = @["./generated"]
config.skipImport = true  # Don't process imported files

# Use custom config with fromFiles()
let outputFiles = fromFiles(@["schema.wings"], config)
```

### Processing with Multiple Output Directories

```nim
import wingspkg/core
import wingspkg/util/config
import os

proc generateToMultipleDirs(wingsFiles: seq[string], config: Config): void =
  let outputFiles = fromFiles(wingsFiles, config)
  
  # The original code writes to each output directory
  for outputDir in config.outputRootDirs:
    let originalDir = getCurrentDir()
    
    if outputDir.len() > 0:
      setCurrentDir(outputDir)
    
    # Write files in this directory
    for filename in outputFiles.keys:
      for filetype in outputFiles[filename].keys:
        let content = outputFiles[filename][filetype]
        createDir(parentDir(filename))
        writeFile(filename, content)
        echo "Generated: ", outputDir, "/", filename
    
    setCurrentDir(originalDir)
```

## Build Script Integration

```nim
import wingspkg/core
import wingspkg/util/config
import os, times

proc buildWithWings(): void =
  let config = if fileExists("wings.json"): 
                 parse("wings.json") 
               else: 
                 initConfig()
  
  let wingsFiles = @["schemas/api.wings"]
  
  # Check if regeneration is needed
  var needsRegen = false
  for wingsFile in wingsFiles:
    if not fileExists("src/generated"):
      needsRegen = true
      break
    
    let wingsTime = getLastModificationTime(wingsFile)
    for genFile in walkDirRec("src/generated"):
      if getLastModificationTime(genFile) < wingsTime:
        needsRegen = true
        break
  
  if needsRegen:
    echo "Regenerating Wings files..."
    let outputFiles = fromFiles(wingsFiles, config)
    
    # Process output files as needed
    for filename in outputFiles.keys:
      for filetype in outputFiles[filename].keys:
        let content = outputFiles[filename][filetype]
        # Write to appropriate location
  
  # Continue with build process...

when isMainModule:
  buildWithWings()
```

## Return Value Structure

The `fromFiles()` function returns a nested table structure:

```nim
# Table[string, Table[string, string]]
# Where:
# - Outer key: base filename/path
# - Inner key: file extension/type (go, ts, py, etc.)
# - Inner value: generated source code content

let results = fromFiles(@["user.wings"], config)
# results["user"]["go"] contains the Go source code
# results["user"]["ts"] contains the TypeScript source code
# etc.
```

## Error Handling

Wings uses the `stones/log` module for logging. Error handling should check for:

- File existence before processing
- Configuration parsing errors
- Template processing failures

```nim
import wingspkg/core
import wingspkg/util/config
import os

try:
  if not fileExists("schema.wings"):
    echo "Wings file not found"
    return
  
  let config = if fileExists("wings.json"):
                 parse("wings.json")
               else:
                 initConfig()
  
  let results = fromFiles(@["schema.wings"], config)
  # Process results...
  
except:
  echo "Error processing Wings files: ", getCurrentExceptionMsg()
```

## Dependencies

When using Wings as a library, you'll need these dependencies:

- `stones` - For logging and utilities
- Standard library modules: `times`, `os`, `strutils`, `sets`, `tables`
