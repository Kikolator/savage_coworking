import express, {Request, Response, Router} from "express";
import {onRequest, onCall, HttpsError} from "firebase-functions/v2/https";
import * as stripeService from "../stripe/stripe.service";
import {
  processWebhookEvent,
  verifyWebhookSignature,
} from "../stripe/stripe.webhook";
import * as subscriptionRepo from "./subscription.repository";
import {CheckoutSessionParams} from "../stripe/stripe.types";
import {
  stripeSecretKey,
  stripeWebhookSecret,
} from "../../config/env";

/**
 * Handles Stripe webhook events.
 * POST /api/subscriptions/webhook
 * Note: This route needs raw body for signature verification.
 * Firebase Functions v2 provides raw body in req.rawBody if configured.
 */
const webhookRouter = Router();
webhookRouter.use(express.raw({type: "application/json"}));
webhookRouter.post("/webhook", async (req: Request, res: Response) => {
  try {
    const signature = req.headers["stripe-signature"] as string;

    if (!signature) {
      res.status(400).json({message: "Missing stripe-signature header"});
      return;
    }

    // Get raw body for signature verification
    // In Firebase Functions v2, raw body is available as Buffer
    const rawBody = req.body as Buffer;
    if (!rawBody) {
      res.status(400).json({message: "Missing request body"});
      return;
    }

    const payload = rawBody.toString("utf8");

    // Verify webhook signature
    const event = verifyWebhookSignature(payload, signature);

    // Process webhook event
    await processWebhookEvent(event);

    res.json({received: true});
  } catch (err: unknown) {
    // Enhanced error logging with event context
    const error = err as {message?: string; code?: string};
    console.error("Webhook processing error:", {
      message: error.message,
      code: error.code,
      error: err,
    });
    
    // Return appropriate status code
    // 400 for client errors (bad request, validation), 500 for server errors
    const statusCode = error.code === "ACTIVE_SUBSCRIPTION_EXISTS" ||
      error.code === "PLAN_NOT_FOUND" ||
      error.message?.includes("Missing") ||
      error.message?.includes("not found")
      ? 400
      : 500;
    
    res.status(statusCode).json({
      message: error.message || "Webhook processing failed",
      received: false,
    });
  }
});

// Create router for webhook only
const router = Router();
router.use(webhookRouter);

/**
 * HTTP function for subscription routes.
 * Webhook endpoint requires Stripe secrets for signature verification.
 */
export const subscriptionApi = onRequest(
  {
    cors: true,
    region: "us-central1",
    secrets: [stripeSecretKey, stripeWebhookSecret],
  },
  (req, res) => {
    router(req, res, () => {
      res.status(404).json({message: "Route not found"});
    });
  },
);

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
    if (plan.interval === "month" && !plan.stripePriceId) {
      throw new HttpsError(
        "failed-precondition",
        "STRIPE_PRICE_ID_REQUIRED_FOR_RECURRING",
      );
    }

    if (plan.interval === "one_off" && !plan.stripePriceId) {
      throw new HttpsError(
        "failed-precondition",
        "STRIPE_PRICE_ID_REQUIRED_FOR_ONE_OFF",
      );
    }

    // Build success and cancel URLs
    const defaultBaseUrl = baseUrl || "https://your-app.com";
    const successUrl = `${defaultBaseUrl}/subscriptions?checkout=success&session_id={CHECKOUT_SESSION_ID}`;
    const cancelUrl = `${defaultBaseUrl}/subscriptions?checkout=cancelled`;

    // Create checkout session
    const params: CheckoutSessionParams = {
      userId,
      planId,
      customerEmail,
      successUrl,
      cancelUrl,
      stripePriceId: plan.stripePriceId,
      stripeProductId: plan.stripeProductId,
      mode: plan.interval === "month" ? "subscription" : "payment",
    };

    const result = await stripeService.createCheckoutSession(params);

    return result;
  },
);

