import {Timestamp} from "firebase-admin/firestore";
import {afterEach, beforeEach, describe, expect, it, vi} from "vitest";
import {
  ActiveSubscriptionExistsError,
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
} from "../subscription.service.js";
import * as subscriptionRepo from "../subscription.repository.js";
import {
  Subscription,
  SubscriptionCreateDto,
  SubscriptionPlan,
  SubscriptionPlanCreateDto,
} from "../subscription.types.js";

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
    category: "explore",
    billing: {
      type: "recurring",
      period: "month",
      intervalCount: 1,
    },
    quota: {
      deskHoursPerPeriod: 40,
      meetingHoursPerPeriod: 10,
      access: {
        type: "business",
        startTime: "09:00",
        endTime: "18:00",
      },
    },
    pricing: {
      currency: "usd",
      amount: 2999,
      billingDescription: "$29.99/month",
    },
    external: {
      stripeProductId: "prod_123",
      stripePriceId: "price_123",
    },
    features: ["40 desk hours", "10 meeting room hours"],
    isActive: true,
    createdAt: fakeTimestamp,
    updatedAt: fakeTimestamp,
  };

  const fakeSubscription: Subscription = {
    id: "sub-1",
    userId: "user-1",
    planId: "plan-1",
    status: "active",
    stripeCustomerId: "cus_123",
    stripeSubscriptionId: "sub_123",
    currentPeriodStart: fakeTimestamp,
    currentPeriodEnd: Timestamp.fromMillis(1_700_000_000_000 + 86400000 * 30),
    cancelAtPeriodEnd: false,
    billing: {
      type: "recurring",
      period: "month",
      intervalCount: 1,
    },
    effectiveQuota: {
      deskHoursPerPeriod: 40,
      meetingHoursPerPeriod: 10,
      access: {
        type: "business",
        startTime: "09:00",
        endTime: "18:00",
      },
    },
    display: {
      planName: "Basic Plan",
      priceAmount: 2999,
      priceCurrency: "usd",
    },
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

    // Note: One-off plans now create PassBundles, not Subscriptions
    // This test is no longer applicable for subscriptions

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

    it(
      "throws ActiveSubscriptionExistsError when user has active subscription",
      async () => {
        repoMock.findPlanById.mockResolvedValue(fakePlan);
        repoMock.findActiveSubscriptionByUserId.mockResolvedValue(
          fakeSubscription,
        );

        await expect(createSubscription(createDto)).rejects.toThrow(
          ActiveSubscriptionExistsError,
        );
      },
    );

    it(
      "throws error when recurring plan missing stripeSubscriptionId",
      async () => {
        const dtoWithoutStripe = {
          ...createDto,
          stripeSubscriptionId: undefined,
        };
        repoMock.findPlanById.mockResolvedValue(fakePlan);
        repoMock.findActiveSubscriptionByUserId.mockResolvedValue(null);

        await expect(createSubscription(dtoWithoutStripe)).rejects.toThrow(
          "STRIPE_SUBSCRIPTION_ID_REQUIRED_FOR_RECURRING",
        );
      },
    );

    it(
      "throws error when plan is not recurring",
      async () => {
        const oneOffPlan: SubscriptionPlan = {
          ...fakePlan,
          billing: {
            type: "oneOff",
          },
        };

        repoMock.findPlanById.mockResolvedValue(oneOffPlan);
        repoMock.findActiveSubscriptionByUserId.mockResolvedValue(null);

        await expect(createSubscription(createDto)).rejects.toThrow(
          "ONLY_RECURRING_PLANS_CAN_CREATE_SUBSCRIPTIONS",
        );
      },
    );
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
      const updatedSubscription = {
        ...fakeSubscription,
        status: "cancelled" as const,
      };
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

    it(
      "throws SubscriptionNotFoundError when subscription not found",
      async () => {
        repoMock.findSubscriptionById.mockResolvedValue(null);

        await expect(updateSubscription("sub-1", {status: "active"})).rejects
          .toThrow(SubscriptionNotFoundError);
      },
    );

    it(
      "throws InvalidStatusTransitionError for invalid transition",
      async () => {
        repoMock.findSubscriptionById.mockResolvedValue(fakeSubscription);
        // Don't mock updateSubscription since it should throw before calling it
        // active -> trial is invalid (trial can only go to active or cancelled)

        await expect(
          updateSubscription("sub-1", {status: "trial"}),
        ).rejects.toThrow(InvalidStatusTransitionError);
        expect(repoMock.updateSubscription).not.toHaveBeenCalled();
      },
    );

    it("allows valid status transition", async () => {
      const trialSubscription = {
        ...fakeSubscription,
        status: "trial" as const,
      };
      const activeSubscription = {
        ...fakeSubscription,
        status: "active" as const,
      };
      repoMock.findSubscriptionById
        .mockResolvedValueOnce(trialSubscription)
        .mockResolvedValueOnce(activeSubscription);
      repoMock.updateSubscription.mockResolvedValue(activeSubscription);

      const result = await updateSubscription("sub-1", {status: "active"});

      expect(result.status).toBe("active");
    });

    // Note: Hours usage validation is now handled in Usage collection,
    // not subscriptions
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
        status: "cancelled" as const,
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

    it(
      "throws SubscriptionNotFoundError when subscription not found",
      async () => {
        repoMock.findSubscriptionById.mockResolvedValue(null);

        await expect(cancelSubscription("sub-1", false)).rejects.toThrow(
          SubscriptionNotFoundError,
        );
      },
    );
  });

  // Note: updateSubscriptionHours has been removed -
  // hours are now tracked in Usage collection

  describe("deleteSubscription", () => {
    it("deletes subscription successfully", async () => {
      repoMock.findSubscriptionById.mockResolvedValue(fakeSubscription);
      repoMock.deleteSubscription.mockResolvedValue(undefined);

      await deleteSubscription("sub-1");

      expect(repoMock.findSubscriptionById).toHaveBeenCalledWith("sub-1");
      expect(repoMock.deleteSubscription).toHaveBeenCalledWith("sub-1");
    });

    it(
      "throws SubscriptionNotFoundError when subscription not found",
      async () => {
        repoMock.findSubscriptionById.mockResolvedValue(null);

        await expect(deleteSubscription("sub-1")).rejects.toThrow(
          SubscriptionNotFoundError,
        );
      },
    );
  });

  describe("createPlan", () => {
    const planDto: SubscriptionPlanCreateDto = {
      name: "New Plan",
      category: "explore",
      billing: {
        type: "recurring",
        period: "month",
        intervalCount: 1,
      },
      quota: {
        deskHoursPerPeriod: 80,
        meetingHoursPerPeriod: 20,
        access: {
          type: "business",
          startTime: "09:00",
          endTime: "18:00",
        },
      },
      pricing: {
        currency: "usd",
        amount: 4999,
        billingDescription: "$49.99/month",
      },
      features: ["80 desk hours", "20 meeting room hours"],
      isActive: true,
      external: {
        stripeProductId: "prod_456",
        stripePriceId: "price_456",
      },
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

    // Note: Stripe IDs are now auto-created by the service if not provided
    // These validation tests are no longer applicable
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
      const updated = {
        ...fakePlan,
        pricing: {
          ...fakePlan.pricing,
          amount: 3999,
          billingDescription: "$39.99/month",
        },
      };
      repoMock.findPlanById
        .mockResolvedValueOnce(fakePlan)
        .mockResolvedValueOnce(updated);
      repoMock.findAllPlans.mockResolvedValue([fakePlan]);
      repoMock.updatePlan.mockResolvedValue(updated);

      const result = await updatePlan("plan-1", {
        pricing: {
          currency: "usd",
          amount: 3999,
          billingDescription: "$39.99/month",
        },
      });

      expect(result.pricing.amount).toBe(3999);
    });

    it("throws PlanNotFoundError when plan not found", async () => {
      repoMock.findPlanById.mockResolvedValue(null);

      await expect(
        updatePlan("plan-1", {
          pricing: {
            currency: "usd",
            amount: 3999,
            billingDescription: "$39.99/month",
          },
        }),
      ).rejects.toThrow(PlanNotFoundError);
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

