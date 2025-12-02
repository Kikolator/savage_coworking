import 'package:savage_coworking/app/navigation/navigation_service.dart';
import 'package:savage_coworking/app/router/app_route.dart';

class SplashService {
  SplashService(this._navigationService);

  final NavigationService _navigationService;

  Future<AppRoute> resolveDestination() async {
    return _navigationService.getInitialRoute();
  }
}
