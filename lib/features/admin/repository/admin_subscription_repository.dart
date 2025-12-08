import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

import '../../../core/services/firebase_functions_service.dart';
import '../../subscription/models/subscription.dart';
import '../../subscription/models/subscription_plan.dart';
import '../../subscription/models/subscription_status.dart';
import '../../subscription/models/plan_category.dart';
import '../../subscription/models/billing_type.dart';
import '../../subscription/models/billing_period.dart';
import '../../subscription/models/access_type.dart';
import '../../subscription/models/seat_type.dart';
import '../models/admin_subscription_models.dart';

class AdminSubscriptionRepository {
  AdminSubscriptionRepository(this._firestore, this._functionsService);

  final FirebaseFirestore _firestore;
  final FirebaseFunctionsService _functionsService;

  /// Converts Firebase Functions timestamp serialization to Firestore Timestamp
  /// Firebase Functions serializes Timestamps as {seconds: number, nanoseconds: number}
  /// or sometimes as {_seconds: number, _nanoseconds: number}
  /// Also handles cases where it's already a Timestamp object
  void _convertTimestamps(Map<String, dynamic> result) {
    // Handle createdAt
    if (result['createdAt'] is! Timestamp) {
      if (result['createdAt'] is Map) {
        try {
          final createdAtMap = result['createdAt'] as Map<String, dynamic>;
          final secondsValue =
              createdAtMap['seconds'] ?? createdAtMap['_seconds'];
          final nanosecondsValue =
              createdAtMap['nanoseconds'] ?? createdAtMap['_nanoseconds'];

          if (secondsValue != null && secondsValue is num) {
            final seconds = secondsValue.toInt();
            final nanoseconds = (nanosecondsValue is num)
                ? nanosecondsValue.toInt()
                : (nanosecondsValue as int?) ?? 0;

            result['createdAt'] = Timestamp(seconds, nanoseconds);
          } else {
            debugPrint(
              'Warning: createdAt timestamp invalid format. '
              'seconds: $secondsValue (${secondsValue?.runtimeType}), '
              'nanoseconds: $nanosecondsValue (${nanosecondsValue?.runtimeType}), '
              'map: $createdAtMap',
            );
            result['createdAt'] = Timestamp.now();
          }
        } catch (e, stackTrace) {
          debugPrint(
            'Error converting createdAt timestamp: $e. Value: ${result['createdAt']}',
          );
          debugPrint(stackTrace.toString());
          result['createdAt'] = Timestamp.now();
        }
      } else if (result['createdAt'] == null) {
        result['createdAt'] = Timestamp.now();
      }
    }

    // Handle updatedAt
    if (result['updatedAt'] is! Timestamp) {
      if (result['updatedAt'] is Map) {
        try {
          final updatedAtMap = result['updatedAt'] as Map<String, dynamic>;
          final secondsValue =
              updatedAtMap['seconds'] ?? updatedAtMap['_seconds'];
          final nanosecondsValue =
              updatedAtMap['nanoseconds'] ?? updatedAtMap['_nanoseconds'];

          if (secondsValue != null && secondsValue is num) {
            final seconds = secondsValue.toInt();
            final nanoseconds = (nanosecondsValue is num)
                ? nanosecondsValue.toInt()
                : (nanosecondsValue as int?) ?? 0;

            result['updatedAt'] = Timestamp(seconds, nanoseconds);
          } else {
            debugPrint(
              'Warning: updatedAt timestamp invalid format. '
              'seconds: $secondsValue (${secondsValue?.runtimeType}), '
              'nanoseconds: $nanosecondsValue (${nanosecondsValue?.runtimeType}), '
              'map: $updatedAtMap',
            );
            result['updatedAt'] = Timestamp.now();
          }
        } catch (e, stackTrace) {
          debugPrint(
            'Error converting updatedAt timestamp: $e. Value: ${result['updatedAt']}',
          );
          debugPrint(stackTrace.toString());
          result['updatedAt'] = Timestamp.now();
        }
      } else if (result['updatedAt'] == null) {
        result['updatedAt'] = Timestamp.now();
      }
    }
  }

  CollectionReference<Subscription> get _subscriptionsCollection => _firestore
      .collection('subscriptions')
      .withConverter(
        fromFirestore: (snapshot, _) {
          final data = snapshot.data();
          if (data == null) {
            throw StateError('Subscription document ${snapshot.id} is empty');
          }
          return Subscription.fromJson({...data, 'id': snapshot.id});
        },
        toFirestore: (subscription, _) => subscription.toJson(),
      );

