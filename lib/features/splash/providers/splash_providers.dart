import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savage_coworking/app/navigation/navigation_providers.dart';

import '../service/splash_service.dart';
import '../viewmodel/splash_view_model.dart';

final splashServiceProvider = Provider<SplashService>((ref) {
  final navigationService = ref.watch(navigationServiceProvider);
  return SplashService(navigationService);
});

final splashViewModelProvider =
    StateNotifierProvider<SplashViewModel, SplashState>((ref) {
  final service = ref.watch(splashServiceProvider);
  return SplashViewModel(service);
});
