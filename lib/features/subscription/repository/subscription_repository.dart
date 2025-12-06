import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/subscription.dart';
import '../models/subscription_plan.dart';
import '../models/subscription_status.dart';

class SubscriptionRepository {
  SubscriptionRepository(this._firestore);

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

  Stream<Subscription?> watchActiveSubscription(String userId) {
    return _subscriptionsCollection
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: SubscriptionStatus.active.name)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return snapshot.docs.first.data();
    });
  }

  Future<Subscription?> getActiveSubscription(String userId) async {
    final snapshot = await _subscriptionsCollection
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: SubscriptionStatus.active.name)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }

  Future<Subscription?> getSubscription(String subscriptionId) async {
    final doc = await _subscriptionsCollection.doc(subscriptionId).get();
    if (!doc.exists) return null;
    return doc.data();
  }

  Future<List<SubscriptionPlan>> getActivePlans() async {
    final snapshot = await _plansCollection
        .where('isActive', isEqualTo: true)
        .orderBy('price')
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<SubscriptionPlan?> getPlan(String planId) async {
    final doc = await _plansCollection.doc(planId).get();
    if (!doc.exists) return null;
    return doc.data();
  }

  Future<void> updateSubscription(
    String subscriptionId,
    Map<String, dynamic> data,
  ) {
    data['updatedAt'] = Timestamp.fromDate(DateTime.now().toUtc());
    return _subscriptionsCollection.doc(subscriptionId).update(data);
  }
}


