# Subscription Plan Schema

Defines the canonical structure for subscription plans across all clients and services.

## Core Subscription Plan Model

```typescript
type PlanCategory = 'dayPass' | 'explore' | 'nomad' | 'fix';

type BillingType = 'oneOff' | 'recurring';
type BillingPeriod = 'day' | 'month';

interface Billing {
  type: BillingType;           // 'oneOff' or 'recurring'
  period?: BillingPeriod;      // Required when type is 'recurring' ('day' or 'month')
  intervalCount?: number;      // Defaults to 1 if not provided (e.g., every 2 months)
}

type AccessType = 'business' | '24_7';
type SeatType = 'hot' | 'fixed';

interface Access {
  type: AccessType;                    // 'business' (9am-6pm) or '24_7'
  allowedDaysOfWeek?: number[];         // Array of integers 0-6 (Sunday=0, Saturday=6)
  startTime?: string;                   // Format: "HH:mm" (e.g., "09:00")
  endTime?: string;                     // Format: "HH:mm" (e.g., "18:00")
}

interface Quota {
  dayPassCredits?: number;              // Number of daypass credits (for dayPass plans)
  deskHoursPerPeriod?: number;          // Desk hours per period (0 = unlimited)
  meetingHoursPerPeriod?: number;       // Meeting room hours per period (0 = unlimited)
  access: Access;                       // Access configuration
  seatType?: SeatType;                  // 'hot' or 'fixed' (for fix plans)
}

interface Pricing {
  currency: string;                     // ISO 4217 currency code (e.g., 'usd', 'eur')
  amount: number;                       // Price in smallest currency unit (cents for USD)
  billingDescription: string;          // Human-readable billing description
}

interface External {
  stripeProductId?: string;             // Stripe Product ID
  stripePriceId?: string;                // Stripe Price ID (for recurring plans)
}

interface SubscriptionPlan {
  id: string;                           // Firestore document ID
  name: string;                         // Plan name (e.g., "Daypass", "Explore", "Nomad", "Fix")
  category: PlanCategory;               // Plan category
  billing: Billing;                     // Billing configuration
  quota: Quota;                         // Quota and access configuration
  pricing: Pricing;                     // Pricing information
  external?: External;                  // External integration IDs (Stripe)
  features: string[];                   // Array of feature descriptions
  isActive: boolean;                    // Whether plan is available for subscription
  createdAt: Timestamp;
  updatedAt: Timestamp;
}
```

## Firestore Collection

- **Collection**: `subscriptionPlans`
- **Document ID**: Auto-generated or custom identifier

## Field Descriptions

### SubscriptionPlan Fields

- `id`: Unique plan identifier (Firestore document ID)
- `name`: Plan name (required, must be unique, 1-100 characters)
- `category`: Plan category determining behavior:
  - `dayPass`: One-time daypass plans (1, 5, or 10 days)
  - `explore`: Hour-limited monthly recurring plans
  - `nomad`: Unlimited access, 24/7
  - `fix`: Fixed desk with unlimited meeting room
- `billing`: Billing configuration:
  - `type`: `'oneOff'` for single payment, `'recurring'` for subscription
  - `period`: Required when `type` is `'recurring'` (`'day'` or `'month'`)
  - `intervalCount`: Billing interval count (defaults to 1)
- `quota`: Quota and access configuration:
  - `dayPassCredits`: Number of daypass credits (for dayPass category)
  - `deskHoursPerPeriod`: Desk hours per period (0 = unlimited)
  - `meetingHoursPerPeriod`: Meeting room hours per period (0 = unlimited)
  - `access`: Access type and time restrictions
  - `seatType`: `'hot'` for hot desk, `'fixed'` for fixed desk (for fix category)
- `pricing`: Pricing information:
  - `currency`: ISO 4217 currency code
  - `amount`: Price in smallest currency unit (cents for USD)
  - `billingDescription`: Human-readable description (e.g., "$29.99/month")
  - `taxIncluded`: Boolean indicating whether tax is included in the price (default: `true`)
- `external`: External integration IDs (Stripe):
  - `stripeProductId`: Stripe Product ID
  - `stripePriceId`: Stripe Price ID (for recurring plans)
