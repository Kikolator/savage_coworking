import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../repository/admin_subscription_repository.dart';
import '../service/admin_subscription_service.dart';
import '../viewmodel/admin_subscription_view_model.dart';

final adminSubscriptionRepositoryProvider =
    Provider<AdminSubscriptionRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return AdminSubscriptionRepository(firestore);
});

final adminSubscriptionServiceProvider =
    Provider<AdminSubscriptionService>((ref) {
  final repository = ref.watch(adminSubscriptionRepositoryProvider);
  return AdminSubscriptionService(repository);
});

final adminSubscriptionViewModelProvider =
    StateNotifierProvider.autoDispose<AdminSubscriptionViewModel,
        AdminSubscriptionState>((ref) {
  final service = ref.watch(adminSubscriptionServiceProvider);
  return AdminSubscriptionViewModel(service);
});

