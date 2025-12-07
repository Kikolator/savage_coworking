import express, {Request, Response, Router} from "express";
import {onRequest, onCall} from "firebase-functions/v2/https";
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

const router = Router();

// Middleware for JSON parsing (except webhook which needs raw body)
router.use(express.json());

/**
 * Creates a checkout session for a subscription plan.
 * POST /api/subscriptions/checkout
 */
router.post("/checkout", async (req: Request, res: Response) => {
  try {
    const {userId, planId} = req.body;

    if (!userId || !planId) {
      res.status(400).json({
        message: "Missing required fields: userId and planId",
      });
      return;
    }

    // Get plan
    const plan = await subscriptionRepo.findPlanById(planId);
    if (!plan) {
      res.status(404).json({message: "PLAN_NOT_FOUND"});
      return;
    }

    if (!plan.isActive) {
      res.status(400).json({message: "PLAN_NOT_ACTIVE"});
      return;
    }

    // Check if user already has active subscription
    const existing = await subscriptionRepo.findActiveSubscriptionByUserId(
      userId,
    );
    if (existing) {
      res.status(409).json({message: "ACTIVE_SUBSCRIPTION_EXISTS"});
      return;
    }

    // Validate Stripe IDs
    if (plan.interval === "month" && !plan.stripePriceId) {
      res.status(400).json({
        message: "STRIPE_PRICE_ID_REQUIRED_FOR_RECURRING",
      });
      return;
    }

    if (plan.interval === "one_off" && !plan.stripePriceId) {
      res.status(400).json({
        message: "STRIPE_PRICE_ID_REQUIRED_FOR_ONE_OFF",
      });
      return;
    }

    // Get user email (you may need to fetch from Firestore users collection)
    // For now, we'll require it in the request or fetch from auth
    const customerEmail = req.body.customerEmail;
    if (!customerEmail) {
      res.status(400).json({message: "Missing customerEmail"});
      return;
    }

    // Build success and cancel URLs
    const baseUrl = req.body.baseUrl || "https://your-app.com";
    const successUrl = `${baseUrl}/subscriptions?checkout=success&session_id={CHECKOUT_SESSION_ID}`;
    const cancelUrl = `${baseUrl}/subscriptions?checkout=cancelled`;

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

    res.json(result);
  } catch (err: unknown) {
    const error = err as {statusCode?: number; message?: string};
    if (error.statusCode) {
      res.status(error.statusCode).json({message: error.message});
      return;
    }
    console.error("Error creating checkout session:", err);
    res.status(500).json({message: "INTERNAL_ERROR"});
  }
});

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

// Mount webhook router before main router to handle raw body
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
 * References Firebase Secrets for Stripe configuration.
 */
export const createCheckoutSession = onCall(
  {
    region: "us-central1",
    secrets: [stripeSecretKey],
  },
  async (request) => {
    const {userId, planId, customerEmail, baseUrl} = request.data as {
      userId: string;
      planId: string;
      customerEmail: string;
      baseUrl?: string;
    };

    if (!userId || !planId || !customerEmail) {
      throw new Error("Missing required fields: userId, planId, and customerEmail");
    }

    // Get plan
    const plan = await subscriptionRepo.findPlanById(planId);
    if (!plan) {
      throw new Error("PLAN_NOT_FOUND");
    }

    if (!plan.isActive) {
      throw new Error("PLAN_NOT_ACTIVE");
    }

    // Check if user already has active subscription
    const existing = await subscriptionRepo.findActiveSubscriptionByUserId(
      userId,
    );
    if (existing) {
      throw new Error("ACTIVE_SUBSCRIPTION_EXISTS");
    }

    // Validate Stripe IDs
    if (plan.interval === "month" && !plan.stripePriceId) {
      throw new Error("STRIPE_PRICE_ID_REQUIRED_FOR_RECURRING");
    }

    if (plan.interval === "one_off" && !plan.stripePriceId) {
      throw new Error("STRIPE_PRICE_ID_REQUIRED_FOR_ONE_OFF");
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

