import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/subscription.dart';
import '../models/subscription_failure.dart';
import '../models/subscription_plan.dart';
import '../service/subscription_service.dart';

class SubscriptionState {
  final bool isLoading;
  final Subscription? subscription;
  final List<SubscriptionPlan>? plans;
  final SubscriptionFailure? failure;

  const SubscriptionState({
    this.isLoading = false,
    this.subscription,
    this.plans,
    this.failure,
  });

  SubscriptionState copyWith({
    bool? isLoading,
    Subscription? subscription,
    List<SubscriptionPlan>? plans,
    SubscriptionFailure? failure,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      subscription: subscription ?? this.subscription,
      plans: plans ?? this.plans,
      failure: failure,
    );
  }
}

class SubscriptionViewModel extends StateNotifier<SubscriptionState> {
  SubscriptionViewModel(this._service, this._userId)
      : super(const SubscriptionState()) {
    _loadData();
  }

  final SubscriptionService _service;
  final String _userId;

  Future<void> _loadData() async {
    state = state.copyWith(isLoading: true, failure: null);
    final (subscription, failure) = await _service.getActiveSubscription(_userId);
    if (failure != null) {
      state = state.copyWith(isLoading: false, failure: failure);
      return;
    }
    state = state.copyWith(isLoading: false, subscription: subscription);
  }

  Future<void> loadPlans() async {
    state = state.copyWith(isLoading: true, failure: null);
    final (plans, failure) = await _service.getActivePlans();
    if (failure != null) {
      state = state.copyWith(isLoading: false, failure: failure);
      return;
    }
    state = state.copyWith(isLoading: false, plans: plans);
  }

  Future<void> cancelSubscription({
    bool cancelAtPeriodEnd = false,
  }) async {
    if (state.subscription == null) return;

    state = state.copyWith(isLoading: true, failure: null);
    final failure = await _service.cancelSubscription(
      state.subscription!.id,
      cancelAtPeriodEnd: cancelAtPeriodEnd,
    );
    if (failure != null) {
      state = state.copyWith(isLoading: false, failure: failure);
      return;
    }

    // Reload subscription after cancellation
    await _loadData();
  }

  void clearFailure() {
    state = state.copyWith(failure: null);
  }

  void refresh() {
    _loadData();
  }

  Future<void> selectPlan(SubscriptionPlan plan) async {
    if (kDebugMode) {
      debugPrint(
        'SubscriptionViewModel: selectPlan called for plan '
        '${plan.name} (${plan.id})',
      );
    }

    state = state.copyWith(isLoading: true, failure: null);

    final (subscription, failure) = await _service.createSubscription(
      userId: _userId,
      plan: plan,
    );

    if (failure != null) {
      if (kDebugMode) {
        debugPrint(
          'SubscriptionViewModel: selectPlan failed - '
          '${failure.toString()}',
        );
      }
      state = state.copyWith(isLoading: false, failure: failure);
      return;
    }

    if (kDebugMode) {
      debugPrint(
        'SubscriptionViewModel: selectPlan succeeded, '
        'subscription created: ${subscription?.id}',
      );
    }

    // Reload subscription data after creation
    await _loadData();
  }
}


