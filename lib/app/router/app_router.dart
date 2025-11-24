import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:savage_coworking/features/auth/providers/auth_providers.dart';
import 'package:savage_coworking/features/auth/view/auth_view.dart';
import 'package:savage_coworking/features/hot_desk_booking/view/hot_desk_booking_view.dart';
import 'package:savage_coworking/features/splash/view/splash_view.dart';

import 'app_route.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authStateChanges = ref.watch(authStateChangesProvider.stream);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoute.splash.path,
    refreshListenable: GoRouterRefreshStream(authStateChanges),
    routes: [
      GoRoute(
        path: AppRoute.splash.path,
        name: AppRoute.splash.name,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoute.auth.path,
        name: AppRoute.auth.name,
        builder: (context, state) => const AuthView(),
      ),
      GoRoute(
        path: AppRoute.hotDesk.path,
        name: AppRoute.hotDesk.name,
        builder: (context, state) => const HotDeskBookingView(),
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authStateChangesProvider);
      if (authState.isLoading) {
        return null;
      }

      final user = authState.valueOrNull;
      final isNavigatingToAuth = state.matchedLocation == AppRoute.auth.path;
      final isNavigatingToHotDesk =
          state.matchedLocation == AppRoute.hotDesk.path;

      if (user == null && isNavigatingToHotDesk) {
        return AppRoute.auth.path;
      }

      if (user != null && isNavigatingToAuth) {
        return AppRoute.hotDesk.path;
      }

      return null;
    },
  );
});
