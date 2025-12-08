import 'package:flutter/foundation.dart';

import '../../subscription/models/subscription_plan.dart';
import '../../subscription/models/subscription_status.dart';
import '../../subscription/models/plan_category.dart';
import '../../subscription/models/billing.dart';
import '../../subscription/models/billing_type.dart';
import '../../subscription/models/billing_period.dart';
import '../../subscription/models/quota.dart';
import '../../subscription/models/access.dart';
import '../../subscription/models/access_type.dart';
import '../../subscription/models/pricing.dart';
import '../../subscription/models/external.dart';
import '../../subscription/models/seat_type.dart';
import '../models/admin_subscription_models.dart';
import '../repository/admin_subscription_repository.dart';

class AdminSubscriptionService {
  AdminSubscriptionService(this._repository);

  final AdminSubscriptionRepository _repository;

  /// Fetch all subscriptions with filters
  Future<List<AdminSubscriptionListItem>> fetchAllSubscriptions({
    String? workspaceId,
    SubscriptionStatus? status,
  }) async {
    return await _repository.fetchAllSubscriptions(
      workspaceId: workspaceId,
      status: status,
    );
  }

  /// Fetch all plans
  Future<List<SubscriptionPlan>> fetchAllPlans() async {
    return await _repository.fetchAllPlans();
  }

  /// Create a new subscription plan
  Future<(SubscriptionPlan?, String?)> createPlan(
    AdminPlanFormData formData,
  ) async {
    // Validate required fields
    if (formData.name == null || formData.name!.isEmpty) {
      return (null, 'Plan name is required');
    }
    if (formData.category == null) {
      return (null, 'Plan category is required');
    }
    if (formData.billingType == null) {
      return (null, 'Billing type is required');
    }
    if (formData.billingType == BillingType.recurring &&
        formData.billingPeriod == null) {
      return (null, 'Billing period is required for recurring plans');
    }
    if (formData.price == null || formData.price! <= 0) {
      return (null, 'Price must be greater than 0');
    }
    if (formData.accessType == null) {
      return (null, 'Access type is required');
    }

    // Build nested structures
    final billing = Billing(
      type: formData.billingType!,
      period: formData.billingPeriod,
      intervalCount: formData.intervalCount,
    );

    final access = Access(
      type: formData.accessType!,
      startTime: formData.startTime,
      endTime: formData.endTime,
      allowedDaysOfWeek: formData.allowedDaysOfWeek ?? [],
    );

    final quota = Quota(
      dayPassCredits: formData.dayPassCredits,
      deskHoursPerPeriod: formData.deskHours,
      meetingHoursPerPeriod: formData.meetingRoomHours,
      access: access,
      seatType: formData.seatType,
    );

    final billingDescription =
        formData.billingDescription ??
        _generateBillingDescription(
          formData.price!,
          formData.currency,
          billing,
        );

    final pricing = Pricing(
      currency: formData.currency,
      amount: formData.price!,
      billingDescription: billingDescription,
      taxIncluded: formData.taxIncluded,
    );

    final external =
        (formData.stripePriceId != null || formData.stripeProductId != null)
        ? External(
            stripeProductId: formData.stripeProductId,
            stripePriceId: formData.stripePriceId,
          )
        : null;

    final now = DateTime.now().toUtc();
    final plan = SubscriptionPlan(
      id: '', // Will be set by repository
      name: formData.name!,
      category: formData.category!,
      billing: billing,
      quota: quota,
      pricing: pricing,
      external: external,
      features: formData.features,
      isActive: formData.isActive,
      createdAt: now,
      updatedAt: now,
    );

    try {
      final createdPlan = await _repository.createPlan(plan);
      return (createdPlan, null);
    } catch (e, stackTrace) {
      // Log the error
      debugPrint('AdminSubscriptionService.createPlan error: $e');
      debugPrint(stackTrace.toString());
      return (null, 'Failed to create plan: ${e.toString()}');
    }
  }

