import {Timestamp} from "firebase-admin/firestore";
import {db} from "../../config/firebaseAdmin";
import {
  SUBSCRIPTIONS_COLLECTION,
  SUBSCRIPTION_PLANS_COLLECTION,
  Subscription,
  SubscriptionCreateDto,
  SubscriptionPlan,
  SubscriptionPlanCreateDto,
  SubscriptionUpdateDto,
  SubscriptionPlanUpdateDto,
} from "./subscription.types";

const subscriptionsCol = () => db().collection(SUBSCRIPTIONS_COLLECTION);
const plansCol = () => db().collection(SUBSCRIPTION_PLANS_COLLECTION);

// Subscription repository functions
/**
 * Finds a subscription by ID.
 * @param {string} id - Subscription ID.
 * @return {Promise<Subscription | null>} Subscription or null.
 */
export async function findSubscriptionById(
  id: string,
): Promise<Subscription | null> {
  const doc = await subscriptionsCol().doc(id).get();
  if (!doc.exists) return null;
  return {id: doc.id, ...(doc.data() as Omit<Subscription, "id">)};
}

/**
 * Finds all subscriptions for a user.
 * @param {string} userId - User ID.
 * @return {Promise<Subscription[]>} Array of subscriptions.
 */
export async function findSubscriptionsByUserId(
  userId: string,
): Promise<Subscription[]> {
  const snap = await subscriptionsCol()
    .where("userId", "==", userId)
    .orderBy("createdAt", "desc")
    .get();
  return snap.docs.map((doc) => ({
    id: doc.id,
    ...(doc.data() as Omit<Subscription, "id">),
  }));
}

/**
 * Finds the active subscription for a user.
 * @param {string} userId - User ID.
 * @return {Promise<Subscription | null>} Active subscription or null.
 */
export async function findActiveSubscriptionByUserId(
  userId: string,
): Promise<Subscription | null> {
  const snap = await subscriptionsCol()
    .where("userId", "==", userId)
    .where("status", "==", "active")
    .limit(1)
    .get();
  if (snap.empty) return null;
  const doc = snap.docs[0];
  return {id: doc.id, ...(doc.data() as Omit<Subscription, "id">)};
}

/**
 * Finds a subscription by Stripe subscription ID.
 * @param {string} stripeSubscriptionId - Stripe subscription ID.
 * @return {Promise<Subscription | null>} Subscription or null.
 */
export async function findSubscriptionByStripeSubscriptionId(
  stripeSubscriptionId: string,
): Promise<Subscription | null> {
  const snap = await subscriptionsCol()
    .where("stripeSubscriptionId", "==", stripeSubscriptionId)
    .limit(1)
    .get();
  if (snap.empty) return null;
  const doc = snap.docs[0];
  return {id: doc.id, ...(doc.data() as Omit<Subscription, "id">)};
}

/**
 * Creates a new subscription.
 * @param {SubscriptionCreateDto} dto - Subscription creation data.
 * @param {SubscriptionPlan} plan - Subscription plan.
 * @return {Promise<Subscription>} Created subscription.
 */
export async function createSubscription(
  dto: SubscriptionCreateDto,
  plan: SubscriptionPlan,
): Promise<Subscription> {
  const now = Timestamp.now();
  const subscription: Omit<Subscription, "id"> = {
    userId: dto.userId,
    planId: dto.planId,
    planName: plan.name,
    status: "trial",
    stripeCustomerId: dto.stripeCustomerId,
    renewsAutomatically: plan.interval === "month",
    currentPeriodStart: dto.currentPeriodStart,
    currentPeriodEnd: dto.currentPeriodEnd,
    cancelAtPeriodEnd: false,
    deskHours: plan.deskHours,
    meetingRoomHours: plan.meetingRoomHours,
    deskHoursUsed: 0,
    meetingRoomHoursUsed: 0,
    createdAt: now,
    updatedAt: now,
  };

  if (dto.stripeSubscriptionId) {
    subscription.stripeSubscriptionId = dto.stripeSubscriptionId;
  }

  if (dto.stripePaymentIntentId) {
    subscription.stripePaymentIntentId = dto.stripePaymentIntentId;
  }

  const docRef = await subscriptionsCol().add(subscription);
  return {id: docRef.id, ...subscription};
}

/**
 * Updates a subscription.
 * @param {string} id - Subscription ID.
 * @param {SubscriptionUpdateDto} dto - Update data.
 * @return {Promise<Subscription>} Updated subscription.
 */
