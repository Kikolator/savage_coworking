# Usage Schema

Defines the canonical structure for tracking usage of subscriptions and pass bundles across all clients and services.

## Core Usage Model

```typescript
interface Breakdown {
  date: string;                         // Date string in YYYY-MM-DD format
  deskMinutes: number;                  // Desk minutes used on this date
  meetingMinutes: number;               // Meeting room minutes used on this date
  dayPassUsed: number;                  // Number of daypass credits used on this date
}

interface Usage {
  id: string;                           // Firestore document ID
  userId: string;                       // Reference to users/<uid>
  subscriptionId?: string;              // Reference to subscriptions/<id> (for recurring subscriptions)
  passBundleId?: string;                // Reference to passBundles/<id> (for pass bundles)
  periodStart: Timestamp;               // Period start timestamp
  periodEnd: Timestamp;                 // Period end timestamp
  deskMinutesUsed: number;              // Total desk minutes used in this period
  meetingMinutesUsed: number;           // Total meeting room minutes used in this period
  breakdown?: Map<string, Breakdown>;   // Daily breakdown (key: YYYY-MM-DD, value: Breakdown)
  createdAt: Timestamp;
  updatedAt: Timestamp;
}
```

## Firestore Collection

- **Collection**: `usage`
- **Document ID**: Auto-generated or custom identifier

## Field Descriptions

- `id`: Unique usage identifier (Firestore document ID)
- `userId`: Owner of the usage record, must match an existing user
- `subscriptionId`: Reference to subscription (for recurring subscriptions)
- `passBundleId`: Reference to pass bundle (for pass bundles)
- `periodStart`: Period start timestamp (UTC)
- `periodEnd`: Period end timestamp (UTC)
- `deskMinutesUsed`: Total desk minutes consumed in this period
- `meetingMinutesUsed`: Total meeting room minutes consumed in this period
- `breakdown`: Optional daily breakdown map:
  - Key: Date string in YYYY-MM-DD format
  - Value: `Breakdown` object with daily usage details
- `createdAt` / `updatedAt`: Standard audit timestamps

## Period Calculation Strategy

### Recurring Subscriptions
- Period boundaries align with billing period (`currentPeriodStart` / `currentPeriodEnd`)
- One Usage document per billing period
- Period resets when subscription renews

### Pass Bundles
- Period is calendar month (first day of month to last day of month)
- One Usage document per calendar month
- Period resets at start of each calendar month

### Daypasses
- Period is per day (single day from 00:00:00 to 23:59:59)
- One Usage document per day when daypass is used
- Each day gets its own Usage document

## Validation Rules

- `userId` must reference an existing user
- Either `subscriptionId` or `passBundleId` must be provided (not both, not neither)
- `periodEnd` must be later than `periodStart`
- `deskMinutesUsed` and `meetingMinutesUsed` must be non-negative integers
- `breakdown` keys must be valid date strings in YYYY-MM-DD format
- `breakdown` values must have:
  - `date`: Date string matching the map key
  - `deskMinutes`: Non-negative integer
  - `meetingMinutes`: Non-negative integer
  - `dayPassUsed`: Non-negative integer (typically 0 or 1)

## Access Control

- Users can read their own usage records
- Users cannot create or modify usage records (only backend/Cloud Functions can)
- Admins can read/write all usage records
- See Firestore rules: `match /usage/{document}`

## Usage Notes

- Usage documents are created and updated by backend services (Cloud Functions) when:
  - User checks in/out of a booking
  - Booking is completed
  - Daypass credit is consumed
- Usage is tracked in minutes for precision (convert from hours when needed)
- `breakdown` is optional but recommended for detailed analytics
- For unlimited plans (`deskHoursPerPeriod: 0` or `meetingHoursPerPeriod: 0`), usage is still tracked but not enforced
- When a subscription renews or a new period starts, a new Usage document is created
- Usage documents are never deleted (for audit purposes)

