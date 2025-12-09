import {Timestamp} from "firebase-admin/firestore";

// ============================================================================
// Enums
// ============================================================================

export type PlanCategory = "dayPass" | "explore" | "nomad" | "fix";

export type BillingType = "oneOff" | "recurring";

export type BillingPeriod = "day" | "month";

export type AccessType = "business" | "24_7";

export type SeatType = "hot" | "fixed";

export type PassBundleStatus = "active" | "consumed" | "expired" | "cancelled";

export type BookingType = "desk" | "meetingRoom";

export type BookingStatus = "booked" | "checkedIn" | "completed" | "cancelled";

export type BookingKind = "subscription" | "passBundle";

export type SubscriptionStatus =
  | "active"
  | "cancelled"
  | "expired"
  | "trial"
  | "past_due";

// ============================================================================
// Nested Interfaces
// ============================================================================

export interface Billing {
  type: BillingType;
  period?: BillingPeriod; // Required when type is 'recurring'
  intervalCount?: number; // Defaults to 1 if not provided
}

export interface Access {
  type: AccessType;
  allowedDaysOfWeek?: number[]; // Array of integers 0-6 (Sunday=0, Saturday=6)
  startTime?: string; // Format: "HH:mm" (e.g., "09:00")
  endTime?: string; // Format: "HH:mm" (e.g., "18:00")
}

export interface Quota {
  dayPassCredits?: number; // Number of daypass credits (for dayPass plans)
  deskHoursPerPeriod?: number; // Desk hours per period (0 = unlimited)
  // Meeting room hours per period (0 = unlimited)
  meetingHoursPerPeriod?: number;
  access: Access;
  seatType?: SeatType; // 'hot' or 'fixed' (for fix plans)
}

export interface Pricing {
  currency: string; // ISO 4217 currency code (e.g., 'usd', 'eur')
  amount: number; // Price in smallest currency unit (cents for USD)
  billingDescription: string; // Human-readable billing description
}

export interface External {
  stripeProductId?: string;
  stripePriceId?: string; // For recurring plans
}

export interface Overrides {
  deskHoursPerPeriod?: number; // Override desk hours (admin-only, permanent)
  // Override meeting room hours (admin-only, permanent)
  meetingHoursPerPeriod?: number;
  // Other overrides can be added here
}

export interface Display {
  planName: string; // Human-readable plan name
  priceAmount: number; // Price in smallest currency unit (cents)
  priceCurrency: string; // ISO 4217 currency code
}

export interface Breakdown {
  date: string; // Date string in YYYY-MM-DD format
  deskMinutes: number;
  meetingMinutes: number;
  dayPassUsed: number;
}

export interface BookingSource {
  kind: BookingKind;
  subscriptionId?: string; // When kind is 'subscription'
  passBundleId?: string; // When kind is 'passBundle'
}

// ============================================================================
// Main Models
// ============================================================================

