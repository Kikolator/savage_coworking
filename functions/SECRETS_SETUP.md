# Firebase Secrets Setup Guide

This project uses **Firebase Secrets** (recommended) for managing sensitive configuration like Stripe API keys. This provides better security and per-project management compared to environment variables.

## Why Firebase Secrets?

✅ **Secure**: Secrets are encrypted and stored in Google Secret Manager  
✅ **Per-Project**: Different values for dev/prod automatically  
✅ **Versioned**: Track secret versions and rollback if needed  
✅ **Access Control**: Fine-grained permissions via IAM  
✅ **Audit Logs**: Track who accessed secrets and when  

## Setup Instructions

### 1. Set Secrets for Development Project

```bash
# Switch to dev project
firebase use dev

# Set Stripe test mode keys (get these from Stripe Dashboard > Developers > API keys)
firebase functions:secrets:set STRIPE_SECRET_KEY
# When prompted, paste your test secret key (sk_test_...)

firebase functions:secrets:set STRIPE_WEBHOOK_SECRET
# When prompted, paste your test webhook secret (whsec_...)
```

### 2. Set Secrets for Production Project

```bash
# Switch to prod project
firebase use prod

# Set Stripe live mode keys (get these from Stripe Dashboard > Developers > API keys)
firebase functions:secrets:set STRIPE_SECRET_KEY
# When prompted, paste your live secret key (sk_live_...)

firebase functions:secrets:set STRIPE_WEBHOOK_SECRET
# When prompted, paste your live webhook secret (whsec_...)
```

### 3. Verify Secrets Are Set

```bash
# List secrets for current project
firebase functions:secrets:access STRIPE_SECRET_KEY
firebase functions:secrets:access STRIPE_WEBHOOK_SECRET
```

### 4. Local Development Setup

For local development with emulators, you have two options:

#### Option A: Use .env file (Recommended for local dev)

1. Create `functions/.env` file:
```bash
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
```

2. Install dotenv package:
```bash
cd functions
npm install --save-dev dotenv
```

3. Load in your code (if needed) or use environment variables directly.

#### Option B: Set environment variables

```bash
export STRIPE_SECRET_KEY=sk_test_...
export STRIPE_WEBHOOK_SECRET=whsec_...
```

**Note**: The code automatically falls back to `process.env` when secrets aren't available (like in local development).

## How It Works

1. **In Deployed Functions**: Secrets are automatically injected by Firebase
2. **In Local Development**: Falls back to `process.env` variables
3. **Per-Project**: Each Firebase project (dev/prod) has its own secret values

## Code Implementation

The secrets are defined in `src/config/env.ts`:

```typescript
import {defineSecret} from "firebase-functions/params";

export const stripeSecretKey = defineSecret("STRIPE_SECRET_KEY");
export const stripeWebhookSecret = defineSecret("STRIPE_WEBHOOK_SECRET");
```

Functions reference these secrets in their configuration:

```typescript
export const createCheckoutSession = onCall(
  {
    region: "us-central1",
    secrets: [stripeSecretKey], // Function has access to this secret
  },
  async (request) => {
    // Secret is available via stripeSecretKey.value()
  }
);
```

## Getting Stripe Keys

### Test Mode (Development)
1. Go to [Stripe Dashboard](https://dashboard.stripe.com/test/apikeys)
2. Copy **Secret key** (starts with `sk_test_`)
3. For webhook secret:
   - Go to [Webhooks](https://dashboard.stripe.com/test/webhooks)
   - Create or select an endpoint
   - Copy **Signing secret** (starts with `whsec_`)

### Live Mode (Production)
1. Switch to **Live mode** in Stripe Dashboard
2. Go to [API keys](https://dashboard.stripe.com/apikeys)
3. Copy **Secret key** (starts with `sk_live_`)
4. For webhook secret:
   - Go to [Webhooks](https://dashboard.stripe.com/webhooks)
   - Create or select an endpoint
   - Copy **Signing secret** (starts with `whsec_`)

## Troubleshooting

### Secret not found error
- Ensure you've set the secret for the correct project
- Check you're using the right project: `firebase use dev` or `firebase use prod`
- Verify secret name matches exactly: `STRIPE_SECRET_KEY` (case-sensitive)

### Local development not working
- Ensure `.env` file exists in `functions/` directory
- Or set environment variables before running emulators
- Check that secrets are referenced in function definitions

### Different values for dev/prod
- Secrets are automatically per-project
- Just set them separately for each project
- No code changes needed - Firebase handles it automatically

## Security Best Practices

1. ✅ **Never commit secrets to git** - Use `.gitignore` for `.env` files
2. ✅ **Use test keys for dev** - Never use live keys in development
3. ✅ **Rotate secrets regularly** - Update secrets if compromised
4. ✅ **Limit access** - Only grant secret access to necessary team members
5. ✅ **Monitor usage** - Check audit logs for secret access

## Additional Resources

- [Firebase Secrets Documentation](https://firebase.google.com/docs/functions/config-env#secret-manager)
- [Stripe API Keys Guide](https://stripe.com/docs/keys)
- [Stripe Webhooks Guide](https://stripe.com/docs/webhooks)

