# API Doc Overview

## Subscription API

### POST /api/subscriptions/checkout

Creates a Stripe checkout session for a subscription plan.

**Authentication**: Required (Bearer token)

**Request Body**:
```json
{
  "userId": "string",
  "planId": "string",
  "customerEmail": "string",
  "baseUrl": "string" // Optional, defaults to "https://your-app.com"
}
```

**Response** (200 OK):
```json
{
  "checkoutUrl": "string",
  "sessionId": "string"
}
```

**Error Responses**:
- `400`: Missing required fields, plan not active, or missing Stripe IDs
- `404`: Plan not found
- `409`: User already has an active subscription
- `500`: Internal server error

### POST /api/subscriptions/webhook

Stripe webhook endpoint for processing payment events.

**Authentication**: Verified via Stripe signature header

**Headers**:
- `stripe-signature`: Stripe webhook signature (required)

**Request Body**: Raw JSON from Stripe

**Response** (200 OK):
```json
{
  "received": true
}
```

**Processed Events**:
- `checkout.session.completed`: Creates subscription in Firestore
- `customer.subscription.updated`: Updates subscription status and period
- `customer.subscription.deleted`: Cancels subscription
