import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/firebase_functions_service.dart';
import '../models/subscription.dart';
import '../models/subscription_failure.dart';
import '../models/subscription_plan.dart';
import '../repository/subscription_repository.dart';

class SubscriptionService {
  SubscriptionService(this._repository, this._functionsService);

  final SubscriptionRepository _repository;
  final FirebaseFunctionsService _functionsService;

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

  Future<(List<SubscriptionPlan>?, SubscriptionFailure?)>
  getActivePlans() async {
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
            : {'status': 'cancelled', 'cancelAtPeriodEnd': false},
      );
      return null;
    } catch (e) {
      return SubscriptionFailure.unexpected(e.toString());
    }
  }

  Future<(Subscription?, SubscriptionFailure?)> createSubscription({
    required String userId,
    required SubscriptionPlan plan,
    required String userEmail,
  }) async {
    if (kDebugMode) {
      debugPrint(
        'SubscriptionService: createSubscription called for user $userId, '
        'plan ${plan.name} (${plan.id})',
      );
    }

    try {
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

      // Create checkout session
      final checkoutUrl = await createCheckoutSession(
        userId: userId,
        planId: plan.id,
        customerEmail: userEmail,
      );

      if (checkoutUrl == null) {
        return (
          null,
          const SubscriptionFailure.unexpected(
            'Failed to create checkout session. Please try again.',
          ),
        );
      }

      // Open Stripe checkout URL
      final uri = Uri.parse(checkoutUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        // Return success - subscription will be created via webhook
        // The UI should show a message that payment is in progress
        return (null, null);
      } else {
        return (
          null,
          const SubscriptionFailure.unexpected(
            'Unable to open checkout page. Please check your browser settings.',
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SubscriptionService: createSubscription error - $e');
      }
      return (null, SubscriptionFailure.unexpected(e.toString()));
    }
  }

  /// Creates a Stripe checkout session and returns the checkout URL.
  Future<String?> createCheckoutSession({
    required String userId,
    required String planId,
    required String customerEmail,
  }) async {
    try {
      // Determine base URL for redirects
      // For web, use current origin; for mobile, use a deep link scheme
      String baseUrl;
      if (kIsWeb) {
        baseUrl = Uri.base.origin;
      } else {
        // For mobile apps, use a custom URL scheme or your app's domain
        // You may want to make this configurable
        baseUrl = 'https://your-app.com';
      }

      // Call Firebase callable function
      final result = await _functionsService.callFunctionWithMap(
        functionName: 'createCheckoutSession',
        data: {
          'userId': userId,
          'planId': planId,
          'customerEmail': customerEmail,
          'baseUrl': baseUrl,
        },
      );

      final checkoutUrl = result['checkoutUrl'] as String?;
      if (checkoutUrl != null) {
        return checkoutUrl;
      }
      throw Exception('Invalid response format: missing checkoutUrl');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SubscriptionService: createCheckoutSession error - $e');
      }
      return null;
    }
  }
}
