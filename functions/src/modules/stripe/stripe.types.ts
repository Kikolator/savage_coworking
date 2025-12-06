/**
 * Type definitions for Stripe integration.
 */

/**
 * Parameters for creating a checkout session.
 */
export interface CheckoutSessionParams {
  userId: string;
  planId: string;
  customerEmail: string;
  successUrl: string;
  cancelUrl: string;
  stripePriceId?: string;
  stripeProductId?: string;
  mode: "subscription" | "payment";
}

/**
 * Response from creating a checkout session.
 */
export interface CheckoutSessionResponse {
  checkoutUrl: string;
  sessionId: string;
}

/**
 * Stripe customer data stored in Firestore.
 */
export interface StripeCustomerData {
  userId: string;
  stripeCustomerId: string;
  email: string;
  createdAt: Date;
  updatedAt: Date;
}


