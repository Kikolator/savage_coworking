import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/admin_dashboard_data.dart';
import '../models/admin_dashboard_section.dart';
import '../service/admin_dashboard_service.dart';

class AdminDashboardState {
  const AdminDashboardState({
    this.isLoading = false,
    this.selectedSection = AdminDashboardSection.overview,
    this.data,
    this.errorMessage,
  });

  final bool isLoading;
  final AdminDashboardSection selectedSection;
  final AdminDashboardData? data;
  final String? errorMessage;

  AdminDashboardState copyWith({
    bool? isLoading,
    AdminDashboardSection? selectedSection,
    AdminDashboardData? data,
    bool clearData = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AdminDashboardState(
      isLoading: isLoading ?? this.isLoading,
      selectedSection: selectedSection ?? this.selectedSection,
      data: clearData ? null : data ?? this.data,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class AdminDashboardViewModel extends StateNotifier<AdminDashboardState> {
  AdminDashboardViewModel(this._service) : super(const AdminDashboardState());

  final AdminDashboardService _service;

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final data = await _service.loadDashboardSnapshot();
      state = state.copyWith(isLoading: false, data: data);
    } catch (error, stackTrace) {
      debugPrint('AdminDashboardViewModel.loadDashboard error: $error');
      debugPrint(stackTrace.toString());
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load admin data. Please try again.',
      );
    }
  }

  void selectSection(AdminDashboardSection section) {
    if (state.selectedSection == section) {
      return;
    }
    state = state.copyWith(selectedSection: section);
  }
}
