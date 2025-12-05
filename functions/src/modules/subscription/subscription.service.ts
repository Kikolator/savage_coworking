import * as subscriptionRepo from "./subscription.repository";
import {
  Subscription,
  SubscriptionCreateDto,
  SubscriptionUpdateDto,
  SubscriptionPlan,
  SubscriptionPlanCreateDto,
  SubscriptionPlanUpdateDto,
  SubscriptionStatus,
} from "./subscription.types";

/**
 * Error thrown when subscription is not found.
 */
export class SubscriptionNotFoundError extends Error {
  /** HTTP status code for this error. */
  statusCode = 404;
  /** Creates a new SubscriptionNotFoundError. */
  constructor() {
    super("SUBSCRIPTION_NOT_FOUND");
  }
}

/**
 * Error thrown when plan is not found.
 */
export class PlanNotFoundError extends Error {
  /** HTTP status code for this error. */
  statusCode = 404;
  /** Creates a new PlanNotFoundError. */
  constructor() {
    super("PLAN_NOT_FOUND");
  }
}

/**
 * Error thrown when user already has an active subscription.
 */
export class ActiveSubscriptionExistsError extends Error {
  /** HTTP status code for this error. */
  statusCode = 409;
  /** Creates a new ActiveSubscriptionExistsError. */
  constructor() {
    super("ACTIVE_SUBSCRIPTION_EXISTS");
  }
}

/**
 * Error thrown when status transition is invalid.
 */
export class InvalidStatusTransitionError extends Error {
  /** HTTP status code for this error. */
  statusCode = 400;
  /**
   * @param {SubscriptionStatus} from - Current status.
   * @param {SubscriptionStatus} to - Target status.
   */
  constructor(from: SubscriptionStatus, to: SubscriptionStatus) {
    super(`INVALID_STATUS_TRANSITION: ${from} -> ${to}`);
  }
}

/**
 * Error thrown when hours usage exceeds limits.
 */
export class HoursExceededError extends Error {
  /** HTTP status code for this error. */
  statusCode = 400;
  /**
   * @param {"desk" | "meetingRoom"} type - Type of hours exceeded.
   */
  constructor(type: "desk" | "meetingRoom") {
    super(`${type.toUpperCase()}_HOURS_EXCEEDED`);
  }
}

/**
 * Error thrown when plan name is already taken.
 */
export class PlanNameTakenError extends Error {
  /** HTTP status code for this error. */
  statusCode = 409;
  /** Creates a new PlanNameTakenError. */
  constructor() {
    super("PLAN_NAME_TAKEN");
  }
}

/**
 * Validates that a status transition is allowed.
 * @param {SubscriptionStatus} from - Current status.
 * @param {SubscriptionStatus} to - Target status.
 * @return {boolean} True if transition is valid.
 */
function isValidStatusTransition(
  from: SubscriptionStatus,
  to: SubscriptionStatus,
): boolean {
  if (from === to) return true;

  const validTransitions: Record<SubscriptionStatus, SubscriptionStatus[]> = {
    trial: ["active", "cancelled"],
    active: ["past_due", "cancelled", "expired"],
    past_due: ["active", "cancelled", "expired"],
    cancelled: ["expired"],
    expired: [],
  };

  return validTransitions[from]?.includes(to) ?? false;
}

/**
 * Validates that hours usage doesn't exceed limits.
 * @param {number} deskHours - Allocated desk hours.
 * @param {number} deskHoursUsed - Used desk hours.
 * @param {number} meetingRoomHours - Allocated meeting room hours.
 * @param {number} meetingRoomHoursUsed - Used meeting room hours.
 * @return {void}
 */
function validateHoursUsage(
  deskHours: number,
  deskHoursUsed: number,
  meetingRoomHours: number,
  meetingRoomHoursUsed: number,
): void {
  if (deskHours > 0 && deskHoursUsed > deskHours) {
    throw new HoursExceededError("desk");
  }
  if (meetingRoomHours > 0 && meetingRoomHoursUsed > meetingRoomHours) {
    throw new HoursExceededError("meetingRoom");
  }
}

