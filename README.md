# Wings - Cross-Language Code Generator

Wings is a simple, customizable cross-language code generator that helps maintain consistency across your multi-language tech stack. Define your data structures once in `.wings` files, and generate corresponding code in multiple programming languages automatically.

[![GitHub Action Status](https://github.com/binhonglee/wings/workflows/CI/badge.svg)](https://github.com/binhonglee/wings/actions?query=workflow%3ACI+branch%3Adevel)
[![CircleCI](https://circleci.com/gh/binhonglee/wings/tree/devel.svg?style=shield)](https://app.circleci.com/pipelines/github/binhonglee/wings?branch=devel)
[![codecov](https://codecov.io/gh/binhonglee/wings/branch/devel/graph/badge.svg)](https://codecov.io/gh/binhonglee/wings)
[![CodeFactor](https://www.codefactor.io/repository/github/binhonglee/wings/badge)](https://www.codefactor.io/repository/github/binhonglee/wings)

[![Gitter](https://img.shields.io/gitter/room/binhonglee/wings.svg)](https://gitter.im/wings-sh/community)
[![Website](https://img.shields.io/website?url=https%3A%2F%2Fwings.sh)](https://wings.sh)

![GitHub all releases](https://img.shields.io/github/downloads/binhonglee/wings/total?label=GitHub%20release%20downloads)
![Visual Studio Marketplace Downloads](https://img.shields.io/visual-studio-marketplace/d/binhonglee.vscode-wings)
![npm](https://img.shields.io/npm/dt/wings-ts-util?label=npm%20downloads)

## 🚀 Quick Start

### Installation

**Script Installation (Recommended)**
```bash
curl -s https://wings.sh/install.sh | sh
```

**Using Nimble**
```bash
nimble install wings
```

**Manual Installation**
1. Download the appropriate binary from [GitHub Releases](https://github.com/binhonglee/wings/releases)
2. Add to your PATH and rename to `wings`
3. Make executable: `chmod +x wings`

**Build from Source**
```bash
git clone https://github.com/binhonglee/wings.git
cd wings
nim c -r src/main/wings.nim
```

### Your First Wings File

Create a file named `person.wings`:

```wings
# Define output paths for different languages
go-filepath examples/go
ts-filepath examples/ts
py-filepath examples/py

# Define a simple struct
struct Person {
    id int -1
    name str ""
    email str ""
    age int 0
    is_active bool true
}
```

Generate code:
```bash
wings person.wings
```

This creates corresponding struct/class files in the configured languages with proper type definitions and JSON serialization.

## Requirements

- [Nim](https://nim-lang.org/)
- [MkDocs](https://www.mkdocs.org/) (Documentation)

\*_Note: There are also other packages needed for deployment due to cross compilation (like `gcc-multilib`, `gcc-arm-linux-gnueabihf`, `mingw-w64`, `libevent-dev` etc...)._

## Development Tools (scripts)

- Run mkdocs development server for realtime feedback on changes made `docs` folder _(requires `mkdocs`)_
  - `nim src/main/scripts/docs.nims`
- Build release binaries for distribution
  - `nim src/main/scripts/release.nims` (This will only build the version compatible to your environment by default. You can do `nim src/main/scripts/release.nims --all` to try cross-compiling for other environments.)
- Generate / Update the `lang` folder [(`src/main/wingspkg/lang`)](https://github.com/binhonglee/wings/tree/devel/src/main/wingspkg/lang) based on the files in the [`examples/input/templates`](https://github.com/binhonglee/wings/tree/devel/examples/input/templates) folder
  - `nim c -r -d:ssl src/main/staticlang/main.nim`
- Run tests
  - `./scripts/test.sh` (This isn't a proper test for everything. Recommend reading the script, < 20 lines, before running it.)

For some more comprehensive set up / testing procedure, [`.github/workflows/main.yml`](https://github.com/binhonglee/wings/blob/devel/.github/workflows/main.yml) file might be a good place to start looking into.

## 📋 Table of Contents

1. [Core Concepts](#core-concepts)
2. [Language Configuration](#language-configuration)
3. [Struct Definition](#struct-definition)
4. [Enum Definition](#enum-definition)
5. [Configuration File](#configuration-file)
6. [Examples](#examples)
7. [Contributing](#contributing)

## 🎯 Core Concepts

### What Wings Does

Wings solves the problem of maintaining identical data structures across multiple programming languages. Instead of manually keeping structs, classes, and enums synchronized across your different services, you define them once and generate consistent code.

### Key Benefits

- **Single Source of Truth**: Define structures once, use everywhere
- **Type Safety**: Generates proper type definitions for each language
- **Consistency**: Ensures field names, types, and defaults are identical
- **Simplicity**: Straightforward syntax and minimal configuration

## 🔧 Language Configuration

### Output Path Configuration

Define where generated files should be placed:

```wings
# Single language
go-filepath src/models

# Multiple languages
go-filepath backend/models
ts-filepath frontend/src/types
py-filepath services/shared/models
```

### Import Configuration

Control how imports are handled:

```wings
# Import external wings files
import shared/common.wings
import validation/rules.wings
```

## 🏗️ Struct Definition

### Basic Syntax

```wings
struct StructName {
    field_name field_type default_value
    another_field another_type
}
```

### Field Types

#### Primitive Types
```wings
struct DataTypes {
    # Integers
    user_id int 0
    count int 0
    
    # Strings
    name str ""
    description str "No description"
    
    # Booleans
    is_active bool true
    is_deleted bool false
    
    # Floating point
    price float 0.0
}
```

#### Complex Types
```wings
struct ComplexTypes {
    # Arrays/Lists
    tags []str
    scores []int
    
    # Maps/Dictionaries (if supported)
    metadata Map<str,str>
    counts Map<str,int>
    
    # Custom types (from other wings files)
    address Address
    permissions []Permission
}
```

#### Optional Fields and Defaults

```wings
struct UserProfile {
    # Required fields (no default)
    id int
    email str
    
    # Optional with defaults
    name str "Anonymous"
    age int 0
    bio str ""
    
    # Optional arrays
    tags []str
}
```

## 🔢 Enum Definition

### Basic Enum

```wings
enum Status {
    Active
    Inactive
    Pending
    Suspended
}
```

### Enum with Comments

```wings
# User account status
enum UserStatus {
    # Account is active and user can log in
    Active
    
    # Account is temporarily disabled
    Inactive
    
    # Account is waiting for email verification
    Pending
    
    # Account is suspended due to policy violation
    Suspended
}
```

### Using Enums in Structs

```wings
import enums/status.wings

struct User {
    id int
    name str
    status Status Status.Active
}
```

## ⚙️ Configuration File

Create a `wings.json` configuration file for advanced settings:

```json
{
  "header": [
    "This is a generated file",
    "Do not edit manually"
  ],
  "acronyms": ["ID", "URL", "API", "HTTP", "JSON"],
  "langFilter": ["go", "ts", "py"],
  "skipImport": false,
  "logging": 2
}
```

### Configuration Options

| Option | Type | Description |
|--------|------|-------------|
| `header` | `[]string` | Header comments for generated files |
| `acronyms` | `[]string` | Words to keep as ALL_CAPS in naming |
| `langFilter` | `[]string` | Only generate these languages |
| `skipImport` | `bool` | Skip processing imported files |
| `logging` | `int` | Logging verbosity (0-4) |

## 🎨 Best Practices

### File Organization

```
project/
├── wings/
│   ├── shared/
│   │   ├── common.wings
│   │   └── enums.wings
│   ├── models/
│   │   ├── user.wings
│   │   └── product.wings
├── wings.json
└── generated/
    ├── go/
    ├── ts/
    └── py/
```

### Naming Conventions

- Use `snake_case` for field names in wings files
- Wings will automatically convert to language-appropriate naming
- Use descriptive names for structs and enums

### Default Values

- Always provide sensible defaults for optional fields
- Use empty strings `""` for optional text fields
- Use `false` for boolean flags that default to off
- Use `0` for numeric counters

### Comments and Documentation

```wings
# This comment describes the entire struct
struct User {
    # User's unique identifier
    id int
    
    # Full name of the user
    name str ""
    
    # Email address for authentication
    email str
}
```

## 📚 Examples

### Simple API Model

```wings
# wings/api/user.wings
struct User {
    id int
    name str
    email str
    is_active bool true
    created_at str
}

enum UserRole {
    Admin
    User
    Guest
}

struct UserWithRole {
    id int
    name str
    email str
    role UserRole UserRole.User
}
```

### E-commerce Product

```wings
# wings/ecommerce/product.wings
import shared/common.wings

struct Product {
    id int
    name str
    description str ""
    price float
    is_available bool true
    tags []str
}

enum ProductCategory {
    Electronics
    Clothing
    Books
    Home
}
```

## 🤝 Contributing

### Development Setup

```bash
# Clone the repository
git clone https://github.com/binhonglee/wings.git
cd wings

# Build from source (requires Nim)
nim c -r src/main/wings.nim

# Run tests
./scripts/test.sh
```

### Reporting Issues

- Use GitHub Issues for bugs and feature requests
- Include wings file examples and configuration
- Provide generated output when relevant
- Specify operating system and wings version

## 📖 Further Reading

- [Official Wings Website](https://wings.sh)
- [Configuration Reference](https://wings.sh/config/)
- [Dev Setup Guide](https://wings.sh/devSetup/)
- [Template Documentation](https://wings.sh/template/)
