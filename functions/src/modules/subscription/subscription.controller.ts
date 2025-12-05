import {Request, Response} from "express";
import {Timestamp} from "firebase-admin/firestore";
import * as subscriptionService from "./subscription.service";
import {
  SubscriptionCreateDto,
  SubscriptionUpdateDto,
  SubscriptionPlanCreateDto,
  SubscriptionPlanUpdateDto,
} from "./subscription.types";

/**
 * Converts a timestamp representation to a Timestamp object.
 * @param {unknown} value - Timestamp value (Timestamp, string, or object).
 * @return {Timestamp} Firestore Timestamp object.
 */
function toTimestamp(value: unknown): Timestamp {
  if (value instanceof Timestamp) {
    return value;
  }
  if (typeof value === "string") {
    return Timestamp.fromDate(new Date(value));
  }
  if (typeof value === "object" && value !== null) {
    const obj = value as {seconds: number; nanoseconds: number};
    return new Timestamp(obj.seconds, obj.nanoseconds);
  }
  throw new Error("Invalid timestamp format");
}

// Subscription controllers
/**
 * Creates a new subscription.
 * @param {Request} req - Express request object.
 * @param {Response} res - Express response object.
 * @return {Promise<void>} Response with created subscription.
 */
export async function createSubscriptionController(
  req: Request,
  res: Response,
): Promise<void> {
  try {
    const body = req.body;
    const dto: SubscriptionCreateDto = {
      ...body,
      currentPeriodStart: toTimestamp(body.currentPeriodStart),
      currentPeriodEnd: toTimestamp(body.currentPeriodEnd),
    };
    const subscription = await subscriptionService.createSubscription(dto);
    res.status(201).json(subscription);
  } catch (err: unknown) {
    const error = err as {statusCode?: number; message?: string};
    if (error.statusCode) {
      res.status(error.statusCode).json({message: error.message});
      return;
    }
    res.status(500).json({message: "INTERNAL_ERROR"});
  }
}

/**
 * Gets a subscription by ID.
 * @param {Request} req - Express request object.
 * @param {Response} res - Express response object.
 * @return {Promise<void>} Response with subscription or 404.
 */
export async function getSubscriptionController(
  req: Request,
  res: Response,
): Promise<void> {
  try {
    const {id} = req.params;
    const subscription = await subscriptionService.getSubscription(id);
    if (!subscription) {
      res.status(404).json({message: "NOT_FOUND"});
      return;
    }
    res.json(subscription);
  } catch (err: unknown) {
    const error = err as {statusCode?: number; message?: string};
    if (error.statusCode) {
      res.status(error.statusCode).json({message: error.message});
      return;
    }
    res.status(500).json({message: "INTERNAL_ERROR"});
  }
}

/**
 * Gets all subscriptions for a user.
 * @param {Request} req - Express request object.
 * @param {Response} res - Express response object.
 * @return {Promise<void>} Response with subscriptions array.
 */
export async function getSubscriptionsByUserIdController(
  req: Request,
  res: Response,
): Promise<void> {
  try {
    const {userId} = req.params;
    const subscriptions =
      await subscriptionService.getSubscriptionsByUserId(userId);
    res.json(subscriptions);
  } catch (err: unknown) {
    const error = err as {statusCode?: number; message?: string};
    if (error.statusCode) {
      res.status(error.statusCode).json({message: error.message});
      return;
    }
    res.status(500).json({message: "INTERNAL_ERROR"});
  }
}

/**
 * Gets the active subscription for a user.
 * @param {Request} req - Express request object.
 * @param {Response} res - Express response object.
 * @return {Promise<void>} Response with subscription or 404.
 */
