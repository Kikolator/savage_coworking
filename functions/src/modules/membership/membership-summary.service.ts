import {db} from "../../config/firebaseAdmin.js";
import * as subscriptionRepo from "../subscription/subscription.repository.js";
import * as passBundleRepo from "../subscription/pass-bundle.repository.js";
import * as usageRepo from "../subscription/usage.repository.js";
import {
  MembershipSummary,
  PassBundle,
} from "../subscription/subscription.types.js";

const usersCol = () => db().collection("users");

/**
 * Calculates membership summary for a user.
 * Aggregates data from subscriptions, pass bundles, and usage.
 */
export async function calculateMembershipSummary(
  userId: string,
): Promise<MembershipSummary | null> {
  // Get active subscription
  const activeSubscription =
    await subscriptionRepo.findActiveSubscriptionByUserId(userId);

  // Get active pass bundles
  const activePassBundles = await passBundleRepo.findActivePassBundlesByUserId(
    userId,
  );

  // Calculate remaining daypass credits
  const remainingDayPassCredits = activePassBundles.reduce(
    (sum: number, bundle: PassBundle) => sum + bundle.remainingCredits,
    0,
  );

  // If no active subscription, return summary with only pass bundle info
  if (!activeSubscription) {
    return {
      remainingDayPassCredits:
        remainingDayPassCredits > 0 ? remainingDayPassCredits : undefined,
    };
  }

  // Get current period usage
  const currentUsage = await usageRepo.findUsageBySubscriptionAndPeriod(
    activeSubscription.id,
    activeSubscription.currentPeriodStart,
    activeSubscription.currentPeriodEnd,
  );

  // Calculate remaining minutes
  let deskMinutesRemaining: number | undefined;
  let meetingMinutesRemaining: number | undefined;

  const deskHoursPerPeriod =
    activeSubscription.effectiveQuota.deskHoursPerPeriod;
  const meetingHoursPerPeriod =
    activeSubscription.effectiveQuota.meetingHoursPerPeriod;

  if (deskHoursPerPeriod !== undefined && deskHoursPerPeriod > 0) {
    const deskMinutesUsed = currentUsage?.deskMinutesUsed ?? 0;
    const totalDeskMinutes = deskHoursPerPeriod * 60;
    deskMinutesRemaining = Math.max(0, totalDeskMinutes - deskMinutesUsed);
  } else {
    // Unlimited
    deskMinutesRemaining = undefined;
  }

  if (meetingHoursPerPeriod !== undefined && meetingHoursPerPeriod > 0) {
    const meetingMinutesUsed = currentUsage?.meetingMinutesUsed ?? 0;
    const totalMeetingMinutes = meetingHoursPerPeriod * 60;
    meetingMinutesRemaining = Math.max(
      0,
      totalMeetingMinutes - meetingMinutesUsed,
    );
  } else {
    // Unlimited
    meetingMinutesRemaining = undefined;
  }

  return {
    activeSubscriptionId: activeSubscription.id,
    planId: activeSubscription.planId,
    planName: activeSubscription.display.planName,
    status: activeSubscription.status,
    currentPeriodEnd: activeSubscription.currentPeriodEnd,
    deskMinutesRemaining,
    meetingMinutesRemaining,
    remainingDayPassCredits:
      remainingDayPassCredits > 0 ? remainingDayPassCredits : undefined,
    access: activeSubscription.effectiveQuota.access.type,
  };
}

/**
 * Updates user document with membership summary.
 */
export async function updateUserMembershipSummary(
  userId: string,
): Promise<void> {
  const summary = await calculateMembershipSummary(userId);

  const userRef = usersCol().doc(userId);
  const updateData: {membership?: MembershipSummary | null} = {};

  if (summary) {
    // Only set membership if there's meaningful data
    if (
      summary.activeSubscriptionId ||
      (summary.remainingDayPassCredits !== undefined &&
        summary.remainingDayPassCredits > 0)
    ) {
      updateData.membership = summary;
    } else {
      // Remove membership if user has no active subscription or pass bundles
      updateData.membership = null; // Firestore null
    }
  } else {
    // Remove membership
    updateData.membership = null; // Firestore null
  }

  await userRef.update(updateData);
}

