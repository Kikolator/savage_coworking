import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/dashboard_view_model.dart';

final dashboardViewModelProvider =
    StateNotifierProvider<DashboardViewModel, DashboardState>((ref) {
  return DashboardViewModel();
});


