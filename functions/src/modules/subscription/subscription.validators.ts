import {Request, Response, NextFunction} from "express";
import {Timestamp} from "firebase-admin/firestore";

const SUBSCRIPTION_STATUSES = [
  "active",
  "cancelled",
  "expired",
  "trial",
  "past_due",
] as const;

const SUBSCRIPTION_INTERVALS = ["month", "one_off"] as const;

/**
 * Checks if a value is a valid timestamp representation.
 * Accepts Timestamp objects, objects with seconds/nanoseconds, or ISO strings.
 * @param {unknown} value - Value to check.
 * @return {boolean} True if value is a valid timestamp.
 */
function isValidTimestamp(
  value: unknown,
): value is Timestamp | {seconds: number; nanoseconds: number} | string {
  if (value instanceof Timestamp) {
    return true;
  }
  if (typeof value === "string") {
    // Check if it's a valid ISO date string
    return !isNaN(Date.parse(value));
  }
  if (typeof value === "object" && value !== null) {
    const obj = value as Record<string, unknown>;
    return (
      typeof obj.seconds === "number" &&
      typeof obj.nanoseconds === "number"
    );
  }
  return false;
}

/**
 * Converts a timestamp representation to a Timestamp object.
 * @param {unknown} value - Timestamp value to convert.
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

/**
 * Validates subscription creation request.
 * @param {Request} req - Express request object.
 * @param {Response} res - Express response object.
 * @param {NextFunction} next - Express next function.
 * @return {void}
 */
export function validateCreateSubscription(
  req: Request,
  res: Response,
  next: NextFunction,
): void {
  const {
    userId,
    planId,
    stripeCustomerId,
    stripeSubscriptionId,
    stripePaymentIntentId,
    currentPeriodStart,
    currentPeriodEnd,
  } = req.body ?? {};

  if (typeof userId !== "string" || !userId.trim()) {
    res.status(400).json({message: "Invalid userId"});
    return;
  }

  if (typeof planId !== "string" || !planId.trim()) {
    res.status(400).json({message: "Invalid planId"});
    return;
  }

  if (typeof stripeCustomerId !== "string" || !stripeCustomerId.trim()) {
    res.status(400).json({message: "Invalid stripeCustomerId"});
    return;
  }

  if (currentPeriodStart === undefined ||
    !isValidTimestamp(currentPeriodStart)) {
    res.status(400).json({message: "Invalid currentPeriodStart"});
    return;
  }

  if (currentPeriodEnd === undefined || !isValidTimestamp(currentPeriodEnd)) {
    res.status(400).json({message: "Invalid currentPeriodEnd"});
    return;
  }

  // Convert to Timestamp for comparison
  const startTs = toTimestamp(currentPeriodStart);
  const endTs = toTimestamp(currentPeriodEnd);

  if (endTs.toMillis() <= startTs.toMillis()) {
    res
      .status(400)
      .json({message: "currentPeriodEnd must be after currentPeriodStart"});
    return;
  }

  if (
    stripeSubscriptionId !== undefined &&
    (typeof stripeSubscriptionId !== "string" || !stripeSubscriptionId.trim())
  ) {
    res.status(400).json({message: "Invalid stripeSubscriptionId"});
    return;
  }

  if (
    stripePaymentIntentId !== undefined &&
    (typeof stripePaymentIntentId !== "string" ||
      !stripePaymentIntentId.trim())
  ) {
    res.status(400).json({message: "Invalid stripePaymentIntentId"});
    return;
  }

  next();
}

/**
 * Validates subscription update request.
 * @param {Request} req - Express request object.
 * @param {Response} res - Express response object.
 * @param {NextFunction} next - Express next function.
 * @return {void}
 */
export function validateUpdateSubscription(
  req: Request,
  res: Response,
  next: NextFunction,
): void {
  const {
    status,
    cancelAtPeriodEnd,
    deskHoursUsed,
    meetingRoomHoursUsed,
    currentPeriodStart,
    currentPeriodEnd,
  } = req.body ?? {};

  if (status !== undefined) {
    if (!SUBSCRIPTION_STATUSES.includes(status)) {
      res.status(400).json({message: "Invalid status"});
      return;
    }
  }

  if (cancelAtPeriodEnd !== undefined &&
    typeof cancelAtPeriodEnd !== "boolean") {
    res.status(400).json({message: "Invalid cancelAtPeriodEnd"});
    return;
  }

  if (deskHoursUsed !== undefined) {
    if (typeof deskHoursUsed !== "number" || deskHoursUsed < 0) {
      res.status(400).json({message: "Invalid deskHoursUsed"});
      return;
    }
  }

  if (meetingRoomHoursUsed !== undefined) {
    if (
      typeof meetingRoomHoursUsed !== "number" ||
      meetingRoomHoursUsed < 0
    ) {
      res.status(400).json({message: "Invalid meetingRoomHoursUsed"});
      return;
    }
  }

  if (currentPeriodStart !== undefined) {
    if (!isValidTimestamp(currentPeriodStart)) {
      res.status(400).json({message: "Invalid currentPeriodStart"});
      return;
    }
  }

  if (currentPeriodEnd !== undefined) {
    if (!isValidTimestamp(currentPeriodEnd)) {
      res.status(400).json({message: "Invalid currentPeriodEnd"});
      return;
    }
  }

  if (
    currentPeriodStart !== undefined &&
    currentPeriodEnd !== undefined
  ) {
    const startTs = toTimestamp(currentPeriodStart);
    const endTs = toTimestamp(currentPeriodEnd);
    if (endTs.toMillis() <= startTs.toMillis()) {
      res
        .status(400)
        .json({message: "currentPeriodEnd must be after currentPeriodStart"});
      return;
    }
  }

  next();
}

