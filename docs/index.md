# Wings - Cross-Language Code Generator

Wings is a simple, customizable cross-language code generator that helps maintain consistency across your multi-language tech stack. Define your data structures once in `.wings` files, and generate corresponding code in multiple programming languages automatically.

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

- [GitHub Repository](https://github.com/binhonglee/wings)
- [Configuration Reference](https://wings.sh/config/)
- [Template Documentation](https://wings.sh/template/)

---

*Wings is a simple cross-language struct and enum file generator. For the latest updates and contributions, visit our [GitHub repository](https://github.com/binhonglee/wings).*
