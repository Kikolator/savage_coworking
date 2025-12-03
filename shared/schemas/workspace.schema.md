# Workspace Schema

Defines the canonical structure for workspaces/buildings where desks are located.

## Core Model

```typescript
interface Workspace {
  id: string;              // Firestore document ID
  name: string;            // Workspace name (e.g., "Main Office", "Building A")
  isActive: boolean;       // Whether workspace is active and available
  createdAt: Timestamp;   // Creation timestamp
  updatedAt: Timestamp;   // Last update timestamp
}
```

## Firestore Collection

- **Collection**: `workspaces`
- **Document ID**: Auto-generated or custom identifier

## Field Descriptions

- `id`: Unique workspace identifier (Firestore document ID)
- `name`: Human-readable workspace name (required, 1-100 characters)
- `isActive`: Boolean flag indicating if the workspace is active (default: true)
- `createdAt`: Timestamp when the workspace was created
- `updatedAt`: Timestamp when the workspace document was last updated

## Validation Rules

- `name`: Must be between 1 and 100 characters, cannot be empty
- `isActive`: Boolean value (true or false)
- Only active workspaces (`isActive: true`) should be shown in selection dropdowns
- Workspace names should be unique (enforced by application logic)

## Access Control

- **Read**: Authenticated users can read all workspaces
- **Write**: Only admins can create, update, or delete workspaces
- See Firestore rules: `match /workspaces/{document}`

## Usage Notes

- Workspaces are referenced by `workspaceId` in `desks` and `deskBookings` collections
- Before deleting a workspace, check for associated desks and bookings
- Inactive workspaces (`isActive: false`) are hidden from selection but remain in the database for historical reference

