import Stripe from "stripe";
import {Timestamp} from "firebase-admin/firestore";
import {db} from "../../config/firebaseAdmin";
import {getEnvConfig} from "../../config/env";
import {
  CheckoutSessionParams,
  CheckoutSessionResponse,
} from "./stripe.types";

const STRIPE_CUSTOMERS_COLLECTION = "stripeCustomers";

/**
 * Gets or creates a Stripe customer for a user.
 * @param {string} userId - User ID.
 * @param {string} email - User email.
 * @return {Promise<string>} Stripe customer ID.
 */
async function getOrCreateCustomer(
  userId: string,
  email: string,
): Promise<string> {
  const stripe = new Stripe(getEnvConfig().stripe.secretKey, {
    apiVersion: "2025-11-17.clover" as Stripe.LatestApiVersion,
  });

  // Check if customer exists in Firestore
  const customerDoc = await db()
    .collection(STRIPE_CUSTOMERS_COLLECTION)
    .doc(userId)
    .get();

  if (customerDoc.exists) {
    const data = customerDoc.data();
    if (data?.stripeCustomerId) {
      return data.stripeCustomerId;
    }
  }

  // Create new Stripe customer
  const customer = await stripe.customers.create({
    email,
    metadata: {
      userId,
    },
  });

  // Store in Firestore
  await db().collection(STRIPE_CUSTOMERS_COLLECTION).doc(userId).set({
    userId,
    stripeCustomerId: customer.id,
    email,
    createdAt: Timestamp.now(),
    updatedAt: Timestamp.now(),
  });

  return customer.id;
}

/**
 * Creates a Stripe checkout session.
 * @param {CheckoutSessionParams} params - Checkout session parameters.
 * @return {Promise<CheckoutSessionResponse>} Checkout session response.
 */
export async function createCheckoutSession(
  params: CheckoutSessionParams,
): Promise<CheckoutSessionResponse> {
  const stripe = new Stripe(getEnvConfig().stripe.secretKey, {
    apiVersion: "2025-11-17.clover" as Stripe.LatestApiVersion,
  });

  // Get or create Stripe customer
  const customerId = await getOrCreateCustomer(
    params.userId,
    params.customerEmail,
  );

  // Build line items based on mode
  const lineItems: Stripe.Checkout.SessionCreateParams.LineItem[] = [];

  if (params.mode === "subscription" && params.stripePriceId) {
    lineItems.push({
      price: params.stripePriceId,
      quantity: 1,
    });
  } else if (params.mode === "payment" && params.stripeProductId) {
    // For one-off payments, we need to create a price or use product
    // For now, we'll require stripePriceId for both modes
    // This can be enhanced later
    throw new Error(
      "Payment mode requires stripePriceId. Product-only payments not yet supported.",
    );
  } else {
    throw new Error(
      "Missing required Stripe price or product ID for checkout session",
    );
  }

  // Create checkout session
  const session = await stripe.checkout.sessions.create({
    customer: customerId,
    mode: params.mode,
    line_items: lineItems,
    success_url: params.successUrl,
    cancel_url: params.cancelUrl,
    metadata: {
      userId: params.userId,
      planId: params.planId,
    },
    allow_promotion_codes: true,
  });

  if (!session.url) {
    throw new Error("Failed to create checkout session URL");
  }

  return {
    checkoutUrl: session.url,
    sessionId: session.id,
  };
}


