/* eslint-disable require-jsdoc */
import {Timestamp} from "firebase-admin/firestore";
import {afterEach, beforeEach, describe, expect, it, vi} from "vitest";
import {
  ActiveSubscriptionExistsError,
  HoursExceededError,
  InvalidStatusTransitionError,
  PlanNameTakenError,
  PlanNotFoundError,
  SubscriptionNotFoundError,
  cancelSubscription,
  createPlan,
  createSubscription,
  deletePlan,
  deleteSubscription,
  getAllPlans,
  getActivePlans,
  getActiveSubscriptionByUserId,
  getPlan,
  getSubscription,
  getSubscriptionsByUserId,
  updatePlan,
  updateSubscription,
  updateSubscriptionHours,
} from "../subscription.service";
import * as subscriptionRepo from "../subscription.repository";
import {
  Subscription,
  SubscriptionCreateDto,
  SubscriptionPlan,
  SubscriptionPlanCreateDto,
  SubscriptionStatus,
} from "../subscription.types";

vi.mock("../subscription.repository", () => ({
  findSubscriptionById: vi.fn(),
  findSubscriptionsByUserId: vi.fn(),
  findActiveSubscriptionByUserId: vi.fn(),
  findSubscriptionByStripeSubscriptionId: vi.fn(),
  createSubscription: vi.fn(),
  updateSubscription: vi.fn(),
  deleteSubscription: vi.fn(),
  findPlanById: vi.fn(),
  findActivePlans: vi.fn(),
  findAllPlans: vi.fn(),
  findPlanByStripePriceId: vi.fn(),
  createPlan: vi.fn(),
  updatePlan: vi.fn(),
  deletePlan: vi.fn(),
}));

const repoMock = vi.mocked(subscriptionRepo);

