# Subscription Schema

Defines the canonical structure for user subscriptions and subscription plans across all clients and services.

## Core Subscription Model

```typescript
type SubscriptionStatus =
  | 'active'
  | 'cancelled'
  | 'expired'
  | 'trial'
  | 'past_due';

interface Subscription {
  id: string;                      // Firestore document ID
  userId: string;                  // Reference to users/<uid>
  planId: string;                  // Reference to subscriptionPlans/<id>
  planName: string;                // Plan name (Basic, Pro, Enterprise)
  status: SubscriptionStatus;      // Current subscription status
  stripeSubscriptionId?: string;   // Stripe subscription ID (optional for one-off)
  stripeCustomerId: string;        // Stripe customer ID
  stripePaymentIntentId?: string;  // Stripe Payment Intent ID (for one-off payments)
  renewsAutomatically: boolean;    // Whether subscription renews automatically
  currentPeriodStart: Timestamp;    // Current billing period start
  currentPeriodEnd: Timestamp;      // Current billing period end
  cancelAtPeriodEnd: boolean;       // Whether to cancel at period end
  deskHours: number;                // Desk hours allocated per period (from plan)
  meetingRoomHours: number;         // Meeting room hours allocated per period (from plan)
  deskHoursUsed: number;            // Desk hours consumed in current period
  meetingRoomHoursUsed: number;     // Meeting room hours consumed in current period
  createdAt: Timestamp;
  updatedAt: Timestamp;
}
```

## Subscription Plan Model

```typescript
type SubscriptionInterval = 'month' | 'one_off';

interface SubscriptionPlan {
  id: string;                      // Firestore document ID
  name: string;                    // Plan name (Basic, Pro, Enterprise)
  price: number;                   // Price in cents (e.g., 2999 = $29.99)
  currency: string;                // Currency code (e.g., 'usd')
  interval: SubscriptionInterval;  // Billing interval ('month' or 'one_off')
  deskHours: number;               // Desk hours allocated per period (0 = unlimited)
  meetingRoomHours: number;        // Meeting room hours allocated per period (0 = unlimited)
  features: string[];              // Array of feature descriptions
  isActive: boolean;               // Whether plan is available for subscription
  stripePriceId?: string;          // Stripe Price ID for this plan (for recurring)
  stripeProductId?: string;         // Stripe Product ID for this plan
  createdAt: Timestamp;
  updatedAt: Timestamp;
}
```

## Firestore Collections

- **Collection**: `subscriptions`
  - **Document ID**: Auto-generated or custom identifier

- **Collection**: `subscriptionPlans`
  - **Document ID**: Auto-generated or custom identifier

## Field Descriptions

### Subscription Fields

- `id`: Unique subscription identifier (Firestore document ID)
- `userId`: Owner of the subscription, must match an existing user
- `planId`: Reference to the subscription plan
- `planName`: Human-readable plan name for quick reference
- `status`: Current lifecycle status; see **Status Flow** below
- `stripeSubscriptionId`: Stripe subscription identifier for recurring subscriptions (optional, only for recurring)
- `stripeCustomerId`: Stripe customer identifier
- `stripePaymentIntentId`: Stripe Payment Intent identifier for one-off payments (optional, only for one-off)
- `renewsAutomatically`: Whether the subscription renews automatically (false for one-off plans)
- `currentPeriodStart` / `currentPeriodEnd`: Current billing period boundaries (UTC)
- `cancelAtPeriodEnd`: If true, subscription will cancel at end of current period
- `deskHours`: Maximum desk hours allowed per billing period (from plan)
- `meetingRoomHours`: Maximum meeting room hours allowed per billing period (from plan)
- `deskHoursUsed`: Desk hours consumed in the current billing period
- `meetingRoomHoursUsed`: Meeting room hours consumed in the current billing period
- `createdAt` / `updatedAt`: Standard audit timestamps

### Subscription Plan Fields

- `id`: Unique plan identifier (Firestore document ID)
- `name`: Plan name (required, must be unique)
- `price`: Price in smallest currency unit (cents for USD)
- `currency`: ISO 4217 currency code (e.g., 'usd', 'eur')
- `interval`: Billing interval ('month' for recurring, 'one_off' for single payment)
- `deskHours`: Maximum desk hours allowed per period (0 = unlimited)
- `meetingRoomHours`: Maximum meeting room hours allowed per period (0 = unlimited)
- `features`: Array of feature descriptions (e.g., ["Unlimited desks", "Priority support"])
- `isActive`: Whether plan is available for new subscriptions
- `stripePriceId`: Optional Stripe Price ID for recurring subscriptions
- `stripeProductId`: Optional Stripe Product ID for integration
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

### Subscription

- `userId` must reference an existing user
- `planId` must reference an existing subscription plan
- `status` must be a valid SubscriptionStatus
- `currentPeriodEnd` must be later than `currentPeriodStart`
- `deskHours` and `meetingRoomHours` must be non-negative numbers
- `deskHoursUsed` and `meetingRoomHoursUsed` must be non-negative numbers
- `deskHoursUsed` must not exceed `deskHours` (unless `deskHours` is 0 for unlimited)
- `meetingRoomHoursUsed` must not exceed `meetingRoomHours` (unless `meetingRoomHours` is 0 for unlimited)
- `stripeCustomerId` must be a non-empty string
- For recurring subscriptions (`renewsAutomatically: true`), `stripeSubscriptionId` must be provided
- For one-off subscriptions (`renewsAutomatically: false`), `stripePaymentIntentId` should be provided
- Only one active subscription per user at a time (enforced by application logic)

### Subscription Plan

- `name` must be between 1 and 100 characters, unique
- `price` must be a positive integer (in cents)
- `currency` must be a valid ISO 4217 code
- `interval` must be 'month' or 'one_off'
- `deskHours` and `meetingRoomHours` must be non-negative numbers (0 = unlimited)
- `features` must be an array of strings (each ≤200 characters)
- For recurring plans (`interval: 'month'`), `stripePriceId` should be provided
- For one-off plans (`interval: 'one_off'`), `stripeProductId` should be provided

## Access Control

- **Subscriptions**:
  - Users can read their own subscriptions
  - Users can update `cancelAtPeriodEnd` on their own subscriptions
  - Admins can read/write all subscriptions

- **Subscription Plans**:
  - All authenticated users can read active plans
  - Only admins can create, update, or delete plans
  - See Firestore rules: `match /subscriptions/{document}` and `match /subscriptionPlans/{document}`

## Usage Notes

- Subscriptions are referenced by `subscriptionId` in invoices
- Before deleting a subscription plan, check for active subscriptions
- Inactive plans (`isActive: false`) are hidden from selection but remain in database for historical reference
- Subscription hours are checked per billing period (reset at `currentPeriodStart`)
- For one-off subscriptions, `currentPeriodEnd` may be set to a far future date or the subscription expiration date
- Hours usage (`deskHoursUsed`, `meetingRoomHoursUsed`) should be tracked and reset at the start of each billing period
- When `deskHours` or `meetingRoomHours` is 0, it indicates unlimited usage

