import {onCall, HttpsError} from "firebase-functions/v2/https";
import * as stripeService from "../stripe/stripe.service.js";
import * as subscriptionRepo from "./subscription.repository.js";
import * as subscriptionService from "./subscription.service.js";
import {CheckoutSessionParams} from "../stripe/stripe.types.js";
import {
  SubscriptionPlanCreateDto,
  SubscriptionPlanUpdateDto,
} from "./subscription.types.js";
import {stripeSecretKey} from "../../config/env.js";

/**
 * Note: Stripe webhook handling has been moved to a separate function
 * (stripeWebhook) to ensure proper raw body handling for signature
 * verification. See: functions/src/modules/stripe/stripe.webhook.route.ts
 */

/**
 * Callable function for creating a checkout session.
 * This is the preferred method for Flutter apps.
 *
 * Uses Firebase Auth to authenticate requests automatically.
 * References Firebase Secrets for Stripe configuration.
 */
export const createCheckoutSession = onCall(
  {
    region: "us-central1",
    secrets: [stripeSecretKey],
  },
  async (request) => {
    // Authentication check - user must be authenticated
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "The function must be called while authenticated.",
      );
    }

    const userId = request.auth.uid;
    const {planId, customerEmail, baseUrl} = request.data as {
      planId: string;
      customerEmail: string;
      baseUrl?: string;
    };

    if (!planId || !customerEmail) {
      throw new HttpsError(
        "invalid-argument",
        "Missing required fields: planId and customerEmail",
      );
    }

    // Get plan
    const plan = await subscriptionRepo.findPlanById(planId);
    if (!plan) {
      throw new HttpsError("not-found", "PLAN_NOT_FOUND");
    }

    if (!plan.isActive) {
      throw new HttpsError("failed-precondition", "PLAN_NOT_ACTIVE");
    }

    // Check if user already has active subscription
    const existing = await subscriptionRepo.findActiveSubscriptionByUserId(
      userId,
    );
    if (existing) {
      throw new HttpsError("already-exists", "ACTIVE_SUBSCRIPTION_EXISTS");
    }

    // Validate Stripe IDs
    const stripePriceId = plan.external?.stripePriceId;
    const stripeProductId = plan.external?.stripeProductId;

    if (plan.billing.type === "recurring" && !stripePriceId) {
      throw new HttpsError(
        "failed-precondition",
        "STRIPE_PRICE_ID_REQUIRED_FOR_RECURRING",
      );
    }

    if (plan.billing.type === "oneOff" && !stripePriceId) {
      throw new HttpsError(
        "failed-precondition",
        "STRIPE_PRICE_ID_REQUIRED_FOR_ONE_OFF",
      );
    }

    // Build success and cancel URLs
    const defaultBaseUrl = baseUrl || "https://your-app.com";
    const successUrl =
      `${defaultBaseUrl}/subscriptions?checkout=success&` +
      "session_id={CHECKOUT_SESSION_ID}";
    const cancelUrl = `${defaultBaseUrl}/subscriptions?checkout=cancelled`;

    // Create checkout session
    const params: CheckoutSessionParams = {
      userId,
      planId,
      customerEmail,
      successUrl,
      cancelUrl,
      stripePriceId: stripePriceId!,
      stripeProductId: stripeProductId!,
      mode: plan.billing.type === "recurring" ? "subscription" : "payment",
    };

    const result = await stripeService.createCheckoutSession(params);

    return result;
  },
);

/**
 * Callable function for creating a subscription plan (admin only).
 * Auto-creates Stripe product and price if not provided.
 */
export const createPlan = onCall(
  {
    region: "us-central1",
    secrets: [stripeSecretKey],
  },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "The function must be called while authenticated.",
      );
    }

    // Check admin role
    const isAdmin = request.auth.token.admin === true;
    if (!isAdmin) {
      throw new HttpsError(
        "permission-denied",
        "Only admins can create plans.",
      );
    }

    const dto = request.data as SubscriptionPlanCreateDto;
    const plan = await subscriptionService.createPlan(dto);
    return plan;
  },
);

/**
 * Callable function for updating a subscription plan (admin only).
 * Handles Stripe resource updates (new prices, product name changes).
 */
export const updatePlan = onCall(
  {
    region: "us-central1",
    secrets: [stripeSecretKey],
  },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "The function must be called while authenticated.",
      );
    }

    const isAdmin = request.auth.token.admin === true;
    if (!isAdmin) {
      throw new HttpsError(
        "permission-denied",
        "Only admins can update plans.",
      );
    }

    const {planId, ...dto} = request.data as {
      planId: string;
    } & SubscriptionPlanUpdateDto;

    if (!planId) {
      throw new HttpsError(
        "invalid-argument",
        "planId is required",
      );
    }

    const plan = await subscriptionService.updatePlan(planId, dto);
    return plan;
  },
);

/**
 * Callable function for deleting a subscription plan (admin only).
 * Checks for active subscriptions and archives Stripe product.
 */
export const deletePlan = onCall(
  {
    region: "us-central1",
    secrets: [stripeSecretKey],
  },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "The function must be called while authenticated.",
      );
    }

    const isAdmin = request.auth.token.admin === true;
    if (!isAdmin) {
      throw new HttpsError(
        "permission-denied",
        "Only admins can delete plans.",
      );
    }

    const {planId} = request.data as {planId: string};
    if (!planId) {
      throw new HttpsError(
        "invalid-argument",
        "planId is required",
      );
    }

    await subscriptionService.deletePlan(planId);
    return {success: true};
  },
);

