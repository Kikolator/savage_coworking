import 'package:savage_coworking/app/router/app_route.dart';
import 'package:savage_coworking/features/auth/models/auth_user.dart';
import 'package:savage_coworking/features/auth/service/auth_service.dart';

class NavigationService {
  NavigationService(this._authService);

  final AuthService _authService;

  Future<AppRoute> getInitialRoute() async {
    try {
      final user = await _authService.getCurrentUser();
      if (user == null) {
        return AppRoute.auth;
      }
      if (user.isAdmin) {
        return AppRoute.admin;
      }
      return AppRoute.home;
    } catch (_) {
      return AppRoute.auth;
    }
  }
}

