import 'package:savage_coworking/features/auth/service/auth_service.dart';

import '../models/splash_destination.dart';

class SplashService {
  SplashService(this._authService);

  final AuthService _authService;

  Future<SplashDestination> resolveDestination() async {
    try {
      final user = await _authService.getCurrentUser();
      return user == null ? SplashDestination.auth : SplashDestination.home;
    } catch (_) {
      return SplashDestination.auth;
    }
  }
}
