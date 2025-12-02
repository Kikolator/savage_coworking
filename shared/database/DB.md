# DB Concepts

## System Collections

### `changeLogs`

- **Purpose**: Immutable audit trail that captures every Firestore document mutation (create, update, delete).
- **Writer**: Cloud Functions service account via the change-log trigger.
- **Reader**: Admins only (inherits the global admin-only default in Firestore rules).
- **Schema**: See `shared/schemas/change_log.schema.md`.
- **Notes**:
  - Stores full `before`/`after` snapshots along with changed field names.
  - Automatically skips logging for the `changeLogs` collection itself to avoid recursion.
  - Consider periodic exports / retention policies for long-term storage.