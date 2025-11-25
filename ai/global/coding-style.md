# Global Coding Style

These rules apply to ALL languages and stacks in this repository.

## Readability over cleverness

- Prefer clear, explicit code over “smart” or compressed code.
- Comments should explain *why*, not *what*, whenever needed.
- If future-you would struggle to understand it, rewrite it.

## Functions and methods

- Short and focused.
- Single responsibility whenever possible.
- Avoid deeply nested conditionals.
- Extract helper functions when logic becomes complex.

## Project organization

- Shared folder(s) hold:
  - data models / schemas
  - Firestore & Storage rules
  - API docs
  - shared README files
- Flutter project: frontend UI and app logic.
- Node project: backend API / functions / integrations.

## Models and data

- Models must follow the shared schemas.
- Do not invent fields ad-hoc; update schemas first.
- Prefer typed models everywhere (Dart/TS).