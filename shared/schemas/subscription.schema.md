# Subscription Schema

Defines the canonical structure for recurring subscriptions across all clients and services.

**Note**: One-time passes (daypasses) are handled by the `PassBundle` model, not this `Subscription` model. See `pass-bundle.schema.md` for one-time passes.

## Core Subscription Model

```typescript
type SubscriptionStatus = 'active' | 'cancelled' | 'expired' | 'trial' | 'past_due';

type BillingType = 'recurring';
type BillingPeriod = 'day' | 'month';

interface Billing {
  type: BillingType;           // Always 'recurring' for subscriptions
  period: BillingPeriod;      // 'day' or 'month'
  intervalCount: number;        // Billing interval count (defaults to 1)
}

type AccessType = 'business' | '24_7';

interface Access {
  type: AccessType;                    // 'business' (9am-6pm) or '24_7'
  allowedDaysOfWeek?: number[];         // Array of integers 0-6 (Sunday=0, Saturday=6)
  startTime?: string;                   // Format: "HH:mm" (e.g., "09:00")
  endTime?: string;                     // Format: "HH:mm" (e.g., "18:00")
}

interface Quota {
  deskHoursPerPeriod?: number;          // Desk hours per period (0 = unlimited)
  meetingHoursPerPeriod?: number;       // Meeting room hours per period (0 = unlimited)
  access: Access;                       // Access configuration
  seatType?: 'hot' | 'fixed';          // 'hot' or 'fixed' (for fix plans)
}

interface Overrides {
  deskHoursPerPeriod?: number;          // Override desk hours (admin-only, permanent)
  meetingHoursPerPeriod?: number;       // Override meeting room hours (admin-only, permanent)
  // Other overrides can be added here
}

interface Display {
  planName: string;                     // Human-readable plan name
  priceAmount: number;                  // Price in smallest currency unit (cents)
  priceCurrency: string;                // ISO 4217 currency code
}

interface Subscription {
  id: string;                           // Firestore document ID
  userId: string;                       // Reference to users/<uid>
  planId: string;                       // Reference to subscriptionPlans/<id>
  status: SubscriptionStatus;           // Current subscription status
  billing: Billing;                     // Billing configuration
  effectiveQuota: Quota;                 // Effective quota (plan quota + overrides)
  overrides?: Overrides;                 // Admin-only overrides (permanent)
  display: Display;                      // Display information
  stripeCustomerId: string;             // Stripe customer ID
  stripeSubscriptionId?: string;         // Stripe subscription ID (for recurring)
  currentPeriodStart: Timestamp;        // Current billing period start
  currentPeriodEnd: Timestamp;          // Current billing period end
  cancelAtPeriodEnd: boolean;           // Whether to cancel at period end
  cancelledAt?: Timestamp;              // When subscription was cancelled
  cancelledBy?: string;                 // User ID who cancelled (uid)
  assignedDeskId?: string;              // Assigned desk ID (for fix plans)
  createdAt: Timestamp;
  updatedAt: Timestamp;
}
```

## Firestore Collection

- **Collection**: `subscriptions`
- **Document ID**: Auto-generated or custom identifier

## Field Descriptions

### Subscription Fields

- `id`: Unique subscription identifier (Firestore document ID)
- `userId`: Owner of the subscription, must match an existing user
- `planId`: Reference to the subscription plan (must have `billing.type: 'recurring'`)
- `status`: Current lifecycle status; see **Status Flow** below
- `billing`: Billing configuration:
  - `type`: Always `'recurring'` for subscriptions
  - `period`: `'day'` or `'month'`
  - `intervalCount`: Billing interval count (defaults to 1)
- `effectiveQuota`: Effective quota (plan quota + overrides):
  - `deskHoursPerPeriod`: Desk hours per period (0 = unlimited)
  - `meetingHoursPerPeriod`: Meeting room hours per period (0 = unlimited)
  - `access`: Access type and time restrictions
  - `seatType`: `'hot'` for hot desk, `'fixed'` for fixed desk (for fix plans)
- `overrides`: Admin-only overrides (permanent, overrides plan quota):
  - `deskHoursPerPeriod`: Override desk hours
  - `meetingHoursPerPeriod`: Override meeting room hours
- `display`: Display information:
  - `planName`: Human-readable plan name
  - `priceAmount`: Price in smallest currency unit (cents)
  - `priceCurrency`: ISO 4217 currency code
- `stripeCustomerId`: Stripe customer identifier (required)
- `stripeSubscriptionId`: Stripe subscription identifier (for recurring subscriptions)
- `currentPeriodStart` / `currentPeriodEnd`: Current billing period boundaries (UTC)
- `cancelAtPeriodEnd`: If true, subscription will cancel at end of current period
- `cancelledAt`: Timestamp when subscription was cancelled (if cancelled)
- `cancelledBy`: User ID who cancelled the subscription (uid)
- `assignedDeskId`: Assigned desk ID (for fix plans with `seatType: 'fixed'`)
- `createdAt` / `updatedAt`: Standard audit timestamps

## Status Flow

```text
trial -> active -> past_due -> cancelled
         |                      |
         -> cancelled (immediate)
         -> expired (after period end)
```

- `trial`: Trial period (if applicable)
- `active`: Subscription is active and user can book
- `past_due`: Payment failed, subscription is past due
- `cancelled`: Subscription cancelled (immediate or at period end)
- `expired`: Subscription expired after cancellation period ended

## Validation Rules

- `userId` must reference an existing user
- `planId` must reference an existing subscription plan with `billing.type: 'recurring'`
- `status` must be a valid `SubscriptionStatus`
- `billing.type` must be `'recurring'`
- `billing.period` must be `'day'` or `'month'`
- `billing.intervalCount` must be positive integer (defaults to 1)
- `currentPeriodEnd` must be later than `currentPeriodStart`
- `effectiveQuota.deskHoursPerPeriod` and `effectiveQuota.meetingHoursPerPeriod` must be non-negative (0 = unlimited)
- `effectiveQuota.access.type` must be `'business'` or `'24_7'`
- `effectiveQuota.access.startTime` and `effectiveQuota.access.endTime` must be in "HH:mm" format when provided
- `effectiveQuota.access.allowedDaysOfWeek` must be array of integers 0-6 when provided
- `overrides` can only be set by admins (enforced in Firestore rules)
- `stripeCustomerId` must be a non-empty string
- `stripeSubscriptionId` must be provided for active recurring subscriptions
- Only one active subscription per user at a time (enforced by application logic)
- For fix plans (`effectiveQuota.seatType: 'fixed'`), `assignedDeskId` must be provided

## Access Control

- Users can read their own subscriptions
- Users can update `cancelAtPeriodEnd` on their own subscriptions
- Admins can read/write all subscriptions
- Only admins can set `overrides` field
- See Firestore rules: `match /subscriptions/{document}`

## Usage Notes

- Subscriptions are for recurring plans only (`billing.type: 'recurring'`)
- One-time passes are handled by `PassBundle` model (see `pass-bundle.schema.md`)
- Usage is tracked separately in the `usage` collection (see `usage.schema.md`)
- `effectiveQuota` is calculated from plan quota + overrides (if any)
- `overrides` are permanent and override the plan's quota values
- When `effectiveQuota.deskHoursPerPeriod` or `effectiveQuota.meetingHoursPerPeriod` is 0, it indicates unlimited usage
- For fix plans, `assignedDeskId` must be set to assign a specific desk to the user
- Subscription hours are checked per billing period (reset at `currentPeriodStart`)
- Hours usage should be tracked in the `usage` collection, not in the subscription document
