import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/subscription_repository.dart';
import '../service/subscription_service.dart';
import '../viewmodel/subscription_view_model.dart';

final subscriptionRepositoryProvider =
    Provider<SubscriptionRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return SubscriptionRepository(firestore);
});

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return SubscriptionService(repository);
});

final subscriptionViewModelProvider = StateNotifierProvider.autoDispose
    .family<SubscriptionViewModel, SubscriptionState, String>((
      ref,
      userId,
    ) {
      final service = ref.watch(subscriptionServiceProvider);
      return SubscriptionViewModel(service, userId);
    });

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});