  String _generateBillingDescription(
    int amount,
    String currency,
    Billing billing,
  ) {
    final price = amount / 100;
    final currencySymbol = currency.toUpperCase() == 'USD' ? '\$' : currency;
    if (billing.type == BillingType.oneOff) {
      return '$currencySymbol${price.toStringAsFixed(2)}';
    }
    final period = billing.period?.label.toLowerCase() ?? 'month';
    final interval = billing.intervalCount > 1
        ? 'every ${billing.intervalCount} ${period}s'
        : 'per $period';
    return '$currencySymbol${price.toStringAsFixed(2)}/$interval';
  }

  /// Update a subscription plan
  Future<(SubscriptionPlan?, String?)> updatePlan(
    String planId,
    AdminPlanFormData formData,
  ) async {
    // Validate required fields if provided
    if (formData.name != null && formData.name!.isEmpty) {
      return (null, 'Plan name cannot be empty');
    }
    if (formData.price != null && formData.price! <= 0) {
      return (null, 'Price must be greater than 0');
    }
    if (formData.deskHours != null && formData.deskHours! < 0) {
      return (null, 'Desk hours must be 0 or greater');
    }
    if (formData.meetingRoomHours != null && formData.meetingRoomHours! < 0) {
      return (null, 'Meeting room hours must be 0 or greater');
    }

    // Build update map with new structure
    final updates = <String, dynamic>{};
    if (formData.name != null) updates['name'] = formData.name;
    if (formData.category != null) {
      updates['category'] = formData.category!.toJson();
    }
    if (formData.billingType != null || formData.billingPeriod != null) {
      final existingPlan = (await _repository.fetchAllPlans()).firstWhere(
        (p) => p.id == planId,
      );
      updates['billing'] = {
        'type': (formData.billingType ?? existingPlan.billing.type).toJson(),
        'period':
            formData.billingPeriod?.toJson() ??
            existingPlan.billing.period?.toJson(),
        'intervalCount': formData.intervalCount,
      };
    }
    if (formData.price != null) {
      final existingPlan = (await _repository.fetchAllPlans()).firstWhere(
        (p) => p.id == planId,
      );
      final billingDescription =
          formData.billingDescription ??
          _generateBillingDescription(
            formData.price ?? existingPlan.pricing.amount,
            formData.currency,
            formData.billingType != null || formData.billingPeriod != null
                ? Billing(
                    type: formData.billingType ?? existingPlan.billing.type,
                    period:
                        formData.billingPeriod ?? existingPlan.billing.period,
                    intervalCount: formData.intervalCount,
                  )
                : existingPlan.billing,
          );
      updates['pricing'] = {
        'currency': formData.currency,
        'amount': formData.price ?? existingPlan.pricing.amount,
        'billingDescription': billingDescription,
        'taxIncluded': formData.taxIncluded,
      };
    }
    if (formData.deskHours != null ||
        formData.meetingRoomHours != null ||
        formData.accessType != null) {
      final existingPlan = (await _repository.fetchAllPlans()).firstWhere(
        (p) => p.id == planId,
      );
      updates['quota'] = {
        'dayPassCredits':
            formData.dayPassCredits ?? existingPlan.quota.dayPassCredits,
        'deskHoursPerPeriod':
            formData.deskHours ?? existingPlan.quota.deskHoursPerPeriod,
        'meetingHoursPerPeriod':
            formData.meetingRoomHours ??
            existingPlan.quota.meetingHoursPerPeriod,
        'access': {
          'type': (formData.accessType ?? existingPlan.quota.access.type)
              .toJson(),
          'startTime':
              formData.startTime ?? existingPlan.quota.access.startTime,
          'endTime': formData.endTime ?? existingPlan.quota.access.endTime,
          'allowedDaysOfWeek': formData.allowedDaysOfWeek ??
              existingPlan.quota.access.allowedDaysOfWeek,
        },
        'seatType': formData.seatType != null
            ? formData.seatType!.toJson()
            : existingPlan.quota.seatType != null
            ? existingPlan.quota.seatType!.toJson()
            : null,
      };
    }
    updates['features'] = formData.features;
    updates['isActive'] = formData.isActive;
    if (formData.stripePriceId != null || formData.stripeProductId != null) {
      final existingPlan = (await _repository.fetchAllPlans()).firstWhere(
        (p) => p.id == planId,
      );
      updates['external'] = {
        'stripeProductId':
            formData.stripeProductId ?? existingPlan.external?.stripeProductId,
        'stripePriceId':
            formData.stripePriceId ?? existingPlan.external?.stripePriceId,
      };
    }

    try {
      await _repository.updatePlan(planId, updates);
      // Fetch updated plan
      final plans = await _repository.fetchAllPlans();
      final updatedPlan = plans.firstWhere((p) => p.id == planId);
      return (updatedPlan, null);
    } catch (e) {
      return (null, 'Failed to update plan: ${e.toString()}');
    }
  }

