import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:savage_coworking/features/admin/view/admin_dashboard_view.dart';
import 'package:savage_coworking/features/auth/providers/auth_providers.dart';
import 'package:savage_coworking/features/auth/view/auth_view.dart';
import 'package:savage_coworking/features/bookings/view/bookings_view.dart';
import 'package:savage_coworking/features/dashboard/view/dashboard_view.dart';
import 'package:savage_coworking/features/home/view/home_view.dart';
import 'package:savage_coworking/features/hot_desk_booking/view/hot_desk_booking_view.dart';
import 'package:savage_coworking/features/settings/view/settings_view.dart';
import 'package:savage_coworking/features/splash/view/splash_view.dart';
import 'package:savage_coworking/features/subscription/view/subscription_view.dart';
import 'package:savage_coworking/features/billing/view/billing_view.dart';

import 'app_route.dart';
import 'go_router_refresh_stream.dart';

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
      ShellRoute(
        builder: (context, state, child) => DashboardView(child: child),
        routes: [
          GoRoute(
            path: AppRoute.home.path,
            name: AppRoute.home.name,
            builder: (context, state) => const HomeView(),
          ),
          GoRoute(
            path: AppRoute.hotDesk.path,
            name: AppRoute.hotDesk.name,
            builder: (context, state) => const HotDeskBookingView(),
          ),
          GoRoute(
            path: AppRoute.bookings.path,
            name: AppRoute.bookings.name,
            builder: (context, state) => const BookingsView(),
          ),
          GoRoute(
            path: AppRoute.settings.path,
            name: AppRoute.settings.name,
            builder: (context, state) => const SettingsView(),
          ),
          GoRoute(
            path: AppRoute.subscriptions.path,
            name: AppRoute.subscriptions.name,
            builder: (context, state) => const SubscriptionView(),
          ),
          GoRoute(
            path: AppRoute.billing.path,
            name: AppRoute.billing.name,
            builder: (context, state) => const BillingView(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.admin.path,
        name: AppRoute.admin.name,
        builder: (context, state) => const AdminDashboardView(),
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authStateChangesProvider);
      if (authState.isLoading) {
        return null;
      }

      final user = authState.valueOrNull;
      final location = state.matchedLocation;
      final isNavigatingToSplash = location == AppRoute.splash.path;
      final isNavigatingToAuth = location == AppRoute.auth.path;
      final isNavigatingToAdmin = location == AppRoute.admin.path;
      final isNavigatingToDashboard = location == AppRoute.home.path ||
          location == AppRoute.hotDesk.path ||
          location == AppRoute.bookings.path ||
          location == AppRoute.settings.path ||
          location == AppRoute.subscriptions.path ||
          location == AppRoute.billing.path;

      // If on splash, let it handle navigation
      if (isNavigatingToSplash) {
        return null;
      }

      if (user == null && (isNavigatingToDashboard || isNavigatingToAdmin)) {
        return AppRoute.auth.path;
      }

      // Redirect authenticated users from auth page to home
      if (user != null && isNavigatingToAuth) {
        return AppRoute.home.path;
      }

      if (user != null && isNavigatingToAdmin && !user.isAdmin) {
        return AppRoute.hotDesk.path;
      }

      return null;
    },
  );
});
