import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savage_coworking/features/auth/providers/auth_providers.dart';

import 'navigation_service.dart';

final navigationServiceProvider = Provider<NavigationService>((ref) {
  final authService = ref.watch(authServiceProvider);
  return NavigationService(authService);
});

