import {Timestamp} from "firebase-admin/firestore";

export type SubscriptionStatus =
  | "active"
  | "cancelled"
  | "expired"
  | "trial"
  | "past_due";

export type SubscriptionInterval = "month" | "one_off";

export interface Subscription {
  id: string;
  userId: string;
  planId: string;
  planName: string;
  status: SubscriptionStatus;
  stripeSubscriptionId?: string;
  stripeCustomerId: string;
  stripePaymentIntentId?: string;
  renewsAutomatically: boolean;
  currentPeriodStart: Timestamp;
  currentPeriodEnd: Timestamp;
  cancelAtPeriodEnd: boolean;
  deskHours: number;
  meetingRoomHours: number;
  deskHoursUsed: number;
  meetingRoomHoursUsed: number;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

export interface SubscriptionPlan {
  id: string;
  name: string;
  price: number;
  currency: string;
  interval: SubscriptionInterval;
  deskHours: number;
  meetingRoomHours: number;
  features: string[];
  isActive: boolean;
  stripePriceId?: string;
  stripeProductId?: string;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

// DTOs for creating subscriptions
export interface SubscriptionCreateDto {
  userId: string;
  planId: string;
  stripeCustomerId: string;
  stripeSubscriptionId?: string;
  stripePaymentIntentId?: string;
  currentPeriodStart: Timestamp;
  currentPeriodEnd: Timestamp;
}

// DTOs for updating subscriptions
export interface SubscriptionUpdateDto {
  status?: SubscriptionStatus;
  cancelAtPeriodEnd?: boolean;
  deskHoursUsed?: number;
  meetingRoomHoursUsed?: number;
  currentPeriodStart?: Timestamp;
  currentPeriodEnd?: Timestamp;
}

// DTOs for creating subscription plans
export interface SubscriptionPlanCreateDto {
  name: string;
  price: number;
  currency: string;
  interval: SubscriptionInterval;
  deskHours: number;
  meetingRoomHours: number;
  features: string[];
  isActive: boolean;
  stripePriceId?: string;
  stripeProductId?: string;
}

// DTOs for updating subscription plans
export interface SubscriptionPlanUpdateDto {
  name?: string;
  price?: number;
  currency?: string;
  interval?: SubscriptionInterval;
  deskHours?: number;
  meetingRoomHours?: number;
  features?: string[];
  isActive?: boolean;
  stripePriceId?: string;
  stripeProductId?: string;
}

export const SUBSCRIPTIONS_COLLECTION = "subscriptions";
export const SUBSCRIPTION_PLANS_COLLECTION = "subscriptionPlans";

