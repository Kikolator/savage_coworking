# Desk Schema

Defines the canonical structure for hot desks that can be booked by users.

## Core Model

```typescript
interface Desk {
  id: string;              // Firestore document ID
  name: string;            // Desk identifier/name (e.g., "Desk 21A", "Desk-101")
  workspaceId: string;     // Reference to workspace/building
  isActive: boolean;       // Whether desk is available for booking
  createdAt: Timestamp;   // Creation timestamp
  updatedAt: Timestamp;   // Last update timestamp
}
```

## Firestore Collection

- **Collection**: `desks`
- **Document ID**: Auto-generated or custom identifier

## Field Descriptions

- `id`: Unique desk identifier (Firestore document ID)
- `name`: Human-readable desk name/identifier (required, 1-100 characters)
- `workspaceId`: Workspace/building identifier where the desk is located (required)
- `isActive`: Boolean flag indicating if the desk is available for booking (default: true)
- `createdAt`: Timestamp when the desk was created
- `updatedAt`: Timestamp when the desk document was last updated

## Validation Rules

- `name`: Must be between 1 and 100 characters, cannot be empty
- `workspaceId`: Must be a non-empty string
- `isActive`: Boolean value (true or false)
- Only active desks (`isActive: true`) should be shown in booking selection
- Desk names should be unique within a workspace (enforced by application logic)

## Access Control

- **Read**: Authenticated users can read all desks
- **Write**: Only admins can create, update, or delete desks
- See Firestore rules: `match /desks/{document}`

## Usage Notes

- Desks are referenced by `deskId` in `deskBookings` collection
- Before deleting a desk, check for active bookings
- Inactive desks (`isActive: false`) are hidden from booking selection but remain in the database for historical reference