describe("subscription.service", () => {
  const fakeTimestamp = Timestamp.fromMillis(1_700_000_000_000);
  const fakePlan: SubscriptionPlan = {
    id: "plan-1",
    name: "Basic Plan",
    price: 2999,
    currency: "usd",
    interval: "month",
    deskHours: 40,
    meetingRoomHours: 10,
    features: ["40 desk hours", "10 meeting room hours"],
    isActive: true,
    stripePriceId: "price_123",
    createdAt: fakeTimestamp,
    updatedAt: fakeTimestamp,
  };

  const fakeSubscription: Subscription = {
    id: "sub-1",
    userId: "user-1",
    planId: "plan-1",
    planName: "Basic Plan",
    status: "active",
    stripeCustomerId: "cus_123",
    stripeSubscriptionId: "sub_123",
    renewsAutomatically: true,
    currentPeriodStart: fakeTimestamp,
    currentPeriodEnd: Timestamp.fromMillis(1_700_000_000_000 + 86400000 * 30),
    cancelAtPeriodEnd: false,
    deskHours: 40,
    meetingRoomHours: 10,
    deskHoursUsed: 0,
    meetingRoomHoursUsed: 0,
    createdAt: fakeTimestamp,
    updatedAt: fakeTimestamp,
  };

  beforeEach(() => {
    vi.clearAllMocks();
  });

  afterEach(() => {
    vi.restoreAllMocks();
  });

  describe("createSubscription", () => {
    const createDto: SubscriptionCreateDto = {
      userId: "user-1",
      planId: "plan-1",
      stripeCustomerId: "cus_123",
      stripeSubscriptionId: "sub_123",
      currentPeriodStart: fakeTimestamp,
      currentPeriodEnd: Timestamp.fromMillis(
        1_700_000_000_000 + 86400000 * 30,
      ),
    };

    it("creates a subscription successfully for monthly plan", async () => {
      repoMock.findPlanById.mockResolvedValue(fakePlan);
      repoMock.findActiveSubscriptionByUserId.mockResolvedValue(null);
      repoMock.createSubscription.mockResolvedValue(fakeSubscription);

      const result = await createSubscription(createDto);

      expect(repoMock.findPlanById).toHaveBeenCalledWith("plan-1");
      expect(repoMock.findActiveSubscriptionByUserId).toHaveBeenCalledWith(
        "user-1",
      );
      expect(repoMock.createSubscription).toHaveBeenCalledWith(
        createDto,
        fakePlan,
      );
      expect(result).toEqual(fakeSubscription);
    });

    it("creates a subscription successfully for one-off plan", async () => {
      const oneOffPlan: SubscriptionPlan = {
        ...fakePlan,
        interval: "one_off",
        stripeProductId: "prod_123",
      };
      const oneOffDto: SubscriptionCreateDto = {
        ...createDto,
        stripePaymentIntentId: "pi_123",
        stripeSubscriptionId: undefined,
      };
      const oneOffSubscription: Subscription = {
        ...fakeSubscription,
        renewsAutomatically: false,
        stripePaymentIntentId: "pi_123",
        stripeSubscriptionId: undefined,
      };

      repoMock.findPlanById.mockResolvedValue(oneOffPlan);
      repoMock.findActiveSubscriptionByUserId.mockResolvedValue(null);
      repoMock.createSubscription.mockResolvedValue(oneOffSubscription);

      const result = await createSubscription(oneOffDto);

      expect(result).toEqual(oneOffSubscription);
    });

    it("throws PlanNotFoundError when plan does not exist", async () => {
      repoMock.findPlanById.mockResolvedValue(null);

      await expect(createSubscription(createDto)).rejects.toThrow(
        PlanNotFoundError,
      );
    });

    it("throws error when plan is not active", async () => {
      const inactivePlan = {...fakePlan, isActive: false};
      repoMock.findPlanById.mockResolvedValue(inactivePlan);

      await expect(createSubscription(createDto)).rejects.toThrow(
        "PLAN_NOT_ACTIVE",
      );
    });

    it("throws ActiveSubscriptionExistsError when user has active subscription", async () => {
      repoMock.findPlanById.mockResolvedValue(fakePlan);
      repoMock.findActiveSubscriptionByUserId.mockResolvedValue(
        fakeSubscription,
      );

      await expect(createSubscription(createDto)).rejects.toThrow(
        ActiveSubscriptionExistsError,
      );
    });

    it("throws error when monthly plan missing stripeSubscriptionId", async () => {
      const dtoWithoutStripe = {...createDto, stripeSubscriptionId: undefined};
      repoMock.findPlanById.mockResolvedValue(fakePlan);
      repoMock.findActiveSubscriptionByUserId.mockResolvedValue(null);

      await expect(createSubscription(dtoWithoutStripe)).rejects.toThrow(
        "STRIPE_SUBSCRIPTION_ID_REQUIRED_FOR_RECURRING",
      );
    });

    it("throws error when one-off plan missing stripePaymentIntentId", async () => {
      const oneOffPlan: SubscriptionPlan = {
        ...fakePlan,
        interval: "one_off",
      };
      const dtoWithoutPaymentIntent: SubscriptionCreateDto = {
        ...createDto,
        stripePaymentIntentId: undefined,
        stripeSubscriptionId: undefined,
      };

      repoMock.findPlanById.mockResolvedValue(oneOffPlan);
      repoMock.findActiveSubscriptionByUserId.mockResolvedValue(null);

      await expect(createSubscription(dtoWithoutPaymentIntent)).rejects.toThrow(
        "STRIPE_PAYMENT_INTENT_ID_REQUIRED_FOR_ONE_OFF",
      );
    });
  });

  describe("getSubscription", () => {
    it("returns subscription when found", async () => {
      repoMock.findSubscriptionById.mockResolvedValue(fakeSubscription);

      const result = await getSubscription("sub-1");

      expect(repoMock.findSubscriptionById).toHaveBeenCalledWith("sub-1");
      expect(result).toEqual(fakeSubscription);
    });

    it("returns null when subscription not found", async () => {
      repoMock.findSubscriptionById.mockResolvedValue(null);

      const result = await getSubscription("sub-1");

      expect(result).toBeNull();
    });
  });

  describe("getSubscriptionsByUserId", () => {
    it("returns all subscriptions for a user", async () => {
      const subscriptions = [fakeSubscription];
      repoMock.findSubscriptionsByUserId.mockResolvedValue(subscriptions);

      const result = await getSubscriptionsByUserId("user-1");

      expect(repoMock.findSubscriptionsByUserId).toHaveBeenCalledWith("user-1");
      expect(result).toEqual(subscriptions);
    });
  });

  describe("getActiveSubscriptionByUserId", () => {
    it("returns active subscription when found", async () => {
      repoMock.findActiveSubscriptionByUserId.mockResolvedValue(
        fakeSubscription,
      );

      const result = await getActiveSubscriptionByUserId("user-1");

      expect(repoMock.findActiveSubscriptionByUserId).toHaveBeenCalledWith(
        "user-1",
      );
      expect(result).toEqual(fakeSubscription);
    });

    it("returns null when no active subscription found", async () => {
      repoMock.findActiveSubscriptionByUserId.mockResolvedValue(null);

      const result = await getActiveSubscriptionByUserId("user-1");

      expect(result).toBeNull();
    });
  });

  describe("updateSubscription", () => {
    it("updates subscription successfully", async () => {
      const updatedSubscription = {...fakeSubscription, status: "cancelled"};
      repoMock.findSubscriptionById
        .mockResolvedValueOnce(fakeSubscription)
        .mockResolvedValueOnce(updatedSubscription);
      repoMock.updateSubscription.mockResolvedValue(updatedSubscription);

      const result = await updateSubscription("sub-1", {status: "cancelled"});

      expect(repoMock.updateSubscription).toHaveBeenCalledWith("sub-1", {
        status: "cancelled",
      });
      expect(result).toEqual(updatedSubscription);
    });

    it("throws SubscriptionNotFoundError when subscription not found", async () => {
      repoMock.findSubscriptionById.mockResolvedValue(null);

      await expect(updateSubscription("sub-1", {status: "active"})).rejects
        .toThrow(SubscriptionNotFoundError);
    });

    it("throws InvalidStatusTransitionError for invalid transition", async () => {
      repoMock.findSubscriptionById.mockResolvedValue(fakeSubscription);
      // Don't mock updateSubscription since it should throw before calling it
      // active -> trial is invalid (trial can only go to active or cancelled)

      await expect(
        updateSubscription("sub-1", {status: "trial"}),
      ).rejects.toThrow(InvalidStatusTransitionError);
      expect(repoMock.updateSubscription).not.toHaveBeenCalled();
    });

    it("allows valid status transition", async () => {
      const trialSubscription = {...fakeSubscription, status: "trial"};
      const activeSubscription = {...fakeSubscription, status: "active"};
      repoMock.findSubscriptionById
        .mockResolvedValueOnce(trialSubscription)
        .mockResolvedValueOnce(activeSubscription);
      repoMock.updateSubscription.mockResolvedValue(activeSubscription);

      const result = await updateSubscription("sub-1", {status: "active"});

      expect(result.status).toBe("active");
    });

    it("validates hours usage on update", async () => {
      repoMock.findSubscriptionById.mockResolvedValue(fakeSubscription);

      await expect(
        updateSubscription("sub-1", {deskHoursUsed: 50}),
      ).rejects.toThrow(HoursExceededError);
    });

    it("allows unlimited hours (0 = unlimited)", async () => {
      const unlimitedPlan = {...fakeSubscription, deskHours: 0};
      const updated = {...unlimitedPlan, deskHoursUsed: 1000};
      repoMock.findSubscriptionById
        .mockResolvedValueOnce(unlimitedPlan)
        .mockResolvedValueOnce(updated);
      repoMock.updateSubscription.mockResolvedValue(updated);

      const result = await updateSubscription("sub-1", {
        deskHoursUsed: 1000,
      });

      expect(result.deskHoursUsed).toBe(1000);
    });
  });

  describe("cancelSubscription", () => {
    it("cancels at period end when requested", async () => {
      const cancelled = {...fakeSubscription, cancelAtPeriodEnd: true};
      repoMock.findSubscriptionById
        .mockResolvedValueOnce(fakeSubscription)
        .mockResolvedValueOnce(cancelled);
      repoMock.updateSubscription.mockResolvedValue(cancelled);

      const result = await cancelSubscription("sub-1", true);

      expect(repoMock.updateSubscription).toHaveBeenCalledWith("sub-1", {
        cancelAtPeriodEnd: true,
      });
      expect(result.cancelAtPeriodEnd).toBe(true);
    });

    it("cancels immediately when requested", async () => {
      const cancelled = {
        ...fakeSubscription,
        status: "cancelled",
        cancelAtPeriodEnd: false,
      };
      repoMock.findSubscriptionById
        .mockResolvedValueOnce(fakeSubscription)
        .mockResolvedValueOnce(cancelled);
      repoMock.updateSubscription.mockResolvedValue(cancelled);

      const result = await cancelSubscription("sub-1", false);

      expect(repoMock.updateSubscription).toHaveBeenCalledWith("sub-1", {
        status: "cancelled",
        cancelAtPeriodEnd: false,
      });
      expect(result.status).toBe("cancelled");
    });

    it("throws SubscriptionNotFoundError when subscription not found", async () => {
      repoMock.findSubscriptionById.mockResolvedValue(null);

      await expect(cancelSubscription("sub-1", false)).rejects.toThrow(
        SubscriptionNotFoundError,
      );
    });
  });

  describe("updateSubscriptionHours", () => {
    it("updates hours successfully within limits", async () => {
      const updated = {...fakeSubscription, deskHoursUsed: 20, meetingRoomHoursUsed: 5};
      repoMock.findSubscriptionById
        .mockResolvedValueOnce(fakeSubscription)
        .mockResolvedValueOnce(updated);
      repoMock.updateSubscription.mockResolvedValue(updated);

      const result = await updateSubscriptionHours("sub-1", 20, 5);

      expect(repoMock.updateSubscription).toHaveBeenCalledWith("sub-1", {
        deskHoursUsed: 20,
        meetingRoomHoursUsed: 5,
      });
      expect(result.deskHoursUsed).toBe(20);
      expect(result.meetingRoomHoursUsed).toBe(5);
    });

    it("throws HoursExceededError for desk hours", async () => {
      repoMock.findSubscriptionById.mockResolvedValue(fakeSubscription);

      await expect(
        updateSubscriptionHours("sub-1", 50, 5),
      ).rejects.toThrow(HoursExceededError);
    });

    it("throws HoursExceededError for meeting room hours", async () => {
      repoMock.findSubscriptionById.mockResolvedValue(fakeSubscription);

      await expect(
        updateSubscriptionHours("sub-1", 20, 15),
      ).rejects.toThrow(HoursExceededError);
    });

    it("throws SubscriptionNotFoundError when subscription not found", async () => {
      repoMock.findSubscriptionById.mockResolvedValue(null);

      await expect(updateSubscriptionHours("sub-1", 20, 5)).rejects.toThrow(
        SubscriptionNotFoundError,
      );
    });
  });

  describe("deleteSubscription", () => {
    it("deletes subscription successfully", async () => {
      repoMock.findSubscriptionById.mockResolvedValue(fakeSubscription);
      repoMock.deleteSubscription.mockResolvedValue(undefined);

      await deleteSubscription("sub-1");

      expect(repoMock.findSubscriptionById).toHaveBeenCalledWith("sub-1");
      expect(repoMock.deleteSubscription).toHaveBeenCalledWith("sub-1");
    });

    it("throws SubscriptionNotFoundError when subscription not found", async () => {
      repoMock.findSubscriptionById.mockResolvedValue(null);

      await expect(deleteSubscription("sub-1")).rejects.toThrow(
        SubscriptionNotFoundError,
      );
    });
  });

  describe("createPlan", () => {
    const planDto: SubscriptionPlanCreateDto = {
      name: "New Plan",
      price: 4999,
      currency: "usd",
      interval: "month",
      deskHours: 80,
      meetingRoomHours: 20,
      features: ["80 desk hours", "20 meeting room hours"],
      isActive: true,
      stripePriceId: "price_456",
    };

    it("creates a plan successfully", async () => {
      const newPlan: SubscriptionPlan = {
        ...fakePlan,
        ...planDto,
        id: "plan-2",
      };
      repoMock.findAllPlans.mockResolvedValue([]);
      repoMock.createPlan.mockResolvedValue(newPlan);

      const result = await createPlan(planDto);

      expect(repoMock.findAllPlans).toHaveBeenCalled();
      expect(repoMock.createPlan).toHaveBeenCalledWith(planDto);
      expect(result).toEqual(newPlan);
    });

    it("throws PlanNameTakenError when name already exists", async () => {
      repoMock.findAllPlans.mockResolvedValue([fakePlan]);

      await expect(createPlan({...planDto, name: "Basic Plan"})).rejects
        .toThrow(PlanNameTakenError);
    });

    it("throws error when monthly plan missing stripePriceId", async () => {
      repoMock.findAllPlans.mockResolvedValue([]);

      await expect(
        createPlan({...planDto, stripePriceId: undefined}),
      ).rejects.toThrow("STRIPE_PRICE_ID_REQUIRED_FOR_RECURRING");
    });

    it("throws error when one-off plan missing stripeProductId", async () => {
      repoMock.findAllPlans.mockResolvedValue([]);

      await expect(
        createPlan({
          ...planDto,
          interval: "one_off",
          stripePriceId: undefined,
          stripeProductId: undefined,
        }),
      ).rejects.toThrow("STRIPE_PRODUCT_ID_REQUIRED_FOR_ONE_OFF");
    });
  });

  describe("getPlan", () => {
    it("returns plan when found", async () => {
      repoMock.findPlanById.mockResolvedValue(fakePlan);

      const result = await getPlan("plan-1");

      expect(repoMock.findPlanById).toHaveBeenCalledWith("plan-1");
      expect(result).toEqual(fakePlan);
    });

    it("returns null when plan not found", async () => {
      repoMock.findPlanById.mockResolvedValue(null);

      const result = await getPlan("plan-1");

      expect(result).toBeNull();
    });
  });

  describe("getActivePlans", () => {
    it("returns all active plans", async () => {
      const plans = [fakePlan];
      repoMock.findActivePlans.mockResolvedValue(plans);

      const result = await getActivePlans();

      expect(repoMock.findActivePlans).toHaveBeenCalled();
      expect(result).toEqual(plans);
    });
  });

  describe("getAllPlans", () => {
    it("returns all plans", async () => {
      const plans = [fakePlan];
      repoMock.findAllPlans.mockResolvedValue(plans);

      const result = await getAllPlans();

      expect(repoMock.findAllPlans).toHaveBeenCalled();
      expect(result).toEqual(plans);
    });
  });

  describe("updatePlan", () => {
    it("updates plan successfully", async () => {
      const updated = {...fakePlan, price: 3999};
      repoMock.findPlanById
        .mockResolvedValueOnce(fakePlan)
        .mockResolvedValueOnce(updated);
      repoMock.findAllPlans.mockResolvedValue([fakePlan]);
      repoMock.updatePlan.mockResolvedValue(updated);

      const result = await updatePlan("plan-1", {price: 3999});

      expect(repoMock.updatePlan).toHaveBeenCalledWith("plan-1", {
        price: 3999,
      });
      expect(result.price).toBe(3999);
    });

    it("throws PlanNotFoundError when plan not found", async () => {
      repoMock.findPlanById.mockResolvedValue(null);

      await expect(updatePlan("plan-1", {price: 3999})).rejects.toThrow(
        PlanNotFoundError,
      );
    });

    it("throws PlanNameTakenError when name already exists", async () => {
      const otherPlan = {...fakePlan, id: "plan-2", name: "Other Plan"};
      repoMock.findPlanById.mockResolvedValue(fakePlan);
      repoMock.findAllPlans.mockResolvedValue([fakePlan, otherPlan]);

      await expect(
        updatePlan("plan-1", {name: "Other Plan"}),
      ).rejects.toThrow(PlanNameTakenError);
    });

    it("allows updating name to same value", async () => {
      const updated = {...fakePlan};
      repoMock.findPlanById
        .mockResolvedValueOnce(fakePlan)
        .mockResolvedValueOnce(updated);
      repoMock.findAllPlans.mockResolvedValue([fakePlan]);
      repoMock.updatePlan.mockResolvedValue(updated);

      const result = await updatePlan("plan-1", {name: "Basic Plan"});

      expect(result.name).toBe("Basic Plan");
    });
  });

  describe("deletePlan", () => {
    it("deletes plan successfully", async () => {
      repoMock.findPlanById.mockResolvedValue(fakePlan);
      repoMock.deletePlan.mockResolvedValue(undefined);

      await deletePlan("plan-1");

      expect(repoMock.findPlanById).toHaveBeenCalledWith("plan-1");
      expect(repoMock.deletePlan).toHaveBeenCalledWith("plan-1");
    });

    it("throws PlanNotFoundError when plan not found", async () => {
      repoMock.findPlanById.mockResolvedValue(null);

      await expect(deletePlan("plan-1")).rejects.toThrow(PlanNotFoundError);
    });
  });
});