// Subscription service functions
/**
 * Creates a new subscription.
 * @param {SubscriptionCreateDto} dto - Subscription creation data.
 * @return {Promise<Subscription>} Created subscription.
 */
export async function createSubscription(
  dto: SubscriptionCreateDto,
): Promise<Subscription> {
  // Check if plan exists
  const plan = await subscriptionRepo.findPlanById(dto.planId);
  if (!plan) {
    throw new PlanNotFoundError();
  }

  if (!plan.isActive) {
    throw new Error("PLAN_NOT_ACTIVE");
  }

  // Check if user already has an active subscription
  const existing = await subscriptionRepo.findActiveSubscriptionByUserId(
    dto.userId,
  );
  if (existing) {
    throw new ActiveSubscriptionExistsError();
  }

  // Validate Stripe IDs based on plan type
  if (plan.interval === "month" && !dto.stripeSubscriptionId) {
    throw new Error("STRIPE_SUBSCRIPTION_ID_REQUIRED_FOR_RECURRING");
  }

  if (plan.interval === "one_off" && !dto.stripePaymentIntentId) {
    throw new Error("STRIPE_PAYMENT_INTENT_ID_REQUIRED_FOR_ONE_OFF");
  }

  return subscriptionRepo.createSubscription(dto, plan);
}

/**
 * Gets a subscription by ID.
 * @param {string} id - Subscription ID.
 * @return {Promise<Subscription | null>} Subscription or null.
 */
export async function getSubscription(
  id: string,
): Promise<Subscription | null> {
  return subscriptionRepo.findSubscriptionById(id);
}

/**
 * Gets all subscriptions for a user.
 * @param {string} userId - User ID.
 * @return {Promise<Subscription[]>} Array of subscriptions.
 */
export async function getSubscriptionsByUserId(
  userId: string,
): Promise<Subscription[]> {
  return subscriptionRepo.findSubscriptionsByUserId(userId);
}

/**
 * Gets the active subscription for a user.
 * @param {string} userId - User ID.
 * @return {Promise<Subscription | null>} Active subscription or null.
 */
export async function getActiveSubscriptionByUserId(
  userId: string,
): Promise<Subscription | null> {
  return subscriptionRepo.findActiveSubscriptionByUserId(userId);
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
  const existing = await subscriptionRepo.findSubscriptionById(id);
  if (!existing) {
    throw new SubscriptionNotFoundError();
  }

  // Validate status transition if status is being updated
  if (dto.status && dto.status !== existing.status) {
    if (!isValidStatusTransition(existing.status, dto.status)) {
      throw new InvalidStatusTransitionError(existing.status, dto.status);
    }
  }

  // Validate hours usage if being updated
  const deskHours = dto.deskHoursUsed ?? existing.deskHoursUsed;
  const meetingRoomHours =
    dto.meetingRoomHoursUsed ?? existing.meetingRoomHoursUsed;

  validateHoursUsage(
    existing.deskHours,
    deskHours,
    existing.meetingRoomHours,
    meetingRoomHours,
  );

  return subscriptionRepo.updateSubscription(id, dto);
}

/**
 * Cancels a subscription.
 * @param {string} id - Subscription ID.
 * @param {boolean} cancelAtPeriodEnd - Whether to cancel at period end.
 * @return {Promise<Subscription>} Updated subscription.
 */
export async function cancelSubscription(
  id: string,
  cancelAtPeriodEnd: boolean,
): Promise<Subscription> {
  const existing = await subscriptionRepo.findSubscriptionById(id);
  if (!existing) {
    throw new SubscriptionNotFoundError();
  }

  if (cancelAtPeriodEnd) {
    return subscriptionRepo.updateSubscription(id, {
      cancelAtPeriodEnd: true,
    });
  } else {
    return subscriptionRepo.updateSubscription(id, {
      status: "cancelled",
      cancelAtPeriodEnd: false,
    });
  }
}

