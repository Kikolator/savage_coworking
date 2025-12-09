import {setGlobalOptions} from "firebase-functions/v2";
import {logDocumentChanges} from "./modules/change-log/changeLog.trigger.js";
import {
  createCheckoutSession,
  createPlan,
  updatePlan,
  deletePlan,
} from "./modules/subscription/subscription.routes.js";
import {stripeWebhook} from "./modules/stripe/stripe.webhook.route.js";
import {
  onSubscriptionChange,
  onPassBundleChange,
  onUsageChange,
} from "./modules/membership/membership-summary.trigger.js";
import {setAdminClaim} from "./modules/admin/admin.claims.js";

setGlobalOptions({
  maxInstances: 10,
  region: "us-central1",
});

export {
  logDocumentChanges,
  createCheckoutSession,
  createPlan,
  updatePlan,
  deletePlan,
  stripeWebhook,
  onSubscriptionChange,
  onPassBundleChange,
  onUsageChange,
  setAdminClaim,
};
