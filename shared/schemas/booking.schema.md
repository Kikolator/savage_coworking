# Booking Schema

Defines the canonical structure for desk and meeting room bookings across all clients and services.

## Core Booking Model

```typescript
type BookingType = 'desk' | 'meetingRoom';
type BookingStatus = 'booked' | 'checkedIn' | 'completed' | 'cancelled';

type BookingKind = 'subscription' | 'passBundle';

interface BookingSource {
  kind: BookingKind;                    // 'subscription' or 'passBundle'
  subscriptionId?: string;              // Reference to subscriptions/<id> (when kind is 'subscription')
  passBundleId?: string;                // Reference to passBundles/<id> (when kind is 'passBundle')
}

interface Booking {
  id: string;                           // Firestore document ID
  userId: string;                       // Reference to users/<uid>
  type: BookingType;                    // 'desk' or 'meetingRoom'
  startAt: Timestamp;                   // Booking start date and time (UTC)
  endAt: Timestamp;                     // Booking end date and time (UTC)
  source: BookingSource;                // Source of the booking (subscription or passBundle)
  status: BookingStatus;                // Current booking status
  workspaceId: string;                  // Reference to workspaces/<id>
  deskId?: string;                       // Reference to desks/<id> (when type is 'desk')
  roomId?: string;                      // Reference to meeting rooms/<id> (when type is 'meetingRoom')
  createdAt: Timestamp;
  updatedAt: Timestamp;
}
```

## Firestore Collection

- **Collection**: `bookings`
- **Document ID**: Auto-generated or custom identifier

## Field Descriptions

- `id`: Unique booking identifier (Firestore document ID)
- `userId`: Owner of the booking, must match an existing user
- `type`: Booking type: `'desk'` for desk booking, `'meetingRoom'` for meeting room booking
- `startAt`: Booking start date and time as Timestamp (UTC)
- `endAt`: Booking end date and time as Timestamp (UTC)
- `source`: Source of the booking:
  - `kind`: `'subscription'` or `'passBundle'`
  - `subscriptionId`: Reference to subscription (when `kind` is `'subscription'`)
  - `passBundleId`: Reference to pass bundle (when `kind` is `'passBundle'`)
- `status`: Current booking status; see **Status Flow** below
- `workspaceId`: Workspace/building identifier where the booking exists
- `deskId`: Reference to specific desk (required when `type` is `'desk'`)
- `roomId`: Reference to specific meeting room (required when `type` is `'meetingRoom'`)
- `createdAt` / `updatedAt`: Standard audit timestamps

## Status Flow

```text
booked -> checkedIn -> completed
  |
  -> cancelled
```

- `booked`: Booking is confirmed and reserved
- `checkedIn`: User has checked in (arrived)
- `completed`: Booking finished successfully (checked out or time passed)
- `cancelled`: Booking was cancelled before completion

## Validation Rules

- `userId` must reference an existing user
- `type` must be `'desk'` or `'meetingRoom'`
- `startAt` and `endAt` must be valid Timestamps
- `endAt` must be later than `startAt`
- `source.kind` must be `'subscription'` or `'passBundle'`
- When `source.kind` is `'subscription'`, `source.subscriptionId` must be provided and `source.passBundleId` must be null
- When `source.kind` is `'passBundle'`, `source.passBundleId` must be provided and `source.subscriptionId` must be null
- `status` must be a valid `BookingStatus`
- `workspaceId` must reference an existing workspace
- When `type` is `'desk'`, `deskId` must be provided
- When `type` is `'meetingRoom'`, `roomId` must be provided
- Only one non-cancelled booking may exist per `deskId` or `roomId` overlapping the same time window

## Access Control

- Users can read and write their own bookings
- Admins can read/write all bookings
- See Firestore rules: `match /bookings/{document}`

## Usage Notes

- Bookings are created when a user reserves a desk or meeting room
- The `source` field determines which quota to deduct from (subscription or passBundle)
- When a booking is completed, the backend:
  - Updates the corresponding Usage document
  - Decrements `remainingCredits` if booking source is a passBundle
  - Tracks minutes used in the Usage document
- Bookings can be cancelled before check-in or completion
- For daypass bookings, the `startAt` date must match one of the selected days in the passBundle
- Booking times must respect the access restrictions from the subscription or passBundle (e.g., business hours 9am-6pm)

