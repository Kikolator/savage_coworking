import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/splash_providers.dart';
import '../viewmodel/splash_view_model.dart';
import 'splash_view.desktop.dart';
import 'splash_view.monitor.dart';
import 'splash_view.phone.dart';
import 'splash_view.tablet.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  void _handleRetry() {
    ref.read(splashViewModelProvider.notifier).loadApp();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(splashViewModelProvider);

    // Initialize app loading on first build
    if (!_hasInitialized) {
      _hasInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(splashViewModelProvider.notifier).loadApp();
      });
    }

    // Listen to state changes and navigate when destination is set
    ref.listen<SplashState>(splashViewModelProvider, (previous, next) {
      final destination = next.destination;
      if (destination == null || !mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go(destination.path);
        }
      });
    });

    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1280) {
      return SplashViewMonitor(
        state: state,
        onRetry: _handleRetry,
      );
    } else if (screenWidth >= 769) {
      return SplashViewDesktop(
        state: state,
        onRetry: _handleRetry,
      );
    } else if (screenWidth >= 481) {
      return SplashViewTablet(
        state: state,
        onRetry: _handleRetry,
      );
    } else {
      return SplashViewPhone(
        state: state,
        onRetry: _handleRetry,
      );
    }
  }
}
