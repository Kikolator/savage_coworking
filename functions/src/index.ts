import {setGlobalOptions} from "firebase-functions/v2";
import {logDocumentChanges} from "./modules/change-log/changeLog.trigger";
import {
  createCheckoutSession,
  createPlan,
  updatePlan,
  deletePlan,
} from "./modules/subscription/subscription.routes";
import {stripeWebhook} from "./modules/stripe/stripe.webhook.route";
import {
  onSubscriptionChange,
  onPassBundleChange,
  onUsageChange,
} from "./modules/membership/membership-summary.trigger";
import {setAdminClaim} from "./modules/admin/admin.claims";

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
