# Hot Desk Booking Schema

Defines the canonical structure for reserving shared desks across all clients and services.

## Core Model

```typescript
type HotDeskBookingStatus =
  | 'pending'
  | 'confirmed'
  | 'checkedIn'
  | 'completed'
  | 'cancelled'
  | 'noShow';

interface HotDeskBooking {
  id: string;                  // Firestore document ID
  userId: string;              // Reference to users/<uid>
  workspaceId: string;         // Reference to workspaces/<id>
  deskId: string;              // Reference to desks/<id>
  startAt: Timestamp;          // Reservation start timestamp (UTC)
  endAt: Timestamp;            // Reservation end timestamp (UTC)
  status: HotDeskBookingStatus;// Current lifecycle status
  source: 'app' | 'admin' | 'system'; // Origin of the booking
  purpose?: string;            // Optional short description of usage
  checkInAt?: Timestamp;       // When the user checked in
  checkOutAt?: Timestamp;      // When the user checked out
  cancelledAt?: Timestamp;     // When the booking was cancelled
  cancelledBy?: string;        // User or system identifier that cancelled
  cancellationReason?: string; // Optional cancellation note
  repeatSeriesId?: string;     // Shared ID for recurring bookings
  createdAt: Timestamp;
  updatedAt: Timestamp;
}
```

## Firestore Collection

- **Collection**: `deskBookings`
- **Document ID**: `bookingId` (auto-generated or deterministic UUID)

## Field Descriptions

- `id`: Unique booking identifier.
- `userId`: Owner of the reservation, must match an existing user.
- `workspaceId`: Workspace/building identifier where the desk exists.
- `deskId`: Concrete desk resource within the workspace.
- `startAt` / `endAt`: UTC timestamps; `endAt` must be later than `startAt`.
- `status`: Lifecycle marker; see **Status Flow** below.
- `source`: Indicates whether the booking originated from a user, admin panel, or automation.
- `purpose`: Optional free-text (≤140 chars) giving context about the session.
- `checkInAt` / `checkOutAt`: Set when the user signals arrival/departure.
- `cancelledAt`: Timestamp when the booking transitioned to `cancelled`.
- `cancelledBy`: Identifier for the actor triggering cancellation (`users/<uid>` or `system`).
- `cancellationReason`: Optional note (≤280 chars) displayed to the user.
- `repeatSeriesId`: Shared identifier so recurring bookings can be edited/cancelled as a group.
- `createdAt` / `updatedAt`: Standard audit timestamps.

## Status Flow

```text
pending -> confirmed -> checkedIn -> completed
           |             |
           |             -> noShow
           -> cancelled
```

- `pending`: Request recorded but awaiting confirmation (e.g., approval, payment).
- `confirmed`: Slot reserved; awaiting user arrival.
- `checkedIn`: User has marked presence (either manually or via sensor).
- `completed`: Booking finished successfully (check-out or automatic when `endAt` passes).
- `cancelled`: Cancelled before start or due to admin action.
- `noShow`: User never checked in; flagged for reporting.

## Validation Rules

- `startAt` must be ≥ current timestamp when created.
- `endAt` must be at least 30 minutes after `startAt`.
- `workspaceId`, `deskId`, and `userId` must reference existing documents.
- Only one non-cancelled booking may exist per `deskId` overlapping the same time window.
- `repeatSeriesId` must be a UUID v4 when provided.
- `purpose` and `cancellationReason` should strip leading/trailing whitespace.

## Indexing

Recommended Firestore composite indexes:

1. `deskBookings` on (`deskId` ASC, `startAt` ASC) — fast conflict checks.
2. `deskBookings` on (`userId` ASC, `startAt` DESC) — user booking history.
3. `deskBookings` on (`workspaceId` ASC, `startAt` ASC) — workspace calendar views.

## Access Control Notes

- Users may read and write their own bookings.
- Admin roles may read/write any booking within their workspace scope.
- Firestore rules enforce ownership, status transitions, and field validation; repositories must reject overlapping bookings before persisting documents.
