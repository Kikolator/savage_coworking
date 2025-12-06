import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../subscription/models/subscription_plan.dart';
import '../../subscription/models/subscription_status.dart';
import '../models/admin_subscription_models.dart';
import '../service/admin_subscription_service.dart';

class AdminSubscriptionState {
  const AdminSubscriptionState({
    this.isLoading = false,
    this.subscriptions = const [],
    this.plans = const [],
    this.selectedSubscription,
    this.selectedPlan,
    this.filters = const AdminSubscriptionFilters(),
    this.errorMessage,
    this.successMessage,
  });

  final bool isLoading;
  final List<AdminSubscriptionListItem> subscriptions;
  final List<SubscriptionPlan> plans;
  final AdminSubscriptionListItem? selectedSubscription;
  final SubscriptionPlan? selectedPlan;
  final AdminSubscriptionFilters filters;
  final String? errorMessage;
  final String? successMessage;

  AdminSubscriptionState copyWith({
    bool? isLoading,
    List<AdminSubscriptionListItem>? subscriptions,
    List<SubscriptionPlan>? plans,
    AdminSubscriptionListItem? selectedSubscription,
    bool clearSelectedSubscription = false,
    SubscriptionPlan? selectedPlan,
    bool clearSelectedPlan = false,
    AdminSubscriptionFilters? filters,
    String? errorMessage,
    bool clearError = false,
    String? successMessage,
    bool clearSuccess = false,
  }) {
    return AdminSubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      subscriptions: subscriptions ?? this.subscriptions,
      plans: plans ?? this.plans,
      selectedSubscription: clearSelectedSubscription
          ? null
          : (selectedSubscription ?? this.selectedSubscription),
      selectedPlan:
          clearSelectedPlan ? null : (selectedPlan ?? this.selectedPlan),
      filters: filters ?? this.filters,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}

class AdminSubscriptionViewModel
    extends StateNotifier<AdminSubscriptionState> {
  AdminSubscriptionViewModel(this._service)
      : super(const AdminSubscriptionState());

  final AdminSubscriptionService _service;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// Load all subscriptions with current filters
  Future<void> loadSubscriptions() async {
    if (_isDisposed) return;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final subscriptions = await _service.fetchAllSubscriptions(
        status: state.filters.status,
      );

      // Apply search filter if present
      final filtered = state.filters.searchQuery != null &&
              state.filters.searchQuery!.isNotEmpty
          ? subscriptions.where((item) {
              final query = state.filters.searchQuery!.toLowerCase();
              return item.displayName.toLowerCase().contains(query) ||
                  item.subscription.planName.toLowerCase().contains(query) ||
                  item.userEmail?.toLowerCase().contains(query) == true;
            }).toList()
          : subscriptions;

      if (_isDisposed) return;
      state = state.copyWith(
        isLoading: false,
        subscriptions: filtered,
      );
    } catch (error, stackTrace) {
      if (_isDisposed) return;
      debugPrint('AdminSubscriptionViewModel.loadSubscriptions error: $error');
      debugPrint(stackTrace.toString());
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load subscriptions. Please try again.',
      );
    }
  }

  /// Load all plans
  Future<void> loadPlans() async {
    if (_isDisposed) return;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final plans = await _service.fetchAllPlans();
      if (_isDisposed) return;
      state = state.copyWith(isLoading: false, plans: plans);
    } catch (error, stackTrace) {
      if (_isDisposed) return;
      debugPrint('AdminSubscriptionViewModel.loadPlans error: $error');
      debugPrint(stackTrace.toString());
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load plans. Please try again.',
      );
    }
  }

  /// Create a new plan
  Future<void> createPlan(AdminPlanFormData formData) async {
    if (_isDisposed) return;

    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      final (plan, error) = await _service.createPlan(formData);
      if (_isDisposed) return;

      if (error != null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error,
        );
        return;
      }

      // Reload plans
      await loadPlans();
      if (_isDisposed) return;

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Plan created successfully',
        clearSelectedPlan: true,
      );
    } catch (error, stackTrace) {
      if (_isDisposed) return;
      debugPrint('AdminSubscriptionViewModel.createPlan error: $error');
      debugPrint(stackTrace.toString());
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create plan. Please try again.',
      );
    }
  }

  /// Update a plan
  Future<void> updatePlan(String planId, AdminPlanFormData formData) async {
    if (_isDisposed) return;

    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      final (plan, error) = await _service.updatePlan(planId, formData);
      if (_isDisposed) return;

      if (error != null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error,
        );
        return;
      }

      // Reload plans
      await loadPlans();
      if (_isDisposed) return;

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Plan updated successfully',
        clearSelectedPlan: true,
      );
    } catch (error, stackTrace) {
      if (_isDisposed) return;
      debugPrint('AdminSubscriptionViewModel.updatePlan error: $error');
      debugPrint(stackTrace.toString());
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update plan. Please try again.',
      );
    }
  }

  /// Delete a plan
  Future<void> deletePlan(String planId) async {
    if (_isDisposed) return;

    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      final error = await _service.deletePlan(planId);
      if (_isDisposed) return;

      if (error != null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error,
        );
        return;
      }

      // Reload plans
      await loadPlans();
      if (_isDisposed) return;

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Plan deleted successfully',
        clearSelectedPlan: true,
      );
    } catch (error, stackTrace) {
      if (_isDisposed) return;
      debugPrint('AdminSubscriptionViewModel.deletePlan error: $error');
      debugPrint(stackTrace.toString());
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete plan. Please try again.',
      );
    }
  }

  /// Update subscription status
  Future<void> updateSubscriptionStatus(
    String subscriptionId,
    SubscriptionStatus status,
  ) async {
    if (_isDisposed) return;

    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      final error = await _service.updateSubscriptionStatus(
        subscriptionId,
        status,
      );
      if (_isDisposed) return;

      if (error != null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error,
        );
        return;
      }

      // Reload subscriptions
      await loadSubscriptions();
      if (_isDisposed) return;

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Subscription status updated successfully',
        clearSelectedSubscription: true,
      );
    } catch (error, stackTrace) {
      if (_isDisposed) return;
      debugPrint(
        'AdminSubscriptionViewModel.updateSubscriptionStatus error: $error',
      );
      debugPrint(stackTrace.toString());
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update subscription status. Please try again.',
      );
    }
  }

  /// Cancel a subscription
  Future<void> cancelSubscription(String subscriptionId, bool immediate) async {
    if (_isDisposed) return;

    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      final error = await _service.cancelSubscription(subscriptionId, immediate);
      if (_isDisposed) return;

      if (error != null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: error,
        );
        return;
      }

      // Reload subscriptions
      await loadSubscriptions();
      if (_isDisposed) return;

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Subscription cancelled successfully',
        clearSelectedSubscription: true,
      );
    } catch (error, stackTrace) {
      if (_isDisposed) return;
      debugPrint('AdminSubscriptionViewModel.cancelSubscription error: $error');
      debugPrint(stackTrace.toString());
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to cancel subscription. Please try again.',
      );
    }
  }

  /// Set selected subscription
  void selectSubscription(AdminSubscriptionListItem? subscription) {
    state = state.copyWith(selectedSubscription: subscription);
  }

  /// Set selected plan
  void selectPlan(SubscriptionPlan? plan) {
    state = state.copyWith(selectedPlan: plan);
  }

  /// Update filters
  void updateFilters(AdminSubscriptionFilters filters) {
    state = state.copyWith(filters: filters);
    loadSubscriptions();
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Clear success message
  void clearSuccess() {
    state = state.copyWith(clearSuccess: true);
  }
}

