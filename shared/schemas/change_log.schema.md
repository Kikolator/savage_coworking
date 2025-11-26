# Change Log Schema

This document defines the structure of the Firestore `changeLogs` collection used to capture every document mutation across the workspace database.

## Firestore Collection

- **Collection**: `changeLogs`
- **Document ID**: Auto-generated
- **Managed by**: Cloud Functions only (admins may read, but writes are system-only)

## Data Model

```typescript
type ChangeLogOperation = "created" | "updated" | "deleted";

interface ChangeLogEntry {
  documentPath: string;        // Full Firestore document path that changed
  collection: string;          // Top-level collection name
  eventId: string;             // Unique Cloud Event identifier
  operation: ChangeLogOperation;
  changedFields: string[];     // Sorted list of field names that changed
  beforeData: Record<string, unknown> | null; // Previous snapshot (null for creates)
  afterData: Record<string, unknown> | null;  // New snapshot (null for deletes)
  authType: "service_account" | "api_key" | "system" | "unauthenticated" | "unknown";
  authId: string | null;       // Principal identifier if available
  loggedAt: Timestamp;         // When the change was logged
}
```

## Field Notes

- `documentPath` allows correlating the change back to any document, including nested sub-collections.
- `collection` is derived from the first segment of `documentPath` to enable fast querying for a single feature.
- `changedFields` is always sorted to keep deterministic diffs when nothing changed.
- `beforeData` / `afterData` store the full document snapshot for auditing purposes. Large binary/blob fields should be avoided in user collections when possible.
- `authType`/`authId` come from the Firestore trigger context and help explain which actor initiated the change.
- `loggedAt` uses a server-side timestamp so that logs remain trustworthy even if the original document clock skewed.

## Access Control

- Writes: Cloud Functions service account only.
- Reads: Admin users (see Firestore security rules).

## Retention

- This collection may grow quickly. Consider periodical exports or lifecycle rules if storage costs become material.
