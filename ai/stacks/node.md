# Node.js Backend Stack Rules

These rules apply to backend TypeScript code (e.g. `src/`, `functions/src/`).

## Runtimes

- Firebase Functions: Node 20.
- Standalone backend (Cloud Run / VM): Node 22 LTS.

## Architecture

- Use a layered structure:

```text
HTTP / Event
  ↓
Controller (I/O)
  ↓
Service (Business logic)
  ↓
Repository (Data access)
  ↓
Firebase Admin / DB / External APIs
```

- Controllers:
    - Parse and validate input.
	- Call services.
	- Map service results/errors to HTTP responses.
- Services:
	- Contain business rules.
	- Call repositories.
	- Do not know about Express or HTTP.
- Repositories:
	- Interact with Firestore/Storage/Auth/other DBs.
	- No business rules.

See examples/functions/src/modules/users/* and examples/functions/src/api/routes/userRoutes.ts for a reference.

## Firebase Admin Initialization

- Single initialization file, e.g. src/config/firebaseAdmin.ts.
- Use idempotent initializeApp.
- Export helper functions like db() and auth() instead of raw singletons.

## Config & environments
- Centralized env parsing in src/config/env.ts.
- Use .firebaserc for project aliases (dev/staging/prod).
- Configuration should be driven by environment variables, not hardcoded.

## Cloud Functions specifics
- Keep function handlers small and focused.
- No heavy imports inside handlers; load shared modules at the top level.
- Use runWith to set memory and timeout where needed.
- Always finish async work before returning responses.

## Testing
- Unit tests:
- Services with repositories mocked.
- Integration tests:
- Use Firebase Emulators for realistic behavior.
- Keep test files close to their modules (__tests__ folder).

## Logging
- Centralize logging in a logger module.
- Prefer structured logs for production.
- Do not log secrets or sensitive data.