import 'package:savage_coworking/app/router/app_route.dart';

enum SplashDestination {
  auth(AppRoute.auth),
  home(AppRoute.home);

  const SplashDestination(this.route);

  final AppRoute route;

  String get path => route.path;
}
