# Pass Bundle Schema

Defines the canonical structure for one-time pass bundles (daypasses) across all clients and services.

## Core Pass Bundle Model

```typescript
type PassBundleStatus = 'active' | 'consumed' | 'expired' | 'cancelled';

type AccessType = 'business' | '24_7';

interface Access {
  type: AccessType;                    // 'business' (9am-6pm) or '24_7'
  allowedDaysOfWeek?: number[];         // Array of integers 0-6 (Sunday=0, Saturday=6)
  startTime?: string;                   // Format: "HH:mm" (e.g., "09:00")
  endTime?: string;                     // Format: "HH:mm" (e.g., "18:00")
}

interface PassBundle {
  id: string;                           // Firestore document ID
  userId: string;                       // Reference to users/<uid>
  planId: string;                       // Reference to subscriptionPlans/<id>
  status: PassBundleStatus;             // Current status
  totalCredits: number;                 // Total daypass credits purchased
  remainingCredits: number;            // Remaining daypass credits
  validFrom: Timestamp;                 // When the bundle becomes valid
  validUntil?: Timestamp;               // Optional expiration date
  access: Access;                        // Access configuration (copied from plan)
  createdAt: Timestamp;
  updatedAt: Timestamp;
}
```

## Firestore Collection

- **Collection**: `passBundles`
- **Document ID**: Auto-generated or custom identifier

## Field Descriptions

- `id`: Unique pass bundle identifier (Firestore document ID)
- `userId`: Owner of the pass bundle, must match an existing user
- `planId`: Reference to the subscription plan (must have `category: 'dayPass'`)
- `status`: Current lifecycle status; see **Status Flow** below
- `totalCredits`: Total number of daypass credits purchased (from plan's `quota.dayPassCredits`)
- `remainingCredits`: Number of daypass credits remaining (decremented when used)
- `validFrom`: Timestamp when the bundle becomes valid (typically purchase date)
- `validUntil`: Optional expiration timestamp (if not set, bundle doesn't expire)
- `access`: Access configuration copied from plan:
  - `type`: `'business'` (9am-6pm) or `'24_7'`
  - `allowedDaysOfWeek`: Array of integers 0-6 (Sunday=0, Saturday=6)
  - `startTime`: Start time in "HH:mm" format (e.g., "09:00")
  - `endTime`: End time in "HH:mm" format (e.g., "18:00")
- `createdAt` / `updatedAt`: Standard audit timestamps

## Status Flow

```text
active -> consumed (when remainingCredits reaches 0)
  |
  -> expired (when validUntil passes)
  |
  -> cancelled (admin action)
```

- `active`: Bundle is active and can be used
- `consumed`: All credits have been used (`remainingCredits === 0`)
- `expired`: Bundle has expired (`validUntil` has passed)
- `cancelled`: Bundle was cancelled by admin

## Validation Rules

- `userId` must reference an existing user
- `planId` must reference an existing subscription plan with `category: 'dayPass'`
- `status` must be a valid `PassBundleStatus`
- `totalCredits` must be positive integer
- `remainingCredits` must be non-negative integer, ≤ `totalCredits`
- `validFrom` must be a valid timestamp
- `validUntil` must be later than `validFrom` if provided
- `access.type` must be `'business'` or `'24_7'`
- `access.startTime` and `access.endTime` must be in "HH:mm" format when provided
- `access.allowedDaysOfWeek` must be array of integers 0-6 when provided
- Users can have multiple active pass bundles simultaneously

## Access Control

- Users can read their own pass bundles
- Users cannot modify pass bundles (only admins can)
- Admins can read/write all pass bundles
- See Firestore rules: `match /passBundles/{document}`

## Usage Notes

- Pass bundles are created when a user purchases a dayPass plan (`category: 'dayPass'`)
- Each time a daypass credit is used (booking completed), `remainingCredits` is decremented
- When `remainingCredits` reaches 0, status should be updated to `'consumed'`
- Pass bundles can be used in conjunction with active subscriptions
- Access configuration is copied from the plan at purchase time and stored in the bundle
- If `validUntil` is not set, the bundle doesn't expire based on date (only when credits are consumed)

