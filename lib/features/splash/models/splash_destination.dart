import 'package:savage_coworking/app/router/app_route.dart';

enum SplashDestination {
  auth(AppRoute.auth),
  hotDesk(AppRoute.hotDesk);

  const SplashDestination(this.route);

  final AppRoute route;

  String get path => route.path;
}
