# Testing Guidelines

Not everything needs tests, but the following MUST be tested:

- Core business logic.
- Utilities and services.
- Validation logic.
- Critical API endpoints.

UI tests are optional but recommended for complex flows.

## Flutter

- Unit test ViewModels and services where they contain logic.
- Avoid over-testing widgets; focus on behavior, not implementation details.

## Node.js

- Use Jest/Vitest for unit tests.
- Services should be tested with repositories mocked.
- Integration tests should use Firebase Emulators (Firestore/Auth/Functions).

## General principles

- Tests should be fast, isolated, and deterministic.
- Test *behavior* and *contracts*, not private implementation details.