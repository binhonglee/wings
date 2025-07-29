# Integration Guide

How to integrate Wings into your development workflow and build systems.

## Build System Integration

Wings can be integrated into various build systems to automatically generate code when schemas change.

### Make
Add Wings generation to your Makefile:

```makefile
# Makefile
WINGS_FILES := $(wildcard schemas/*.wings)

.PHONY: generate clean

generate:
	wings schemas/api.wings

clean:
	rm -rf src/generated/

build: generate
	# Your build commands here
	go build ./...
```

### npm Scripts (Node.js/TypeScript)
```json
{
  "scripts": {
    "generate": "wings schemas/api.wings",
    "prebuild": "npm run generate",
    "build": "tsc"
  }
}
```

### Python setuptools
```python
# In your build script
import subprocess
import os

def generate_wings():
    subprocess.run(['wings', 'schemas/models.wings'], check=True)

# Call before your main build process
generate_wings()
```

## Multi-Repository Workflows

### Shared Schema Repository
For teams with separate backend and frontend repositories:

```
shared-schemas/
├── wings.json
├── models/
│   ├── user.wings
│   └── api.wings

backend/
├── wings.json          # langFilter: ["go"]
└── shared-schemas/     # git submodule or copy

frontend/
├── wings.json          # langFilter: ["ts"] 
└── shared-schemas/     # git submodule or copy
```

Backend `wings.json`:
```json
{
  "langFilter": ["go"],
  "outputRootDirs": ["./internal/models"]
}
```

Frontend `wings.json`:
```json
{
  "langFilter": ["ts"],
  "outputRootDirs": ["./src/types"]
}
```

## Development Workflow

### File Organization
Recommended project structure:
```
project/
├── wings.json
├── schemas/
│   ├── user.wings
│   └── api.wings
├── src/
│   └── generated/     # Generated files
└── README.md
```

### Version Control Considerations

**Option 1: Commit Generated Files**
- Add generated files to version control
- Ensures all developers have consistent generated code
- Good for teams where not everyone has Wings installed

**Option 2: Generate During Build**
- Add generated files to `.gitignore`
- Generate code as part of build process
- Requires all developers to have Wings installed

```gitignore
# Option 2: Don't commit generated files
src/generated/
*.generated.*
```

### Pre-commit Workflow
Consider regenerating files when schemas change:

```bash
#!/bin/bash
# Simple pre-commit script
if git diff --cached --name-only | grep -q '\.wings$'; then
    echo "Wings files changed, regenerating..."
    wings schemas/api.wings
    git add src/generated/
fi
```

## IDE Integration

### VS Code
Install the Wings extension for syntax highlighting:
```bash
code --install-extension binhonglee.vscode-wings
```

### File Watching
Automatically regenerate when schemas change:

```bash
# Using inotify-tools (Linux)
while inotifywait -e modify schemas/*.wings; do
    wings schemas/api.wings
done

# Using fswatch (macOS)
fswatch schemas/*.wings | xargs -n1 -I{} wings schemas/api.wings
```

## Performance Considerations

### Large Projects
- Use `langFilter` to generate only needed languages for specific contexts
- Set `skipImport: true` in config if you don't need imported file generation
- Consider splitting large schema files into smaller, focused files

### Incremental Builds
For better performance in large projects:

```bash
# Only regenerate if Wings files are newer than generated files
find schemas -name "*.wings" -newer src/generated/last_build && {
    wings schemas/api.wings
    touch src/generated/last_build
}
```
