# User Schema

This document defines the user model schema used across the application.

## Core User Model

```typescript
type AccessType = 'business' | '24_7';
type SubscriptionStatus = 'active' | 'cancelled' | 'expired' | 'trial' | 'past_due';

interface MembershipSummary {
  activeSubscriptionId?: string;      // Reference to subscriptions/<id> (if user has active subscription)
  planId?: string;                      // Reference to subscriptionPlans/<id>
  planName?: string;                    // Plan name for quick reference
  status?: SubscriptionStatus;          // Current subscription status
  currentPeriodEnd?: Timestamp;         // Current billing period end
  deskMinutesRemaining?: number;        // Remaining desk minutes in current period (null = unlimited)
  meetingMinutesRemaining?: number;     // Remaining meeting room minutes in current period (null = unlimited)
  remainingDayPassCredits?: number;      // Total remaining daypass credits across all active pass bundles
  access?: AccessType;                  // Access type ('business' or '24_7')
}

interface User {
  id: string;              // Firebase Auth UID
  email: string;           // User's email address
  displayName?: string;    // Optional display name
  photoUrl?: string;       // Optional profile photo URL
  selectedWorkspaceId?: string; // Optional selected workspace ID (for admins)
  membership?: MembershipSummary; // Denormalized membership summary (updated by Cloud Functions)
  createdAt: Timestamp;   // Account creation timestamp
  updatedAt: Timestamp;   // Last update timestamp
}
```

## Firestore Collection

- **Collection**: `users`
- **Document ID**: Firebase Auth UID

## Field Descriptions

- `id`: Unique identifier from Firebase Authentication
- `email`: User's email address (required, unique)
- `displayName`: Optional display name for the user
- `photoUrl`: Optional URL to user's profile photo
- `selectedWorkspaceId`: Optional workspace ID that the user (admin) has selected for viewing/managing data
- `membership`: Denormalized membership summary (updated by Cloud Functions):
  - `activeSubscriptionId`: Reference to active subscription (if exists)
  - `planId`: Reference to subscription plan
  - `planName`: Human-readable plan name
  - `status`: Current subscription status
  - `currentPeriodEnd`: Current billing period end
  - `deskMinutesRemaining`: Remaining desk minutes (null = unlimited)
  - `meetingMinutesRemaining`: Remaining meeting room minutes (null = unlimited)
  - `remainingDayPassCredits`: Total remaining daypass credits from all active pass bundles
  - `access`: Access type ('business' or '24_7')
- `createdAt`: Timestamp when the user account was created
- `updatedAt`: Timestamp when the user document was last updated

## Validation Rules

- `email`: Must be a valid email format
- `displayName`: If provided, must be between 1 and 100 characters
- `photoUrl`: If provided, must be a valid URL

## Access Control

See Firestore rules for user document access control.