export async function getActiveSubscriptionByUserIdController(
  req: Request,
  res: Response,
): Promise<void> {
  try {
    const {userId} = req.params;
    const subscription =
      await subscriptionService.getActiveSubscriptionByUserId(userId);
    if (!subscription) {
      res.status(404).json({message: "NOT_FOUND"});
      return;
    }
    res.json(subscription);
  } catch (err: unknown) {
    const error = err as {statusCode?: number; message?: string};
    if (error.statusCode) {
      res.status(error.statusCode).json({message: error.message});
      return;
    }
    res.status(500).json({message: "INTERNAL_ERROR"});
  }
}

/**
 * Updates a subscription.
 * @param {Request} req - Express request object.
 * @param {Response} res - Express response object.
 * @return {Promise<void>} Response with updated subscription.
 */
export async function updateSubscriptionController(
  req: Request,
  res: Response,
): Promise<void> {
  try {
    const {id} = req.params;
    const body = req.body;
    const dto: SubscriptionUpdateDto = {
      ...body,
      currentPeriodStart: body.currentPeriodStart ?
        toTimestamp(body.currentPeriodStart) :
        undefined,
      currentPeriodEnd: body.currentPeriodEnd ?
        toTimestamp(body.currentPeriodEnd) :
        undefined,
    };
    const subscription = await subscriptionService.updateSubscription(id, dto);
    res.json(subscription);
  } catch (err: unknown) {
    const error = err as {statusCode?: number; message?: string};
    if (error.statusCode) {
      res.status(error.statusCode).json({message: error.message});
      return;
    }
    res.status(500).json({message: "INTERNAL_ERROR"});
  }
}

/**
 * Cancels a subscription.
 * @param {Request} req - Express request object.
 * @param {Response} res - Express response object.
 * @return {Promise<void>} Response with cancelled subscription.
 */
export async function cancelSubscriptionController(
  req: Request,
  res: Response,
): Promise<void> {
  try {
    const {id} = req.params;
    const {cancelAtPeriodEnd} = req.body as {cancelAtPeriodEnd: boolean};
    const subscription = await subscriptionService.cancelSubscription(
      id,
      cancelAtPeriodEnd ?? false,
    );
    res.json(subscription);
  } catch (err: unknown) {
    const error = err as {statusCode?: number; message?: string};
    if (error.statusCode) {
      res.status(error.statusCode).json({message: error.message});
      return;
    }
    res.status(500).json({message: "INTERNAL_ERROR"});
  }
}

/**
 * Updates subscription hours usage.
 * @param {Request} req - Express request object.
 * @param {Response} res - Express response object.
 * @return {Promise<void>} Response with updated subscription.
 */
export async function updateSubscriptionHoursController(
  req: Request,
  res: Response,
): Promise<void> {
  try {
    const {id} = req.params;
    const {deskHoursUsed, meetingRoomHoursUsed} = req.body as {
      deskHoursUsed: number;
      meetingRoomHoursUsed: number;
    };
    const subscription = await subscriptionService.updateSubscriptionHours(
      id,
      deskHoursUsed,
      meetingRoomHoursUsed,
    );
    res.json(subscription);
  } catch (err: unknown) {
    const error = err as {statusCode?: number; message?: string};
    if (error.statusCode) {
      res.status(error.statusCode).json({message: error.message});
      return;
    }
    res.status(500).json({message: "INTERNAL_ERROR"});
  }
}

/**
 * Deletes a subscription.
 * @param {Request} req - Express request object.
 * @param {Response} res - Express response object.
 * @return {Promise<void>} 204 No Content response.
 */
export async function deleteSubscriptionController(
  req: Request,
  res: Response,
): Promise<void> {
  try {
    const {id} = req.params;
    await subscriptionService.deleteSubscription(id);
    res.status(204).send();
  } catch (err: unknown) {
    const error = err as {statusCode?: number; message?: string};
    if (error.statusCode) {
      res.status(error.statusCode).json({message: error.message});
      return;
    }
    res.status(500).json({message: "INTERNAL_ERROR"});
  }
}

// Subscription Plan controllers
/**
 * Creates a new subscription plan.
 * @param {Request} req - Express request object.
 * @param {Response} res - Express response object.
 * @return {Promise<void>} Response with created plan.
 */
