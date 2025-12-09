import {setGlobalOptions} from "firebase-functions/v2";

// Set global options BEFORE importing functions
// Functions are created at import time, so this must happen first
setGlobalOptions({
  maxInstances: 10,
  region: "europe-west1",
});

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
