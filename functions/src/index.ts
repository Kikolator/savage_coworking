import {setGlobalOptions} from "firebase-functions/v2";
import {logDocumentChanges} from "./modules/change-log/changeLog.trigger";
import {
  subscriptionApi,
  createCheckoutSession,
  createPlan,
  updatePlan,
  deletePlan,
} from "./modules/subscription/subscription.routes";

setGlobalOptions({
  maxInstances: 10,
  region: "us-central1",
});

export {
  logDocumentChanges,
  subscriptionApi,
  createCheckoutSession,
  createPlan,
  updatePlan,
  deletePlan,
};