export interface SubscriptionPlan {
  id: string;
  name: string;
  category: PlanCategory;
  billing: Billing;
  quota: Quota;
  pricing: Pricing;
  external?: External;
  features: string[];
  isActive: boolean;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

export interface Subscription {
  id: string;
  userId: string;
  planId: string;
  status: SubscriptionStatus;
  billing: Billing; // Always type: 'recurring'
  effectiveQuota: Quota; // Plan quota + overrides
  overrides?: Overrides; // Admin-only overrides (permanent)
  display: Display;
  stripeCustomerId: string;
  stripeSubscriptionId?: string; // For recurring subscriptions
  currentPeriodStart: Timestamp;
  currentPeriodEnd: Timestamp;
  cancelAtPeriodEnd: boolean;
  cancelledAt?: Timestamp;
  cancelledBy?: string; // User ID (uid)
  assignedDeskId?: string; // For fix plans
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

export interface PassBundle {
  id: string;
  userId: string;
  planId: string;
  status: PassBundleStatus;
  totalCredits: number;
  remainingCredits: number;
  validFrom: Timestamp;
  validUntil?: Timestamp;
  access: Access;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

export interface Usage {
  id: string;
  userId: string;
  subscriptionId?: string; // For recurring subscriptions
  passBundleId?: string; // For pass bundles
  periodStart: Timestamp;
  periodEnd: Timestamp;
  deskMinutesUsed: number;
  meetingMinutesUsed: number;
  breakdown?: Map<string, Breakdown>; // Key: YYYY-MM-DD, Value: Breakdown
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

export interface Booking {
  id: string;
  userId: string;
  type: BookingType;
  date: string; // YYYY-MM-DD format
  startTime: string; // HH:mm format
  endTime: string; // HH:mm format
  source: BookingSource;
  status: BookingStatus;
  workspaceId: string;
  deskId?: string; // When type is 'desk'
  roomId?: string; // When type is 'meetingRoom'
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

export interface MembershipSummary {
  activeSubscriptionId?: string;
  planId?: string;
  planName?: string;
  status?: SubscriptionStatus;
  currentPeriodEnd?: Timestamp;
  deskMinutesRemaining?: number; // null = unlimited
  meetingMinutesRemaining?: number; // null = unlimited
  remainingDayPassCredits?: number;
  access?: AccessType;
}

// ============================================================================
// DTOs for Creating
// ============================================================================

export interface SubscriptionPlanCreateDto {
  name: string;
  category: PlanCategory;
  billing: Billing;
  quota: Quota;
  pricing: Pricing;
  external?: External;
  features: string[];
  isActive: boolean;
}

export interface SubscriptionCreateDto {
  userId: string;
  planId: string;
  stripeCustomerId: string;
  stripeSubscriptionId?: string;
  currentPeriodStart: Timestamp;
  currentPeriodEnd: Timestamp;
  overrides?: Overrides;
  assignedDeskId?: string;
}

export interface PassBundleCreateDto {
  userId: string;
  planId: string;
  validFrom: Timestamp;
  validUntil?: Timestamp;
}

export interface UsageCreateDto {
  userId: string;
  subscriptionId?: string;
  passBundleId?: string;
  periodStart: Timestamp;
  periodEnd: Timestamp;
}

export interface BookingCreateDto {
  userId: string;
  type: BookingType;
  date: string; // YYYY-MM-DD
  startTime: string; // HH:mm
  endTime: string; // HH:mm
  source: BookingSource;
  workspaceId: string;
  deskId?: string;
  roomId?: string;
}

// ============================================================================
// DTOs for Updating
// ============================================================================

export interface SubscriptionPlanUpdateDto {
  name?: string;
  category?: PlanCategory;
  billing?: Billing;
  quota?: Quota;
  pricing?: Pricing;
  external?: External;
  features?: string[];
  isActive?: boolean;
}

export interface SubscriptionUpdateDto {
  status?: SubscriptionStatus;
  cancelAtPeriodEnd?: boolean;
  currentPeriodStart?: Timestamp;
  currentPeriodEnd?: Timestamp;
  overrides?: Overrides;
  cancelledAt?: Timestamp;
  cancelledBy?: string;
  assignedDeskId?: string;
}

export interface PassBundleUpdateDto {
  status?: PassBundleStatus;
  remainingCredits?: number;
}

export interface UsageUpdateDto {
  deskMinutesUsed?: number;
  meetingMinutesUsed?: number;
  breakdown?: Map<string, Breakdown>;
}

export interface BookingUpdateDto {
  status?: BookingStatus;
}

// ============================================================================
// Collection Names
// ============================================================================

export const SUBSCRIPTION_PLANS_COLLECTION = "subscriptionPlans";
export const SUBSCRIPTIONS_COLLECTION = "subscriptions";
export const PASS_BUNDLES_COLLECTION = "passBundles";
export const USAGE_COLLECTION = "usage";
export const BOOKINGS_COLLECTION = "bookings";
