# Shared Project Rules

This document describes how shared resources and schemas are organized.

## Folder structure

Typical shared structure:

```text
/shared
  SHARED.md                 # overview
  /database
    DB.md                   # DB concepts / high-level docs
  /rules
    ...                     # Firestore and Storage rules, indexes
  /schemas
    ...                     # model schemas, single source of truth
  /mocks
    ...                     # mock data
  /apis
    APIS.md                 # API doc overview
```

## Schemas
- /shared/schemas/* define the shape of core models.
- Flutter and Node models MUST match these schemas.
- When adding/changing fields:
	- Update schema first.
	- Then update backend + frontend.

## Firestore & Storage rules
- Rules must enforce:
	- least-privilege access
	- ownership or role-based access where required
- Any new collection or critical field:
	- must be reflected in rules under /shared/rules.

## Security principles
- Validate all user input (front + back).
- Never trust anything from the client.
- Ensure rules explicitly define who can:
	- read which documents
	- write which documents
	- Use request.auth and document fields to enforce ownership when needed.

## APIs
- /shared/apis/APIS.md documents:
	- endpoints
	- request and response shapes
	- authentication/authorization requirements.

This shared layer is the contract connecting Flutter, Node, and data.