  CollectionReference<SubscriptionPlan> get _plansCollection => _firestore
      .collection('subscriptionPlans')
      .withConverter(
        fromFirestore: (snapshot, _) {
          final data = snapshot.data();
          if (data == null) {
            throw StateError('Plan document ${snapshot.id} is empty');
          }
          return SubscriptionPlan.fromJson({...data, 'id': snapshot.id});
        },
        toFirestore: (plan, _) => plan.toJson(),
      );

  /// Fetch all subscriptions with optional filters
  Future<List<AdminSubscriptionListItem>> fetchAllSubscriptions({
    String? workspaceId,
    SubscriptionStatus? status,
  }) async {
    Query<Subscription> query = _subscriptionsCollection;

    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }

    // Note: workspaceId filtering would require joining with user data
    // For now, we fetch all and filter in memory if needed

    final snapshot = await query.orderBy('createdAt', descending: true).get();
    final subscriptions = snapshot.docs.map((doc) => doc.data()).toList();

    // Fetch user data for each subscription
    final items = <AdminSubscriptionListItem>[];
    for (final subscription in subscriptions) {
      final userData = await _fetchUserData(subscription.userId);
      items.add(
        AdminSubscriptionListItem(
          subscription: subscription,
          userEmail: userData['email'] as String?,
          userDisplayName: userData['displayName'] as String?,
        ),
      );
    }

