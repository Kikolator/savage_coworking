import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savage_coworking/features/auth/providers/auth_providers.dart';

import '../service/splash_service.dart';
import '../viewmodel/splash_view_model.dart';

final splashServiceProvider = Provider<SplashService>((ref) {
  final authService = ref.watch(authServiceProvider);
  return SplashService(authService);
});

final splashViewModelProvider =
    StateNotifierProvider<SplashViewModel, SplashState>((ref) {
  final service = ref.watch(splashServiceProvider);
  return SplashViewModel(service);
});
