# Development Setup

Guide for contributors who want to work on the Wings project itself.

## Prerequisites

### Required Dependencies
- **Nim**: Programming language and compiler
- **Nimble**: Nim package manager (usually comes with Nim)
- **Git**: For version control

### Cross-Compilation Dependencies
Some additional packages might be needed for cross-compilation:
- `gcc-multilib`
- `gcc-arm-linux-gnueabihf` 
- `mingw-w64`
- `libevent-dev`

**Note**: The exact installation varies by platform.

## Repository Setup

### Clone and Initialize
```bash
git clone https://github.com/binhonglee/wings.git
cd wings/
```

### Nim Environment Setup
```bash
# Install Nim dependencies
nimble install -d

# Verify setup
nim --version
nimble --version
```

## Development Scripts

### Documentation Development
```bash
nim src/main/scripts/docs.nims
```
- Runs MkDocs development server for real-time feedback
- Watches changes in the `docs/` folder  
- Requires `mkdocs` to be installed

### Release Build
```bash
# Build for current environment
nim src/main/scripts/release.nims

# Cross-compile for other environments  
nim src/main/scripts/release.nims --all
```

### Language Template Generation
```bash
nim c -r -d:ssl src/main/staticlang/main.nim
```
This generates/updates the `lang` folder based on files in `src/main/wingspkg/lang` and `examples/input/templates`.

### Testing
```bash
./scripts/test.sh
```
**Important**: This isn't a proper test for everything. Recommend reading the script, < 20 lines, before running it.

## Development Workflow

### Making Changes

1. **Basic Development Cycle**
   ```bash
   # Make changes to source code
   
   # Test basic compilation
   nim c src/main/wings.nim
   
   # Test with example files
   ./wings examples/input/student.wings
   
   # Run the basic test suite
   ./scripts/test.sh
   ```

2. **Working with Templates**
   ```bash
   # After modifying template files in examples/input/templates/
   nim c -r -d:ssl src/main/staticlang/main.nim
   
   # Test the updated templates
   ./wings examples/input/student.wings
   ```

3. **Documentation Changes**
   ```bash
   # Start documentation server
   nim src/main/scripts/docs.nims
   
   # Edit documentation in docs/ folder
   # Changes should auto-reload
   ```

## Repository Structure

```
wings/
├── src/main/
│   ├── wings.nim              # Main entry point
│   ├── wingspkg/              # Core package code
│   └── scripts/               # Development scripts
├── examples/
│   ├── input/                 # Example Wings files
│   └── output/               # Generated example outputs
├── docs/                     # Documentation source
└── scripts/                  # Build and test scripts
```

## Testing Your Changes

### Basic Testing
```bash
# Test with provided examples
find examples/input -name "*.wings" -exec ./wings {} \;
```

### Cross-Platform Testing

## Adding New Language Support

1. **Create Template Configuration**
   - Add your language configuration to `examples/input/templates/`
   - Follow the templating system documentation on wings.sh

2. **Test Your Template**
   ```bash
   wings -c:examples/input/templates/your_lang.json examples/input/student.wings
   ```

3. **Add to Built-in Support** (Optional)
   ```bash
   # After adding to src/main/wingspkg/lang/
   nim c -r -d:ssl src/main/staticlang/main.nim
   ```

## Contributing Guidelines

### Before Submitting
- Ensure your changes compile: `nim c src/main/wings.nim`
- Run the test suite: `./scripts/test.sh`
- Test with example files to ensure nothing breaks
- Check that documentation builds if you made doc changes

### Useful Resources
- Example Wings files in `examples/input/` show expected syntax and features
- Template examples in `examples/input/templates/` demonstrate language support