export async function updateSubscription(
  id: string,
  dto: SubscriptionUpdateDto,
): Promise<Subscription> {
  const ref = subscriptionsCol().doc(id);
  const updateData: Partial<Subscription> = {
    ...dto,
    updatedAt: Timestamp.now(),
  };
  await ref.update(updateData);
  const updated = await ref.get();
  if (!updated.exists) {
    throw new Error("Subscription not found after update");
  }
  return {id: updated.id, ...(updated.data() as Omit<Subscription, "id">)};
}

/**
 * Deletes a subscription.
 * @param {string} id - Subscription ID.
 * @return {Promise<void>} Resolves when deleted.
 */
export async function deleteSubscription(id: string): Promise<void> {
  await subscriptionsCol().doc(id).delete();
}

// Subscription Plan repository functions
/**
 * Finds a subscription plan by ID.
 * @param {string} id - Plan ID.
 * @return {Promise<SubscriptionPlan | null>} Plan or null.
 */
export async function findPlanById(
  id: string,
): Promise<SubscriptionPlan | null> {
  const doc = await plansCol().doc(id).get();
  if (!doc.exists) return null;
  return {id: doc.id, ...(doc.data() as Omit<SubscriptionPlan, "id">)};
}

/**
 * Finds all active subscription plans.
 * @return {Promise<SubscriptionPlan[]>} Array of active plans.
 */
export async function findActivePlans(): Promise<SubscriptionPlan[]> {
  const snap = await plansCol()
    .where("isActive", "==", true)
    .orderBy("price", "asc")
    .get();
  return snap.docs.map((doc) => ({
    id: doc.id,
    ...(doc.data() as Omit<SubscriptionPlan, "id">),
  }));
}

/**
 * Finds all subscription plans.
 * @return {Promise<SubscriptionPlan[]>} Array of all plans.
 */
export async function findAllPlans(): Promise<SubscriptionPlan[]> {
  const snap = await plansCol().orderBy("createdAt", "desc").get();
  return snap.docs.map((doc) => ({
    id: doc.id,
    ...(doc.data() as Omit<SubscriptionPlan, "id">),
  }));
}

/**
 * Finds a subscription plan by Stripe Price ID.
 * @param {string} stripePriceId - Stripe Price ID.
 * @return {Promise<SubscriptionPlan | null>} Plan or null.
 */
export async function findPlanByStripePriceId(
  stripePriceId: string,
): Promise<SubscriptionPlan | null> {
  const snap = await plansCol()
    .where("stripePriceId", "==", stripePriceId)
    .limit(1)
    .get();
  if (snap.empty) return null;
  const doc = snap.docs[0];
  return {id: doc.id, ...(doc.data() as Omit<SubscriptionPlan, "id">)};
}

/**
 * Creates a new subscription plan.
 * @param {SubscriptionPlanCreateDto} dto - Plan creation data.
 * @return {Promise<SubscriptionPlan>} Created plan.
 */
export async function createPlan(
  dto: SubscriptionPlanCreateDto,
): Promise<SubscriptionPlan> {
  const now = Timestamp.now();
  const plan: Omit<SubscriptionPlan, "id"> = {
    ...dto,
    createdAt: now,
    updatedAt: now,
  };
  const docRef = await plansCol().add(plan);
  return {id: docRef.id, ...plan};
}

/**
 * Updates a subscription plan.
 * @param {string} id - Plan ID.
 * @param {SubscriptionPlanUpdateDto} dto - Update data.
 * @return {Promise<SubscriptionPlan>} Updated plan.
 */
export async function updatePlan(
  id: string,
  dto: SubscriptionPlanUpdateDto,
): Promise<SubscriptionPlan> {
  const ref = plansCol().doc(id);
  const updateData: Partial<SubscriptionPlan> = {
    ...dto,
    updatedAt: Timestamp.now(),
  };
  await ref.update(updateData);
  const updated = await ref.get();
  if (!updated.exists) {
    throw new Error("Subscription plan not found after update");
  }
  return {id: updated.id, ...(updated.data() as Omit<SubscriptionPlan, "id">)};
}

/**
 * Deletes a subscription plan.
 * @param {string} id - Plan ID.
 * @return {Promise<void>} Resolves when deleted.
 */
export async function deletePlan(id: string): Promise<void> {
  await plansCol().doc(id).delete();
}
