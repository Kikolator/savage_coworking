/**
 * Centralized environment configuration using Firebase Secrets.
 *
 * Firebase Secrets is the recommended approach for sensitive data like
 * API keys. Secrets are managed per Firebase project, allowing different
 * values for dev/prod.
 *
 * To set secrets:
 *   firebase functions:secrets:set STRIPE_SECRET_KEY --project=dev
 *   firebase functions:secrets:set STRIPE_SECRET_KEY --project=prod
 *
 * Secrets are automatically available in deployed functions.
 * For local development, use .env file or set environment variables.
 */

import {defineSecret} from "firebase-functions/params";

/**
 * Firebase Secrets for Stripe configuration.
 * These are defined once and can be referenced in function definitions.
 */
export const stripeSecretKey = defineSecret("STRIPE_SECRET_KEY");
export const stripeWebhookSecret = defineSecret("STRIPE_WEBHOOK_SECRET");

/**
 * Application environment configuration.
 */
export interface EnvConfig {
  stripe: {
    secretKey: string;
    webhookSecret: string;
  };
}

/**
 * Gets the Stripe secret key.
 * In deployed functions, uses Firebase Secrets.
 * In local development, falls back to process.env.
 * @return {string} Stripe secret key.
 * @throws {Error} If STRIPE_SECRET_KEY is not set.
 */
function getStripeSecretKey(): string {
  // In deployed functions, use the secret value
  // In local dev, fall back to process.env
  const key = stripeSecretKey.value() || process.env.STRIPE_SECRET_KEY;
  if (!key) {
    throw new Error(
      "STRIPE_SECRET_KEY not set. Set it as a Firebase secret or " +
        "environment variable.",
    );
  }
  return key;
}

/**
 * Gets the Stripe webhook secret.
 * In deployed functions, uses Firebase Secrets.
 * In local development, falls back to process.env.
 * @return {string} Stripe webhook secret.
 * @throws {Error} If STRIPE_WEBHOOK_SECRET is not set.
 */
function getStripeWebhookSecret(): string {
  // In deployed functions, use the secret value
  // In local dev, fall back to process.env
  const secret =
    stripeWebhookSecret.value() || process.env.STRIPE_WEBHOOK_SECRET;
  if (!secret) {
    throw new Error(
      "STRIPE_WEBHOOK_SECRET not set. Set it as a Firebase secret or " +
        "environment variable.",
    );
  }
  return secret;
}

/**
 * Gets the application environment configuration.
 * @return {EnvConfig} Environment configuration object.
 * @throws {Error} If required secrets/environment variables are missing.
 */
export function getEnvConfig(): EnvConfig {
  return {
    stripe: {
      secretKey: getStripeSecretKey(),
      webhookSecret: getStripeWebhookSecret(),
    },
  };
}


