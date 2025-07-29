# CLI Usage

Basic command-line usage for Wings.

## Basic Usage

```bash
wings [input-file]
```

## Configuration File

Wings uses a configuration file to specify generation options. By default, it looks for `wings.json` in the current directory.

To specify a custom configuration file:
```bash
wings -c:custom-config.json input.wings
```

## Examples

### Basic Generation
```bash
# Generate from student.wings using default wings.json
wings student.wings

# Generate using custom configuration
wings -c:production.json models/user.wings
```

### Processing Multiple Files
```bash
# Process multiple Wings files
for file in models/*.wings; do
    wings "$file"
done
```

## File Organization

Wings generates files based on the paths specified in your configuration file:
- `go-filepath` - Output directory for Go files
- `kt-filepath` - Output directory for Kotlin files  
- `py-filepath` - Output directory for Python files
- `ts-filepath` - Output directory for TypeScript files

## Error Handling

If Wings encounters an error, it will display the error message and exit. Common issues include:
- Missing configuration file
- Invalid Wings syntax
- Missing imported files
- Template processing errors

For more detailed troubleshooting, see the [configuration documentation](https://wings.sh/config/).