/**
 * Validates subscription plan creation request.
 * @param {Request} req - Express request object.
 * @param {Response} res - Express response object.
 * @param {NextFunction} next - Express next function.
 * @return {void}
 */
export function validateCreatePlan(
  req: Request,
  res: Response,
  next: NextFunction,
): void {
  const {
    name,
    price,
    currency,
    interval,
    deskHours,
    meetingRoomHours,
    features,
    isActive,
    stripePriceId,
    stripeProductId,
  } = req.body ?? {};

  if (typeof name !== "string" || name.trim().length === 0 ||
    name.length > 100) {
    res.status(400).json({message: "Invalid name"});
    return;
  }

  if (typeof price !== "number" || price <= 0 || !Number.isInteger(price)) {
    res.status(400).json({message: "Invalid price"});
    return;
  }

  if (typeof currency !== "string" || currency.length !== 3) {
    res.status(400).json({message: "Invalid currency"});
    return;
  }

  if (!SUBSCRIPTION_INTERVALS.includes(interval)) {
    res.status(400).json({message: "Invalid interval"});
    return;
  }

  if (typeof deskHours !== "number" || deskHours < 0) {
    res.status(400).json({message: "Invalid deskHours"});
    return;
  }

  if (typeof meetingRoomHours !== "number" || meetingRoomHours < 0) {
    res.status(400).json({message: "Invalid meetingRoomHours"});
    return;
  }

  if (!Array.isArray(features)) {
    res.status(400).json({message: "Invalid features"});
    return;
  }

  for (const feature of features) {
    if (typeof feature !== "string" || feature.length > 200) {
      res.status(400).json({message: "Invalid feature"});
      return;
    }
  }

  if (typeof isActive !== "boolean") {
    res.status(400).json({message: "Invalid isActive"});
    return;
  }

  if (stripePriceId !== undefined) {
    if (typeof stripePriceId !== "string" || !stripePriceId.trim()) {
      res.status(400).json({message: "Invalid stripePriceId"});
      return;
    }
  }

  if (stripeProductId !== undefined) {
    if (typeof stripeProductId !== "string" || !stripeProductId.trim()) {
      res.status(400).json({message: "Invalid stripeProductId"});
      return;
    }
  }

  next();
}

/**
 * Validates subscription plan update request.
 * @param {Request} req - Express request object.
 * @param {Response} res - Express response object.
 * @param {NextFunction} next - Express next function.
 * @return {void}
 */
export function validateUpdatePlan(
  req: Request,
  res: Response,
  next: NextFunction,
): void {
  const {
    name,
    price,
    currency,
    interval,
    deskHours,
    meetingRoomHours,
    features,
    isActive,
    stripePriceId,
    stripeProductId,
  } = req.body ?? {};

  if (name !== undefined) {
    if (typeof name !== "string" || name.trim().length === 0 ||
      name.length > 100) {
      res.status(400).json({message: "Invalid name"});
      return;
    }
  }

  if (price !== undefined) {
    if (typeof price !== "number" || price <= 0 || !Number.isInteger(price)) {
      res.status(400).json({message: "Invalid price"});
      return;
    }
  }

  if (currency !== undefined) {
    if (typeof currency !== "string" || currency.length !== 3) {
      res.status(400).json({message: "Invalid currency"});
      return;
    }
  }

  if (interval !== undefined) {
    if (!SUBSCRIPTION_INTERVALS.includes(interval)) {
      res.status(400).json({message: "Invalid interval"});
      return;
    }
  }

  if (deskHours !== undefined) {
    if (typeof deskHours !== "number" || deskHours < 0) {
      res.status(400).json({message: "Invalid deskHours"});
      return;
    }
  }

  if (meetingRoomHours !== undefined) {
    if (typeof meetingRoomHours !== "number" || meetingRoomHours < 0) {
      res.status(400).json({message: "Invalid meetingRoomHours"});
      return;
    }
  }

  if (features !== undefined) {
    if (!Array.isArray(features)) {
      res.status(400).json({message: "Invalid features"});
      return;
    }

    for (const feature of features) {
      if (typeof feature !== "string" || feature.length > 200) {
        res.status(400).json({message: "Invalid feature"});
        return;
      }
    }
  }

  if (isActive !== undefined) {
    if (typeof isActive !== "boolean") {
      res.status(400).json({message: "Invalid isActive"});
      return;
    }
  }

  if (stripePriceId !== undefined) {
    if (typeof stripePriceId !== "string" || !stripePriceId.trim()) {
      res.status(400).json({message: "Invalid stripePriceId"});
      return;
    }
  }

  if (stripeProductId !== undefined) {
    if (typeof stripeProductId !== "string" || !stripeProductId.trim()) {
      res.status(400).json({message: "Invalid stripeProductId"});
      return;
    }
  }

  next();
}