    return items;
  }

  /// Fetch user data from users collection
  Future<Map<String, dynamic>> _fetchUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        return {};
      }
      return doc.data() ?? {};
    } catch (_) {
      return {};
    }
  }

  /// Fetch all plans (active and inactive)
  Future<List<SubscriptionPlan>> fetchAllPlans() async {
    final snapshot = await _plansCollection.orderBy('price').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Create a new subscription plan via callable function
  Future<SubscriptionPlan> createPlan(SubscriptionPlan plan) async {
    try {
      final data = {
        'name': plan.name,
        'category': PlanCategoryX(plan.category).toJson(),
        'billing': {
          'type': BillingTypeX(plan.billing.type).toJson(),
          'period': plan.billing.period != null
              ? BillingPeriodX(plan.billing.period!).toJson()
              : null,
          'intervalCount': plan.billing.intervalCount,
        },
        'quota': {
          'dayPassCredits': plan.quota.dayPassCredits,
          'deskHoursPerPeriod': plan.quota.deskHoursPerPeriod,
          'meetingHoursPerPeriod': plan.quota.meetingHoursPerPeriod,
          'access': {
            'type': AccessTypeX(plan.quota.access.type).toJson(),
            'startTime': plan.quota.access.startTime,
            'endTime': plan.quota.access.endTime,
            'allowedDaysOfWeek': plan.quota.access.allowedDaysOfWeek,
          },
          if (plan.quota.seatType != null)
            'seatType': SeatTypeX(plan.quota.seatType!).toJson(),
        },
        'pricing': {
          'currency': plan.pricing.currency,
          'amount': plan.pricing.amount,
          'billingDescription': plan.pricing.billingDescription,
        },
        'features': plan.features,
        'isActive': plan.isActive,
        // Stripe IDs are optional - backend will auto-create them
        if (plan.external != null) ...{
          'external': {
            if (plan.external!.stripeProductId != null)
              'stripeProductId': plan.external!.stripeProductId,
            if (plan.external!.stripePriceId != null)
              'stripePriceId': plan.external!.stripePriceId,
          },
        },
      };

      final result = await _functionsService.callFunction<Map<String, dynamic>>(
        functionName: 'createPlan',
        data: data,
      );

      // Log the raw result for debugging
      if (kDebugMode) {
        debugPrint(
          'AdminSubscriptionRepository.createPlan raw result: $result',
        );
        debugPrint(
          'createdAt type: ${result['createdAt']?.runtimeType}, value: ${result['createdAt']}',
        );
        debugPrint(
          'updatedAt type: ${result['updatedAt']?.runtimeType}, value: ${result['updatedAt']}',
        );
      }

      // Convert timestamp format from Firebase Functions serialization
      _convertTimestamps(result);

      try {
        return SubscriptionPlan.fromJson(result);
      } catch (e, stackTrace) {
        // If parsing fails, try to fetch from Firestore as fallback
        debugPrint(
          'Error parsing plan from callable response: $e. Attempting to fetch from Firestore...',
        );
        debugPrint(stackTrace.toString());

        final planId = result['id'] as String?;
        if (planId != null) {
          try {
            final planDoc = await _plansCollection.doc(planId).get();
            if (planDoc.exists) {
              debugPrint(
                'Successfully fetched plan from Firestore as fallback',
              );
              return planDoc.data()!;
            }
          } catch (fetchError) {
            debugPrint('Error fetching plan from Firestore: $fetchError');
          }
        }

        // If all else fails, rethrow the original error
        rethrow;
      }
    } on FirebaseFunctionsException catch (e) {
      // Log the error before throwing
      debugPrint(
        'AdminSubscriptionRepository.createPlan error: ${e.code} - ${e.message}',
      );
      if (e.details != null) {
        debugPrint('Details: ${e.details}');
      }
      throw Exception('Failed to create plan: ${e.message ?? e.code}');
    } catch (e, stackTrace) {
      // Log any other errors
      debugPrint('AdminSubscriptionRepository.createPlan unexpected error: $e');
      debugPrint(stackTrace.toString());
      rethrow;
    }
  }

  /// Update a subscription plan via callable function
  Future<void> updatePlan(String planId, Map<String, dynamic> updates) async {
    try {
      // Convert nested enums to strings if present
      if (updates.containsKey('category') && updates['category'] is! String) {
        // Assume it's a PlanCategory enum
        final category = updates['category'];
        if (category.toString().contains('PlanCategory')) {
          // Extract the enum value name
          updates['category'] = category.toString().split('.').last;
        }
      }

      final data = {'planId': planId, ...updates};

      await _functionsService.callFunction(
        functionName: 'updatePlan',
        data: data,
      );
    } on FirebaseFunctionsException catch (e) {
      // Log the error before throwing
      debugPrint(
        'AdminSubscriptionRepository.updatePlan error: ${e.code} - ${e.message}',
      );
      if (e.details != null) {
        debugPrint('Details: ${e.details}');
      }
      throw Exception('Failed to update plan: ${e.message ?? e.code}');
    } catch (e, stackTrace) {
      // Log any other errors
      debugPrint('AdminSubscriptionRepository.updatePlan unexpected error: $e');
      debugPrint(stackTrace.toString());
      rethrow;
    }
  }

  /// Delete a plan via callable function
  Future<void> deletePlan(String planId) async {
    try {
      await _functionsService.callFunction(
        functionName: 'deletePlan',
        data: {'planId': planId},
      );
    } on FirebaseFunctionsException catch (e) {
      // Log the error before throwing
      debugPrint(
        'AdminSubscriptionRepository.deletePlan error: ${e.code} - ${e.message}',
      );
      if (e.details != null) {
        debugPrint('Details: ${e.details}');
      }
      throw Exception('Failed to delete plan: ${e.message ?? e.code}');
    } catch (e, stackTrace) {
      // Log any other errors
      debugPrint('AdminSubscriptionRepository.deletePlan unexpected error: $e');
      debugPrint(stackTrace.toString());
      rethrow;
    }
  }

  /// Update subscription status
  Future<void> updateSubscriptionStatus(
    String subscriptionId,
    SubscriptionStatus status,
  ) async {
    await updateSubscription(subscriptionId, {'status': status.name});
  }

  /// Cancel a subscription
  Future<void> cancelSubscription(String subscriptionId, bool immediate) async {
    final updates = <String, dynamic>{'cancelAtPeriodEnd': !immediate};
    if (immediate) {
      updates['status'] = SubscriptionStatus.cancelled.name;
    }
    await updateSubscription(subscriptionId, updates);
  }

  /// Update subscription fields
  Future<void> updateSubscription(
    String subscriptionId,
    Map<String, dynamic> data,
  ) async {
    data['updatedAt'] = Timestamp.fromDate(DateTime.now().toUtc());
    await _subscriptionsCollection.doc(subscriptionId).update(data);
  }

  /// Get subscription with user details
  Future<AdminSubscriptionListItem?> getSubscriptionWithUser(
    String subscriptionId,
  ) async {
    final subscription = await _subscriptionsCollection
        .doc(subscriptionId)
        .get()
        .then((doc) => doc.exists ? doc.data() : null);

    if (subscription == null) return null;

    final userData = await _fetchUserData(subscription.userId);
    return AdminSubscriptionListItem(
      subscription: subscription,
      userEmail: userData['email'] as String?,
      userDisplayName: userData['displayName'] as String?,
    );
  }

  /// Check if plan has active subscriptions
  Future<bool> hasActiveSubscriptions(String planId) async {
    final snapshot = await _subscriptionsCollection
        .where('planId', isEqualTo: planId)
        .where('status', isEqualTo: SubscriptionStatus.active.name)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }
}
