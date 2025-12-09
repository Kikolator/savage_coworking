import {onDocumentWritten} from "firebase-functions/v2/firestore";
import {updateUserMembershipSummary} from "./membership-summary.service.js";

/**
 * Trigger to update membership summary when subscription changes.
 */
export const onSubscriptionChange = onDocumentWritten(
  {
    document: "subscriptions/{subscriptionId}",
    region: "europe-west1",
  },
  async (event) => {
    const subscriptionData = event.data?.after?.data();
    if (!subscriptionData) {
      // Document was deleted, update summary
      const beforeData = event.data?.before?.data();
      if (beforeData?.userId) {
        await updateUserMembershipSummary(beforeData.userId);
      }
      return;
    }

    const userId = subscriptionData.userId;
    if (!userId) {
      console.error("Subscription document missing userId");
      return;
    }

    await updateUserMembershipSummary(userId);
  },
);

/**
 * Trigger to update membership summary when pass bundle changes.
 */
export const onPassBundleChange = onDocumentWritten(
  {
    document: "passBundles/{bundleId}",
    region: "europe-west1",
  },
  async (event) => {
    const bundleData = event.data?.after?.data();
    if (!bundleData) {
      // Document was deleted, update summary
      const beforeData = event.data?.before?.data();
      if (beforeData?.userId) {
        await updateUserMembershipSummary(beforeData.userId);
      }
      return;
    }

    const userId = bundleData.userId;
    if (!userId) {
      console.error("Pass bundle document missing userId");
      return;
    }

    await updateUserMembershipSummary(userId);
  },
);

/**
 * Trigger to update membership summary when usage changes.
 */
export const onUsageChange = onDocumentWritten(
  {
    document: "usage/{usageId}",
    region: "europe-west1",
  },
  async (event) => {
    const usageData = event.data?.after?.data();
    if (!usageData) {
      // Document was deleted, but we don't need to update summary
      return;
    }

    const userId = usageData.userId;
    if (!userId) {
      console.error("Usage document missing userId");
      return;
    }

    // Only update if this usage is for a subscription (not pass bundle)
    // Pass bundle usage doesn't affect membership summary
    if (usageData.subscriptionId) {
      await updateUserMembershipSummary(userId);
    }
  },
);

