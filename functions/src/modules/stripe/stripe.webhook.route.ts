import {onRequest} from "firebase-functions/v2/https";
import {
  processWebhookEvent,
  verifyWebhookSignature,
} from "./stripe.webhook.js";
import {stripeSecretKey, stripeWebhookSecret} from "../../config/env.js";

/**
 * Standalone Stripe webhook endpoint.
 * Handles raw request body for signature verification.
 *
 * This function is separate from the Express-based subscription API
 * to ensure proper raw body handling for Stripe signature verification.
 *
 * Webhook URL: /stripeWebhook
 */
export const stripeWebhook = onRequest(
  {
    cors: true,
    secrets: [stripeSecretKey, stripeWebhookSecret],
  },
  async (req, res) => {
    try {
      const signature = req.headers["stripe-signature"] as string;

      if (!signature) {
        res.status(400).json({message: "Missing stripe-signature header"});
        return;
      }

      // Get raw body for signature verification
      // In Firebase Functions v2, try multiple methods to access raw body
      let payload: string;

      // Method 1: Check if rawBody is available (Firebase Functions v2)
      interface RequestWithRawBody {
        rawBody?: Buffer;
      }
      const reqWithBody = req as RequestWithRawBody;
      if (reqWithBody.rawBody) {
        payload = reqWithBody.rawBody.toString("utf8");
      } else if (Buffer.isBuffer(req.body)) {
        // Method 2: Body is already a Buffer
        payload = req.body.toString("utf8");
      } else if (typeof req.body === "string") {
        // Method 3: Body is a string (shouldn't happen but handle it)
        payload = req.body;
      } else {
        // Unable to get raw body - log for debugging
        console.error("Webhook body type:", typeof req.body);
        console.error("Webhook body:", req.body);
        res.status(400).json({
          message: "Unable to get raw request body for signature verification",
        });
        return;
      }

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
        error.message?.includes("not found") ?
        400 :
        500;

      res.status(statusCode).json({
        message: error.message || "Webhook processing failed",
        received: false,
      });
    }
  },
);

