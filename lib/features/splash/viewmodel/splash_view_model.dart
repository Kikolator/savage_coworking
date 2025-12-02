import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router/app_route.dart';
import '../service/splash_service.dart';

class SplashState {
  const SplashState({
    this.isLoading = false,
    this.destination,
    this.errorMessage,
  });

  final bool isLoading;
  final AppRoute? destination;
  final String? errorMessage;

  SplashState copyWith({
    bool? isLoading,
    AppRoute? destination,
    bool clearDestination = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      destination: clearDestination ? null : destination ?? this.destination,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class SplashViewModel extends StateNotifier<SplashState> {
  SplashViewModel(this._service) : super(const SplashState());

  final SplashService _service;

  Future<void> loadApp() async {
    if (state.isLoading) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
      clearDestination: true,
      clearError: true,
    );

    try {
      final destination = await _service.resolveDestination();
      state = state.copyWith(isLoading: false, destination: destination);
    } catch (error, stackTrace) {
      debugPrint('SplashViewModel.loadApp failure: $error\n$stackTrace');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to prepare the app. Please try again.',
      );
    }
  }
}
