import '../../subscription/models/subscription_plan.dart';
import '../../subscription/models/subscription_interval.dart';
import '../../subscription/models/subscription_status.dart';
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
    if (formData.price == null || formData.price! <= 0) {
      return (null, 'Price must be greater than 0');
    }
    if (formData.interval == null) {
      return (null, 'Billing interval is required');
    }
    if (formData.deskHours == null || formData.deskHours! < 0) {
      return (null, 'Desk hours must be 0 or greater');
    }
    if (formData.meetingRoomHours == null || formData.meetingRoomHours! < 0) {
      return (null, 'Meeting room hours must be 0 or greater');
    }

    // Validate Stripe IDs for recurring plans
    if (formData.interval == SubscriptionInterval.month &&
        formData.stripePriceId != null &&
        formData.stripePriceId!.isEmpty) {
      return (null, 'Stripe Price ID is required for recurring plans');
    }

    final now = DateTime.now().toUtc();
    final plan = SubscriptionPlan(
      id: '', // Will be set by repository
      name: formData.name!,
      price: formData.price!,
      currency: formData.currency,
      interval: formData.interval!,
      deskHours: formData.deskHours!,
      meetingRoomHours: formData.meetingRoomHours!,
      features: formData.features,
      isActive: formData.isActive,
      stripePriceId: formData.stripePriceId,
      stripeProductId: formData.stripeProductId,
      createdAt: now,
      updatedAt: now,
    );

    try {
      final createdPlan = await _repository.createPlan(plan);
      return (createdPlan, null);
    } catch (e) {
      return (null, 'Failed to create plan: ${e.toString()}');
    }
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

    final updates = <String, dynamic>{};
    if (formData.name != null) updates['name'] = formData.name;
    if (formData.price != null) updates['price'] = formData.price;
    updates['currency'] = formData.currency;
    if (formData.interval != null) updates['interval'] = formData.interval!.name;
    if (formData.deskHours != null) updates['deskHours'] = formData.deskHours;
    if (formData.meetingRoomHours != null) {
      updates['meetingRoomHours'] = formData.meetingRoomHours;
    }
    updates['features'] = formData.features;
    updates['isActive'] = formData.isActive;
    if (formData.stripePriceId != null) {
      updates['stripePriceId'] = formData.stripePriceId;
    }
    if (formData.stripeProductId != null) {
      updates['stripeProductId'] = formData.stripeProductId;
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
      if (subscription.renewsAutomatically) {
        // Fetch plan to get price
        final plans = await _repository.fetchAllPlans();
        final plan = plans.firstWhere(
          (p) => p.id == subscription.planId,
          orElse: () => plans.first, // Fallback (shouldn't happen)
        );
        // Add monthly price (assuming price is in cents)
        mrr += plan.price / 100;
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