export async function createPlanController(
  req: Request,
  res: Response,
): Promise<void> {
  try {
    const dto = req.body as SubscriptionPlanCreateDto;
    const plan = await subscriptionService.createPlan(dto);
    res.status(201).json(plan);
  } catch (err: unknown) {
    const error = err as {statusCode?: number; message?: string};
    if (error.statusCode) {
      res.status(error.statusCode).json({message: error.message});
      return;
    }
    res.status(500).json({message: "INTERNAL_ERROR"});
  }
}

/**
 * Gets a subscription plan by ID.
 * @param {Request} req - Express request object.
 * @param {Response} res - Express response object.
 * @return {Promise<void>} Response with plan or 404.
 */
export async function getPlanController(
  req: Request,
  res: Response,
): Promise<void> {
  try {
    const {id} = req.params;
    const plan = await subscriptionService.getPlan(id);
    if (!plan) {
      res.status(404).json({message: "NOT_FOUND"});
      return;
    }
    res.json(plan);
  } catch (err: unknown) {
    const error = err as {statusCode?: number; message?: string};
    if (error.statusCode) {
      res.status(error.statusCode).json({message: error.message});
      return;
    }
    res.status(500).json({message: "INTERNAL_ERROR"});
  }
}

/**
 * Gets all active subscription plans.
 * @param {Request} req - Express request object.
 * @param {Response} res - Express response object.
 * @return {Promise<void>} Response with plans array.
 */
export async function getActivePlansController(
  req: Request,
  res: Response,
): Promise<void> {
  try {
    const plans = await subscriptionService.getActivePlans();
    res.json(plans);
  } catch (err: unknown) {
    const error = err as {statusCode?: number; message?: string};
    if (error.statusCode) {
      res.status(error.statusCode).json({message: error.message});
      return;
    }
    res.status(500).json({message: "INTERNAL_ERROR"});
  }
}

/**
 * Gets all subscription plans.
 * @param {Request} req - Express request object.
 * @param {Response} res - Express response object.
 * @return {Promise<void>} Response with plans array.
 */
export async function getAllPlansController(
  req: Request,
  res: Response,
): Promise<void> {
  try {
    const plans = await subscriptionService.getAllPlans();
    res.json(plans);
  } catch (err: unknown) {
    const error = err as {statusCode?: number; message?: string};
    if (error.statusCode) {
      res.status(error.statusCode).json({message: error.message});
      return;
    }
    res.status(500).json({message: "INTERNAL_ERROR"});
  }
}

/**
 * Updates a subscription plan.
 * @param {Request} req - Express request object.
 * @param {Response} res - Express response object.
 * @return {Promise<void>} Response with updated plan.
 */
export async function updatePlanController(
  req: Request,
  res: Response,
): Promise<void> {
  try {
    const {id} = req.params;
    const dto = req.body as SubscriptionPlanUpdateDto;
    const plan = await subscriptionService.updatePlan(id, dto);
    res.json(plan);
  } catch (err: unknown) {
    const error = err as {statusCode?: number; message?: string};
    if (error.statusCode) {
      res.status(error.statusCode).json({message: error.message});
      return;
    }
    res.status(500).json({message: "INTERNAL_ERROR"});
  }
}

/**
 * Deletes a subscription plan.
 * @param {Request} req - Express request object.
 * @param {Response} res - Express response object.
 * @return {Promise<void>} 204 No Content response.
 */
export async function deletePlanController(
  req: Request,
  res: Response,
): Promise<void> {
  try {
    const {id} = req.params;
    await subscriptionService.deletePlan(id);
    res.status(204).send();
  } catch (err: unknown) {
    const error = err as {statusCode?: number; message?: string};
    if (error.statusCode) {
      res.status(error.statusCode).json({message: error.message});
      return;
    }
    res.status(500).json({message: "INTERNAL_ERROR"});
  }
}