  /// Delete a plan (soft delete)
  Future<String?> deletePlan(String planId) async {
    // Check if plan has active subscriptions
    final hasActive = await _repository.hasActiveSubscriptions(planId);
    if (hasActive) {
      return 'Cannot delete plan with active subscriptions. Deactivate it instead.';
    }

    try {
      await _repository.deletePlan(planId);
      return null;
    } catch (e) {
      return 'Failed to delete plan: ${e.toString()}';
    }
  }

  /// Update subscription status
  Future<String?> updateSubscriptionStatus(
    String subscriptionId,
    SubscriptionStatus newStatus,
  ) async {
    // Get current subscription
    final subscriptionItem = await _repository.getSubscriptionWithUser(
      subscriptionId,
    );
    if (subscriptionItem == null) {
      return 'Subscription not found';
    }

    final currentStatus = subscriptionItem.subscription.status;

    // Validate status transition
    if (!_isValidStatusTransition(currentStatus, newStatus)) {
      return 'Invalid status transition from ${currentStatus.name} to ${newStatus.name}';
    }

    try {
      await _repository.updateSubscriptionStatus(subscriptionId, newStatus);
      return null;
    } catch (e) {
      return 'Failed to update subscription status: ${e.toString()}';
    }
  }

  /// Cancel a subscription
  Future<String?> cancelSubscription(
    String subscriptionId,
    bool immediate,
  ) async {
    try {
      await _repository.cancelSubscription(subscriptionId, immediate);
      return null;
    } catch (e) {
      return 'Failed to cancel subscription: ${e.toString()}';
    }
  }

  /// Calculate MRR (Monthly Recurring Revenue)
  Future<double> calculateMRR() async {
    final subscriptions = await _repository.fetchAllSubscriptions(
      status: SubscriptionStatus.active,
    );

    double mrr = 0.0;
    for (final item in subscriptions) {
      final subscription = item.subscription;
      // All subscriptions in new model are recurring (billing.type === 'recurring')
      if (subscription.billing.type == BillingType.recurring) {
        // Fetch plan to get price
        final plans = await _repository.fetchAllPlans();
        final plan = plans.firstWhere(
          (p) => p.id == subscription.planId,
          orElse: () => plans.first, // Fallback (shouldn't happen)
        );
        // Add monthly price (assuming price is in cents)
        // Only count if billing period is month
        if (plan.billing.period == BillingPeriod.month) {
          mrr += plan.pricing.amount / 100;
        }
      }
    }

    return mrr;
  }

  /// Validate status transition
  bool _isValidStatusTransition(
    SubscriptionStatus from,
    SubscriptionStatus to,
  ) {
    // Same status is always valid
    if (from == to) return true;

    // Define valid transitions
    switch (from) {
      case SubscriptionStatus.trial:
        return to == SubscriptionStatus.active ||
            to == SubscriptionStatus.cancelled;
      case SubscriptionStatus.active:
        return to == SubscriptionStatus.cancelled ||
            to == SubscriptionStatus.pastDue ||
            to == SubscriptionStatus.expired;
      case SubscriptionStatus.pastDue:
        return to == SubscriptionStatus.active ||
            to == SubscriptionStatus.cancelled ||
            to == SubscriptionStatus.expired;
      case SubscriptionStatus.cancelled:
        return false; // Cannot transition from cancelled
      case SubscriptionStatus.expired:
        return false; // Cannot transition from expired
    }
  }
}
