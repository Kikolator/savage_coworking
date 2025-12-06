import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../repository/admin_dashboard_repository.dart';
import '../service/admin_dashboard_service.dart';
import '../viewmodel/admin_dashboard_view_model.dart';

final adminDashboardRepositoryProvider =
    Provider<AdminDashboardRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return AdminDashboardRepository(firestore);
});

final adminDashboardServiceProvider = Provider<AdminDashboardService>((ref) {
  final repository = ref.watch(adminDashboardRepositoryProvider);
  return AdminDashboardService(repository);
});

final adminDashboardViewModelProvider =
    StateNotifierProvider.autoDispose<AdminDashboardViewModel, AdminDashboardState>((ref) {
  final service = ref.watch(adminDashboardServiceProvider);
  return AdminDashboardViewModel(service);
});