/**
 * Updates subscription hours usage.
 * @param {string} id - Subscription ID.
 * @param {number} deskHoursUsed - Used desk hours.
 * @param {number} meetingRoomHoursUsed - Used meeting room hours.
 * @return {Promise<Subscription>} Updated subscription.
 */
export async function updateSubscriptionHours(
  id: string,
  deskHoursUsed: number,
  meetingRoomHoursUsed: number,
): Promise<Subscription> {
  const existing = await subscriptionRepo.findSubscriptionById(id);
  if (!existing) {
    throw new SubscriptionNotFoundError();
  }

  validateHoursUsage(
    existing.deskHours,
    deskHoursUsed,
    existing.meetingRoomHours,
    meetingRoomHoursUsed,
  );

  return subscriptionRepo.updateSubscription(id, {
    deskHoursUsed,
    meetingRoomHoursUsed,
  });
}

/**
 * Deletes a subscription.
 * @param {string} id - Subscription ID.
 * @return {Promise<void>} Resolves when deleted.
 */
export async function deleteSubscription(id: string): Promise<void> {
  const existing = await subscriptionRepo.findSubscriptionById(id);
  if (!existing) {
    throw new SubscriptionNotFoundError();
  }
  return subscriptionRepo.deleteSubscription(id);
}

// Subscription Plan service functions
/**
 * Creates a new subscription plan.
 * @param {SubscriptionPlanCreateDto} dto - Plan creation data.
 * @return {Promise<SubscriptionPlan>} Created plan.
 */
export async function createPlan(
  dto: SubscriptionPlanCreateDto,
): Promise<SubscriptionPlan> {
  // Check if plan name is already taken
  const allPlans = await subscriptionRepo.findAllPlans();
  const nameExists = allPlans.some((plan) => plan.name === dto.name);
  if (nameExists) {
    throw new PlanNameTakenError();
  }

  // Validate Stripe IDs based on interval
  if (dto.interval === "month" && !dto.stripePriceId) {
    throw new Error("STRIPE_PRICE_ID_REQUIRED_FOR_RECURRING");
  }

  if (dto.interval === "one_off" && !dto.stripeProductId) {
    throw new Error("STRIPE_PRODUCT_ID_REQUIRED_FOR_ONE_OFF");
  }

  return subscriptionRepo.createPlan(dto);
}

/**
 * Gets a subscription plan by ID.
 * @param {string} id - Plan ID.
 * @return {Promise<SubscriptionPlan | null>} Plan or null.
 */
export async function getPlan(id: string): Promise<SubscriptionPlan | null> {
  return subscriptionRepo.findPlanById(id);
}

/**
 * Gets all active subscription plans.
 * @return {Promise<SubscriptionPlan[]>} Array of active plans.
 */
export async function getActivePlans(): Promise<SubscriptionPlan[]> {
  return subscriptionRepo.findActivePlans();
}

/**
 * Gets all subscription plans.
 * @return {Promise<SubscriptionPlan[]>} Array of all plans.
 */
export async function getAllPlans(): Promise<SubscriptionPlan[]> {
  return subscriptionRepo.findAllPlans();
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
  const existing = await subscriptionRepo.findPlanById(id);
  if (!existing) {
    throw new PlanNotFoundError();
  }

  // Check if name is being changed and if it's already taken
  if (dto.name && dto.name !== existing.name) {
    const allPlans = await subscriptionRepo.findAllPlans();
    const nameExists = allPlans.some(
      (plan) => plan.id !== id && plan.name === dto.name,
    );
    if (nameExists) {
      throw new PlanNameTakenError();
    }
  }

  return subscriptionRepo.updatePlan(id, dto);
}

/**
 * Deletes a subscription plan.
 * @param {string} id - Plan ID.
 * @return {Promise<void>} Resolves when deleted.
 */
export async function deletePlan(id: string): Promise<void> {
  const existing = await subscriptionRepo.findPlanById(id);
  if (!existing) {
    throw new PlanNotFoundError();
  }

  // Note: In a real implementation, you might want to check for active
  // subscriptions using this plan before deletion
  // For now, we'll skip this check or implement it later

  return subscriptionRepo.deletePlan(id);
}
