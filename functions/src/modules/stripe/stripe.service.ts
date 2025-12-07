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

/**
 * Creates a Stripe product and price atomically.
 * @param {string} name - Product name.
 * @param {number} price - Price in cents.
 * @param {string} currency - Currency code (e.g., 'usd').
 * @param {"month" | "one_off"} interval - Billing interval.
 * @return {Promise<{productId: string, priceId: string}>} Stripe IDs.
 * @throws {Error} If Stripe API call fails.
 */
export async function createStripeProductAndPrice({
  name,
  price,
  currency,
  interval,
}: {
  name: string;
  price: number;
  currency: string;
  interval: "month" | "one_off";
}): Promise<{productId: string; priceId: string}> {
  const stripe = new Stripe(getEnvConfig().stripe.secretKey, {
    apiVersion: "2025-11-17.clover" as Stripe.LatestApiVersion,
  });

  try {
    // Create product
    const product = await stripe.products.create({
      name,
      active: true,
    });

    // Create price
    const priceParams: Stripe.PriceCreateParams = {
      product: product.id,
      unit_amount: price,
      currency: currency.toLowerCase(),
    };

    if (interval === "month") {
      priceParams.recurring = {
        interval: "month",
      };
    }

    const stripePrice = await stripe.prices.create(priceParams);

    return {
      productId: product.id,
      priceId: stripePrice.id,
    };
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : String(error);
    throw new Error(`Failed to create Stripe product/price: ${errorMessage}`);
  }
}

/**
 * Updates a Stripe product (name, metadata).
 * Note: Stripe prices are immutable - to change price, create new price.
 * @param {string} productId - Stripe product ID.
 * @param {string} name - New product name.
 * @return {Promise<void>} Resolves when updated.
 * @throws {Error} If Stripe API call fails.
 */
export async function updateStripeProduct(
  productId: string,
  name: string,
): Promise<void> {
  const stripe = new Stripe(getEnvConfig().stripe.secretKey, {
    apiVersion: "2025-11-17.clover" as Stripe.LatestApiVersion,
  });

  try {
    await stripe.products.update(productId, {
      name,
    });
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : String(error);
    throw new Error(`Failed to update Stripe product: ${errorMessage}`);
  }
}

/**
 * Archives a Stripe product (soft delete).
 * @param {string} productId - Stripe product ID.
 * @return {Promise<void>} Resolves when archived.
 * @throws {Error} If Stripe API call fails.
 */
export async function archiveStripeProduct(
  productId: string,
): Promise<void> {
  const stripe = new Stripe(getEnvConfig().stripe.secretKey, {
    apiVersion: "2025-11-17.clover" as Stripe.LatestApiVersion,
  });

  try {
    await stripe.products.update(productId, {
      active: false,
    });
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : String(error);
    throw new Error(`Failed to archive Stripe product: ${errorMessage}`);
  }
}

/**
 * Creates a new Stripe price for an existing product.
 * Used when updating plan price (prices are immutable).
 * @param {string} productId - Stripe product ID.
 * @param {number} price - Price in cents.
 * @param {string} currency - Currency code (e.g., 'usd').
 * @param {"month" | "one_off"} interval - Billing interval.
 * @return {Promise<string>} New Stripe price ID.
 * @throws {Error} If Stripe API call fails.
 */
export async function createStripePrice({
  productId,
  price,
  currency,
  interval,
}: {
  productId: string;
  price: number;
  currency: string;
  interval: "month" | "one_off";
}): Promise<string> {
  const stripe = new Stripe(getEnvConfig().stripe.secretKey, {
    apiVersion: "2025-11-17.clover" as Stripe.LatestApiVersion,
  });

  try {
    const priceParams: Stripe.PriceCreateParams = {
      product: productId,
      unit_amount: price,
      currency: currency.toLowerCase(),
    };

    if (interval === "month") {
      priceParams.recurring = {
        interval: "month",
      };
    }

    const stripePrice = await stripe.prices.create(priceParams);
    return stripePrice.id;
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : String(error);
    throw new Error(`Failed to create Stripe price: ${errorMessage}`);
  }
}


