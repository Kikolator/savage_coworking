import 'package:flutter/foundation.dart';

import '../models/subscription.dart';
import '../models/subscription_failure.dart';
import '../models/subscription_plan.dart';
import '../repository/subscription_repository.dart';

class SubscriptionService {
  SubscriptionService(this._repository);

  final SubscriptionRepository _repository;

  Stream<Subscription?> watchActiveSubscription(String userId) {
    return _repository.watchActiveSubscription(userId);
  }

  Future<(Subscription?, SubscriptionFailure?)> getActiveSubscription(
    String userId,
  ) async {
    try {
      final subscription = await _repository.getActiveSubscription(userId);
      return (subscription, null);
    } catch (e) {
      return (null, SubscriptionFailure.unexpected(e.toString()));
    }
  }

  Future<(List<SubscriptionPlan>?, SubscriptionFailure?)> getActivePlans() async {
    try {
      final plans = await _repository.getActivePlans();
      return (plans, null);
    } catch (e) {
      return (null, SubscriptionFailure.unexpected(e.toString()));
    }
  }

  Future<(SubscriptionPlan?, SubscriptionFailure?)> getPlan(
    String planId,
  ) async {
    try {
      final plan = await _repository.getPlan(planId);
      if (plan == null) {
        return (null, const SubscriptionFailure.notFound());
      }
      return (plan, null);
    } catch (e) {
      return (null, SubscriptionFailure.unexpected(e.toString()));
    }
  }

  Future<SubscriptionFailure?> cancelSubscription(
    String subscriptionId, {
    bool cancelAtPeriodEnd = false,
  }) async {
    try {
      await _repository.updateSubscription(
        subscriptionId,
        cancelAtPeriodEnd
            ? {'cancelAtPeriodEnd': true}
            : {
                'status': 'cancelled',
                'cancelAtPeriodEnd': false,
              },
      );
      return null;
    } catch (e) {
      return SubscriptionFailure.unexpected(e.toString());
    }
  }

  Future<(Subscription?, SubscriptionFailure?)> createSubscription({
    required String userId,
    required SubscriptionPlan plan,
  }) async {
    if (kDebugMode) {
      debugPrint(
        'SubscriptionService: createSubscription called for user $userId, '
        'plan ${plan.name} (${plan.id})',
      );
    }

    try {
      // TODO: Integrate with Stripe checkout flow
      // For now, return a validation error indicating Stripe integration needed
      if (kDebugMode) {
        debugPrint(
          'SubscriptionService: Stripe integration not yet implemented. '
          'Plan selection logged but subscription creation deferred.',
        );
      }

      // Check if user already has an active subscription
      final existingSubscription = await _repository.getActiveSubscription(
        userId,
      );
      if (existingSubscription != null) {
        if (kDebugMode) {
          debugPrint(
            'SubscriptionService: User already has active subscription '
            '${existingSubscription.id}',
          );
        }
        return (
          null,
          const SubscriptionFailure.validation(
            'You already have an active subscription. '
            'Please cancel it before subscribing to a new plan.',
          ),
        );
      }

      // For now, return a validation error indicating Stripe is needed
      // Once Stripe is integrated, this will:
      // 1. Create Stripe checkout session
      // 2. Redirect user to Stripe payment page
      // 3. Handle webhook callback to create subscription in Firestore
      return (
        null,
        const SubscriptionFailure.validation(
          'Stripe checkout integration is not yet available. '
          'Please contact support to complete your subscription.',
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          'SubscriptionService: createSubscription error - $e',
        );
      }
      return (null, SubscriptionFailure.unexpected(e.toString()));
    }
  }
}


