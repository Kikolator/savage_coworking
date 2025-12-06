import Stripe from "stripe";
import {Timestamp} from "firebase-admin/firestore";
import {getEnvConfig} from "../../config/env";
import * as subscriptionService from "../subscription/subscription.service";
import * as subscriptionRepo from "../subscription/subscription.repository";
import {SubscriptionInterval} from "../subscription/subscription.types";

/**
 * Calculates period start and end dates based on interval.
 * @param {SubscriptionInterval} interval - Subscription interval.
 * @return {{start: Timestamp, end: Timestamp}} Period dates.
 */
function calculatePeriodDates(interval: SubscriptionInterval): {
  start: Timestamp;
  end: Timestamp;
} {
  const now = new Date();
  const start = Timestamp.fromDate(now);

  let endDate: Date;
  if (interval === "month") {
    endDate = new Date(now);
    endDate.setMonth(endDate.getMonth() + 1);
  } else {
    // For one-off, set end date far in the future or based on plan
    // For now, set to 1 year from now
    endDate = new Date(now);
    endDate.setFullYear(endDate.getFullYear() + 1);
  }

  const end = Timestamp.fromDate(endDate);
  return {start, end};
}

/**
 * Handles checkout.session.completed event.
 * @param {Stripe.Checkout.Session} session - Stripe checkout session.
 * @return {Promise<void>} Resolves when handled.
 */
async function handleCheckoutSessionCompleted(
  session: Stripe.Checkout.Session,
): Promise<void> {
  const userId = session.metadata?.userId;
  const planId = session.metadata?.planId;

  if (!userId || !planId) {
    throw new Error("Missing userId or planId in checkout session metadata");
  }

  // Get plan to determine interval
  const plan = await subscriptionRepo.findPlanById(planId);
  if (!plan) {
    throw new Error(`Plan ${planId} not found`);
  }

  // Get customer ID
  const customerId =
    typeof session.customer === "string"
      ? session.customer
      : session.customer?.id;

  if (!customerId) {
    throw new Error("Missing customer ID in checkout session");
  }

  const {start, end} = calculatePeriodDates(plan.interval);

  // Build subscription DTO
  const subscriptionDto: Parameters<
    typeof subscriptionService.createSubscription
  >[0] = {
    userId,
    planId,
    stripeCustomerId: customerId,
    currentPeriodStart: start,
    currentPeriodEnd: end,
  };

  // Add Stripe IDs based on mode
  if (session.mode === "subscription" && session.subscription) {
    const subscriptionId =
      typeof session.subscription === "string"
        ? session.subscription
        : session.subscription.id;
    subscriptionDto.stripeSubscriptionId = subscriptionId;
  } else if (session.mode === "payment" && session.payment_intent) {
    const paymentIntentId =
      typeof session.payment_intent === "string"
        ? session.payment_intent
        : session.payment_intent.id;
    subscriptionDto.stripePaymentIntentId = paymentIntentId;
  }

  // Create subscription (service will validate and check for existing)
  await subscriptionService.createSubscription(subscriptionDto);
}

/**
 * Handles customer.subscription.updated event.
 * @param {Stripe.Subscription} subscription - Stripe subscription.
 * @return {Promise<void>} Resolves when handled.
 */
async function handleSubscriptionUpdated(
  subscription: Stripe.Subscription,
): Promise<void> {
  const existing = await subscriptionRepo.findSubscriptionByStripeSubscriptionId(
    subscription.id,
  );

  if (!existing) {
    // Subscription not found, might be from another system
    return;
  }

  const updates: Parameters<typeof subscriptionRepo.updateSubscription>[1] = {};

  // Update status based on Stripe subscription status
  if (subscription.status === "active") {
    updates.status = "active";
  } else if (subscription.status === "past_due") {
    updates.status = "past_due";
  } else if (subscription.status === "canceled") {
    updates.status = "cancelled";
  } else if (subscription.status === "unpaid") {
    updates.status = "expired";
  }

  // Update period dates
  if (subscription.current_period_start && subscription.current_period_end) {
    updates.currentPeriodStart = Timestamp.fromMillis(
      subscription.current_period_start * 1000,
    );
    updates.currentPeriodEnd = Timestamp.fromMillis(
      subscription.current_period_end * 1000,
    );
  }

  // Update cancel at period end
  if (subscription.cancel_at_period_end !== undefined) {
    updates.cancelAtPeriodEnd = subscription.cancel_at_period_end;
  }

  await subscriptionRepo.updateSubscription(existing.id, updates);
}

/**
 * Handles customer.subscription.deleted event.
 * @param {Stripe.Subscription} subscription - Stripe subscription.
 * @return {Promise<void>} Resolves when handled.
 */
async function handleSubscriptionDeleted(
  subscription: Stripe.Subscription,
): Promise<void> {
  const existing = await subscriptionRepo.findSubscriptionByStripeSubscriptionId(
    subscription.id,
  );

  if (!existing) {
    return;
  }

  await subscriptionRepo.updateSubscription(existing.id, {
    status: "cancelled",
    cancelAtPeriodEnd: false,
  });
}

/**
 * Processes a Stripe webhook event.
 * @param {Stripe.Event} event - Stripe webhook event.
 * @return {Promise<void>} Resolves when processed.
 */
export async function processWebhookEvent(
  event: Stripe.Event,
): Promise<void> {
  switch (event.type) {
    case "checkout.session.completed": {
      const session = event.data.object as Stripe.Checkout.Session;
      await handleCheckoutSessionCompleted(session);
      break;
    }
    case "customer.subscription.updated": {
      const subscription = event.data.object as Stripe.Subscription;
      await handleSubscriptionUpdated(subscription);
      break;
    }
    case "customer.subscription.deleted": {
      const subscription = event.data.object as Stripe.Subscription;
      await handleSubscriptionDeleted(subscription);
      break;
    }
    default:
      // Ignore other event types
      break;
  }
}

/**
 * Verifies a Stripe webhook signature.
 * @param {string} payload - Raw request body.
 * @param {string} signature - Stripe signature header.
 * @return {Stripe.Event} Verified Stripe event.
 * @throws {Error} If signature verification fails.
 */
export function verifyWebhookSignature(
  payload: string,
  signature: string,
): Stripe.Event {
  const stripe = new Stripe(getEnvConfig().stripe.secretKey, {
    apiVersion: "2025-02-24.acacia",
  });

  try {
    const event = stripe.webhooks.constructEvent(
      payload,
      signature,
      getEnvConfig().stripe.webhookSecret,
    );
    return event;
  } catch (err) {
    throw new Error(`Webhook signature verification failed: ${err}`);
  }
}

