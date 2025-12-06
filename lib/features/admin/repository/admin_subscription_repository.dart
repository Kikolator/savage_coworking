import 'package:cloud_firestore/cloud_firestore.dart';

import '../../subscription/models/subscription.dart';
import '../../subscription/models/subscription_plan.dart';
import '../../subscription/models/subscription_status.dart';
import '../models/admin_subscription_models.dart';

class AdminSubscriptionRepository {
  AdminSubscriptionRepository(this._firestore);

  final FirebaseFirestore _firestore;

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
      items.add(AdminSubscriptionListItem(
        subscription: subscription,
        userEmail: userData['email'] as String?,
        userDisplayName: userData['displayName'] as String?,
      ));
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

  /// Create a new subscription plan
  Future<SubscriptionPlan> createPlan(SubscriptionPlan plan) async {
    final docRef = _plansCollection.doc();
    final planToSave = plan.copyWith(id: docRef.id);
    await docRef.set(planToSave);
    return planToSave;
  }

  /// Update a subscription plan
  Future<void> updatePlan(String planId, Map<String, dynamic> updates) async {
    updates['updatedAt'] = Timestamp.fromDate(DateTime.now().toUtc());
    await _plansCollection.doc(planId).update(updates);
  }

  /// Delete a plan (soft delete by setting isActive to false)
  Future<void> deletePlan(String planId) async {
    await updatePlan(planId, {'isActive': false});
  }

  /// Update subscription status
  Future<void> updateSubscriptionStatus(
    String subscriptionId,
    SubscriptionStatus status,
  ) async {
    await updateSubscription(subscriptionId, {'status': status.name});
  }

  /// Cancel a subscription
  Future<void> cancelSubscription(
    String subscriptionId,
    bool immediate,
  ) async {
    final updates = <String, dynamic>{
      'cancelAtPeriodEnd': !immediate,
    };
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

