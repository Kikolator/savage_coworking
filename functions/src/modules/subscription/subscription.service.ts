import * as subscriptionRepo from "./subscription.repository";
import * as stripeService from "../stripe/stripe.service";
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
 * Error thrown when Stripe operation fails.
 */
export class StripeOperationError extends Error {
  /** HTTP status code for this error. */
  statusCode = 502;
  /**
   * @param {string} message - Error message.
   */
  constructor(message: string) {
    super(`STRIPE_OPERATION_FAILED: ${message}`);
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

  // Auto-create Stripe resources if not provided
  let stripeProductId = dto.stripeProductId;
  let stripePriceId = dto.stripePriceId;

  if (!stripeProductId || !stripePriceId) {
    try {
      const stripeResources = await stripeService.createStripeProductAndPrice({
        name: dto.name,
        price: dto.price,
        currency: dto.currency,
        interval: dto.interval,
      });
      stripeProductId = stripeResources.productId;
      stripePriceId = stripeResources.priceId;
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : String(error);
      throw new StripeOperationError(
        `Failed to create Stripe resources: ${errorMessage}`,
      );
    }
  }

  // Create plan with Stripe IDs
  try {
    return await subscriptionRepo.createPlan({
      ...dto,
      stripeProductId,
      stripePriceId,
    });
  } catch (error) {
    // Rollback: If plan creation fails and we created Stripe resources,
    // archive them
    if (!dto.stripeProductId && stripeProductId) {
      try {
        await stripeService.archiveStripeProduct(stripeProductId);
      } catch (rollbackError) {
        // Log but don't throw - original error is more important
        console.error(
          `Failed to archive Stripe product during rollback: ${rollbackError}`,
        );
      }
    }
    throw error;
  }
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

    // Update Stripe product name if product exists
    if (existing.stripeProductId) {
      try {
        await stripeService.updateStripeProduct(
          existing.stripeProductId,
          dto.name,
        );
      } catch (error) {
        const errorMessage =
          error instanceof Error ? error.message : String(error);
        throw new StripeOperationError(
          `Failed to update Stripe product: ${errorMessage}`,
        );
      }
    }
  }

  // Handle price change (prices are immutable, create new one)
  const priceChanged = dto.price !== undefined && dto.price !== existing.price;
  const currencyChanged =
    dto.currency !== undefined && dto.currency !== existing.currency;
  const intervalChanged =
    dto.interval !== undefined && dto.interval !== existing.interval;

  let newStripePriceId: string | undefined;
  let newStripeProductId: string | undefined;

  // If price or currency changed, create new price
  if ((priceChanged || currencyChanged) && existing.stripeProductId) {
    try {
      const interval = dto.interval ?? existing.interval;
      newStripePriceId = await stripeService.createStripePrice({
        productId: existing.stripeProductId,
        price: dto.price ?? existing.price,
        currency: dto.currency ?? existing.currency,
        interval,
      });
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : String(error);
      throw new StripeOperationError(
        `Failed to create new Stripe price: ${errorMessage}`,
      );
    }
  }

  // If interval changed, need to create new product/price combination
  if (intervalChanged && dto.interval) {
    try {
      const stripeResources = await stripeService.createStripeProductAndPrice({
        name: dto.name ?? existing.name,
        price: dto.price ?? existing.price,
        currency: dto.currency ?? existing.currency,
        interval: dto.interval,
      });
      newStripeProductId = stripeResources.productId;
      newStripePriceId = stripeResources.priceId;
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : String(error);
      throw new StripeOperationError(
        `Failed to create Stripe resources for interval change: ${errorMessage}`,
      );
    }
  }

  // If plan doesn't have Stripe IDs but price is being updated, create both
  if (
    !existing.stripeProductId &&
    (priceChanged || currencyChanged || intervalChanged)
  ) {
    try {
      const stripeResources = await stripeService.createStripeProductAndPrice({
        name: dto.name ?? existing.name,
        price: dto.price ?? existing.price,
        currency: dto.currency ?? existing.currency,
        interval: dto.interval ?? existing.interval,
      });
      newStripeProductId = stripeResources.productId;
      newStripePriceId = stripeResources.priceId;
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : String(error);
      throw new StripeOperationError(
        `Failed to create Stripe resources: ${errorMessage}`,
      );
    }
  }

  // Build update DTO with new Stripe IDs if created
  const updateDto: SubscriptionPlanUpdateDto = {...dto};
  if (newStripePriceId) {
    updateDto.stripePriceId = newStripePriceId;
  }
  if (newStripeProductId) {
    updateDto.stripeProductId = newStripeProductId;
  }

  try {
    return await subscriptionRepo.updatePlan(id, updateDto);
  } catch (error) {
    // If plan update fails after Stripe operations, log warning
    // (Stripe resources created but not linked)
    if (newStripePriceId || newStripeProductId) {
      console.warn(
        `Plan update failed after Stripe operations. ` +
          `Stripe resources may need manual cleanup: ` +
          `productId=${newStripeProductId}, priceId=${newStripePriceId}`,
      );
    }
    throw error;
  }
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

  // Check for active subscriptions using this plan
  const activeSubscriptions =
    await subscriptionRepo.findSubscriptionsByPlanId(id);
  if (activeSubscriptions.length > 0) {
    throw new Error(
      `Cannot delete plan with ${activeSubscriptions.length} active subscription(s). Deactivate the plan instead.`,
    );
  }

  // Archive Stripe product if it exists
  if (existing.stripeProductId) {
    try {
      await stripeService.archiveStripeProduct(existing.stripeProductId);
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : String(error);
      // Log warning but continue with deletion
      // (Stripe product may already be archived or deleted)
      console.warn(
        `Failed to archive Stripe product ${existing.stripeProductId}: ${errorMessage}`,
      );
    }
  }

  return subscriptionRepo.deletePlan(id);
}