- `features`: Array of feature descriptions (each ≤200 characters)
- `isActive`: Whether plan is available for new subscriptions
- `createdAt` / `updatedAt`: Standard audit timestamps

## Validation Rules

- `name` must be between 1 and 100 characters, unique
- `category` must be one of: `'dayPass'`, `'explore'`, `'nomad'`, `'fix'`
- `billing.type` must be `'oneOff'` or `'recurring'`
- `billing.period` is required when `billing.type` is `'recurring'`
- `billing.intervalCount` defaults to 1 if not provided, must be positive integer
- `quota.dayPassCredits` must be positive integer (for dayPass category)
- `quota.deskHoursPerPeriod` and `quota.meetingHoursPerPeriod` must be non-negative (0 = unlimited)
- `quota.access.type` must be `'business'` or `'24_7'`
- `quota.access.startTime` and `quota.access.endTime` must be in "HH:mm" format when provided
- `quota.access.allowedDaysOfWeek` must be array of integers 0-6 when provided
- `quota.seatType` must be `'hot'` or `'fixed'` when provided (required for fix category)
- `pricing.currency` must be valid ISO 4217 code
- `pricing.amount` must be positive integer
- `features` must be array of strings (each ≤200 characters)
- For recurring plans (`billing.type === 'recurring'`), `external.stripePriceId` should be provided
- For one-off plans (`billing.type === 'oneOff'`), `external.stripeProductId` should be provided

## Plan Category Examples

### Daypass (1 day)
```typescript
{
  name: "Daypass",
  category: "dayPass",
  billing: { type: "oneOff" },
  quota: {
    dayPassCredits: 1,
    access: { type: "business", startTime: "09:00", endTime: "18:00" }
  },
  pricing: { currency: "usd", amount: 2999, billingDescription: "$29.99" }
}
```

### 5 Daypass
```typescript
{
  name: "5 Daypass",
  category: "dayPass",
  billing: { type: "oneOff" },
  quota: {
    dayPassCredits: 5,
    access: { type: "business", startTime: "09:00", endTime: "18:00" }
  },
  pricing: { currency: "usd", amount: 12999, billingDescription: "$129.99" }
}
```

### Explore (20 hours)
```typescript
{
  name: "Explore",
  category: "explore",
  billing: { type: "recurring", period: "month", intervalCount: 1 },
  quota: {
    deskHoursPerPeriod: 20,
    meetingHoursPerPeriod: 2,
    access: { type: "business", startTime: "09:00", endTime: "18:00" }
  },
  pricing: { currency: "usd", amount: 4999, billingDescription: "$49.99/month" }
}
```

### Nomad
```typescript
{
  name: "Nomad",
  category: "nomad",
  billing: { type: "recurring", period: "month", intervalCount: 1 },
  quota: {
    deskHoursPerPeriod: 0,  // unlimited
    meetingHoursPerPeriod: 0, // unlimited
    access: { type: "24_7" }
  },
  pricing: { currency: "usd", amount: 9999, billingDescription: "$99.99/month" }
}
```

### Fix
```typescript
{
  name: "Fix",
  category: "fix",
  billing: { type: "recurring", period: "month", intervalCount: 1 },
  quota: {
    deskHoursPerPeriod: 0,  // unlimited
    meetingHoursPerPeriod: 0, // unlimited
    access: { type: "24_7" },
    seatType: "fixed"
  },
  pricing: { currency: "usd", amount: 14999, billingDescription: "$149.99/month" }
}
```

## Access Control

- All authenticated users can read active plans (`isActive: true`)
- Only admins can create, update, or delete plans
- Inactive plans (`isActive: false`) are hidden from selection but remain in database for historical reference
- See Firestore rules: `match /subscriptionPlans/{document}`

## Usage Notes

- Before deleting a subscription plan, check for active subscriptions or pass bundles
- Plans with `category: 'dayPass'` are used to create `PassBundle` documents, not `Subscription` documents
- Plans with `category: 'fix'` require `quota.seatType: 'fixed'`
- Plans with `billing.type: 'recurring'` require `billing.period` to be set
- When `quota.deskHoursPerPeriod` or `quota.meetingHoursPerPeriod` is 0, it indicates unlimited usage

