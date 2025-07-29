# Troubleshooting Guide

Common issues and solutions when using Wings.

## Configuration Issues

### Missing Configuration File
**Problem**: Wings can't find the configuration file
**Solutions**:
- Ensure `wings.json` exists in the current directory
- Use `-c:path/to/config.json` to specify the config file location
- Check that the config file has the correct JSON syntax

### Invalid JSON Configuration
**Problem**: Configuration file has syntax errors
**Solutions**:
- Validate your JSON using an online JSON validator
- Check for common issues:
  - Missing commas between array/object elements
  - Trailing commas (not allowed in JSON)
  - Unclosed brackets or quotes
  - Incorrect escape sequences

## Wings File Issues

### Import Errors
**Problem**: Wings can't find imported files
**Solutions**:
- Verify the import path is correct relative to the current file
- Ensure the imported `.wings` file exists
- Check file permissions - Wings needs read access to imported files

### Syntax Errors
**Problem**: Wings file has invalid syntax
**Solutions**:
- Check struct and enum definitions follow the correct format
- Verify field definitions have the required components (name, type)
- Ensure proper use of comments (starting with `//`)

## Generation Issues

### Missing Output Directories
**Problem**: Generated files aren't created
**Solutions**:
- Check that output directories specified in config exist
- Verify Wings has write permissions to output directories
- Ensure `outputRootDirs` in config points to valid paths

### Template Errors
**Problem**: Custom templates cause generation failures
**Solutions**:
- Verify template file paths in `langConfigs` are correct
- Check that template files exist and are readable
- Validate template syntax matches Wings expectations

## Getting Help

### Self-Diagnosis Steps
1. Check that your Wings file syntax is valid
2. Verify your configuration file is valid JSON
3. Ensure all imported files exist and are accessible
4. Test with a minimal example to isolate issues

### Community Support
- Check existing issues on [GitHub](https://github.com/binhonglee/wings/issues)
- Create a new issue with:
  - Your Wings file content
  - Your configuration file
  - The complete error message
  - Your operating system and Wings installation method
