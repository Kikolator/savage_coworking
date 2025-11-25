# Naming Conventions

These rules MUST be followed in all Flutter, Node.js, and shared projects.

## General
- Use **clear, descriptive names**.
- Avoid abbreviations unless industry-standard (e.g., URL, ID, API).

## Dart (Flutter)
- Files: `snake_case.dart`
- Folders: `snake_case`
- Classes: `PascalCase`
- Enums: `PascalCase`
- Methods: `camelCase`
- Variables: `camelCase`
- Constants: `kCamelCase`
- Private members: `_camelCase`
- Providers: `<Feature>Provider`

## TypeScript (Node)
- Files: `kebab-case.ts`
- Classes: `PascalCase`
- Functions: `camelCase`
- Variables: `camelCase`
- Interfaces/Types: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- Repositories: `<Feature>Repository`
- Services: `<Feature>Service`
- Controllers: `<Feature>Controller`

## Schemas (shared)
- Schema names: `PascalCase`
- Fields: `camelCase`
- Collection names: plural (`users`, `properties`)