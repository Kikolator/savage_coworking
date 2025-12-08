# Workspace Schema

Defines the canonical structure for workspaces/buildings where desks are located.

## Core Model

```typescript
interface Workspace {
  id: string;              // Firestore document ID
  name: string;            // Workspace name (e.g., "Main Office", "Building A")
  location: string;        // Physical location (e.g., "123 Main St, New York")
  country: string;         // Country (e.g., "United States")
  companyLogoUrl?: string; // Optional Firebase Storage URL for company logo
  isActive: boolean;       // Whether workspace is active and available
  businessHoursStart?: string; // Opening time in HH:mm format (e.g., "09:00")
  businessHoursEnd?: string;   // Closing time in HH:mm format (e.g., "17:00")
  businessDaysOfWeek?: number[]; // Array of day numbers (0-6) when workspace is open (0=Sunday, 6=Saturday)
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
- `location`: Physical address/location of the workspace (required, 1-200 characters)
- `country`: Country where the workspace is located (required, 1-100 characters)
- `companyLogoUrl`: Optional URL to company logo stored in Firebase Storage
- `isActive`: Boolean flag indicating if the workspace is active (default: true)
- `businessHoursStart`: Optional opening time in HH:mm format (e.g., "09:00"). Used as default for subscription plans with business hours access.
- `businessHoursEnd`: Optional closing time in HH:mm format (e.g., "17:00"). Must be later than `businessHoursStart` if both are provided.
- `businessDaysOfWeek`: Optional array of integers (0-6) representing days when workspace is open. 0=Sunday, 1=Monday, ..., 6=Saturday. Used as default for subscription plans with business hours access. If empty or not provided, all days are considered open.
- `createdAt`: Timestamp when the workspace was created
- `updatedAt`: Timestamp when the workspace document was last updated

## Validation Rules

- `name`: Must be between 1 and 100 characters, cannot be empty
- `location`: Must be between 1 and 200 characters, cannot be empty
- `country`: Must be between 1 and 100 characters, cannot be empty
- `companyLogoUrl`: Optional, must be a valid URL if provided
- `isActive`: Boolean value (true or false)
- `businessHoursStart`: Optional, must be in HH:mm format (24-hour) if provided (e.g., "09:00", "17:30")
- `businessHoursEnd`: Optional, must be in HH:mm format (24-hour) if provided. If both `businessHoursStart` and `businessHoursEnd` are provided, `businessHoursEnd` must be later than `businessHoursStart`
- `businessDaysOfWeek`: Optional array of integers. Each value must be between 0 and 6 (inclusive). Values should be unique. If provided, at least one day must be included.
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
- `businessHoursStart`, `businessHoursEnd`, and `businessDaysOfWeek` are used as default values when creating subscription plans with business hours access type. If a workspace has these fields set, they will be pre-populated in the admin plan creation form.
- When `businessDaysOfWeek` is empty or not provided, it means the workspace is open all days of the week (for business hours purposes).

