import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Define dashboard route order for directional sliding
const _dashboardRoutes = ['/home', '/desk', '/bookings'];

int? _getDashboardRouteIndex(String? path) {
  if (path == null) return null;
  final index = _dashboardRoutes.indexOf(path);
  return index >= 0 ? index : null;
}

// Simple static variable to track previous dashboard route
String? _previousDashboardRoute;

/// Check if previous route was outside ShellRoute (not a dashboard route)
bool _wasOutsideShellRoute(String? previousRoute) {
  if (previousRoute == null) return true;
  return !_dashboardRoutes.contains(previousRoute);
}

/// Platform-aware page transition builder for go_router
Page<T> buildPageWithTransition<T extends Object?>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  bool isModal = false,
}) {
  // Modal overlays use fade + scale regardless of platform
  if (isModal) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Forward: fade in + scale up (0.95 → 1.0)
        // Reverse: fade out + scale down (1.0 → 0.95)
        // No sliding in either direction
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.95,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
            ),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 200),
    );
  }

  // Check if this is a dashboard route for directional sliding
  final currentRoute = state.matchedLocation;
  final currentIndex = _getDashboardRouteIndex(currentRoute);
  final previousIndex = _getDashboardRouteIndex(_previousDashboardRoute);
  final wasOutsideShell = _wasOutsideShellRoute(_previousDashboardRoute);
  
  // Update previous route for next navigation (only for dashboard routes)
  if (currentIndex != null) {
    _previousDashboardRoute = currentRoute;
  }

  // Skip transition if entering ShellRoute from outside (first time entering dashboard)
  if (currentIndex != null && wasOutsideShell) {
    return MaterialPage<T>(
      key: state.pageKey,
      child: child,
    );
  }

  // Web: Instant or subtle fade (no directional sliding on web)
  if (kIsWeb) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 150),
    );
  }

  // Detect platform for native apps
  final platform = Theme.of(context).platform;
  final isApplePlatform = platform == TargetPlatform.iOS || 
                          platform == TargetPlatform.macOS;

  // Dashboard routes: directional sliding based on nav bar position
  if (currentIndex != null && previousIndex != null) {
    // Determine slide direction: forward (left) if index increases, backward (right) if decreases
    final isNavigatingForward = currentIndex > previousIndex;
    final slideDirection = isNavigatingForward ? 1.0 : -1.0;

    if (isApplePlatform) {
      // Cupertino: Custom slide for dashboard routes
      return CustomTransitionPage<T>(
        key: state.pageKey,
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(slideDirection, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOutCubic,
              ),
            ),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );
    } else {
      // Android: Material slide with direction
      return CustomTransitionPage<T>(
        key: state.pageKey,
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(slideDirection, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );
    }
  }

  // Non-dashboard routes: standard platform transitions
  if (isApplePlatform) {
    // Cupertino: Slide from right with iOS curve
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return CupertinoPageTransition(
          primaryRouteAnimation: animation,
          secondaryRouteAnimation: secondaryAnimation,
          child: child,
          linearTransition: false,
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  } else {
    // Android: Material slide from right
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

/// Custom page that allows transition customization
class CustomTransitionPage<T extends Object?> extends Page<T> {
  final Widget child;
  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) transitionsBuilder;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;

  const CustomTransitionPage({
    required super.key,
    required this.child,
    required this.transitionsBuilder,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: transitionsBuilder,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseTransitionDuration,
    );
  }
}

