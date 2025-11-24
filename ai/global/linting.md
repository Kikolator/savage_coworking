# Linting & Formatting

- Use a consistent linter and formatter per stack:
  - Dart: `dart format` / `flutter format` + `analysis_options.yaml`
  - Node: ESLint + Prettier (or similar)
- Linting should run in CI as a gate.
- Before committing:
  - Run formatters.
  - Fix linter errors, not just warnings.

The goal is to minimize style discussions and keep diffs clean.