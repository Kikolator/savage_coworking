import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/admin_dashboard_service.dart';
import '../viewmodel/admin_dashboard_view_model.dart';

final adminDashboardServiceProvider = Provider<AdminDashboardService>((ref) {
  return AdminDashboardService();
});

final adminDashboardViewModelProvider =
    StateNotifierProvider.autoDispose<AdminDashboardViewModel, AdminDashboardState>((ref) {
  final service = ref.watch(adminDashboardServiceProvider);
  return AdminDashboardViewModel(service);
});
