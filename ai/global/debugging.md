# Debugging Guidelines

## Flutter

Use:

- Flutter DevTools:
  - Widget rebuild tracking.
  - Memory and CPU profiling.
- Logging:
  - `debugPrint('AuthViewModel: error logging in: $e');`
- Riverpod:
  - Provider observers to trace state changes.

Performance debugging:

- Use `const` constructors where possible.
- Minimize unnecessary rebuilds.
- Memoize expensive operations.
- Avoid heavy work on the main isolate in build methods.

---

## Node.js

Use:

- Firebase Emulator Suite for:
  - Firestore
  - Auth
  - Functions
- VSCode / IDE breakpoints against the local dev server.
- Structured logging (e.g. `pino`) when relevant.

Common pitfalls:

- Missing `await` leading to unhandled promises.
- Firestore queries without `limit()` when appropriate.
- Incorrect Firebase Admin initialization (multiple apps, no project ID).

---

## Firestore Rules Debugging

- Use emulator or Firebase Rules playground.
- Simulate read/write operations with the same auth context as the app.
- Ensure rules match intended access patterns (owner-based, role-based, etc.).