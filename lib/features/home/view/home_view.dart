import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../../hot_desk_booking/providers/workspace_providers.dart';
import '../../workspace/providers/workspace_selection_providers.dart';
import '../../subscription/providers/subscription_providers.dart';
import 'home_view.mobile.dart';
import 'home_view.tablet.dart';
import 'home_view.desktop.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;
    final width = MediaQuery.of(context).size.width;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final userId = user.id;
    final selectedWorkspaceAsync = ref.watch(selectedWorkspaceProvider);
    final subscriptionService = ref.watch(subscriptionServiceProvider);

    // Check workspace selection state
    final hasSelectedWorkspace = selectedWorkspaceAsync.when(
      data: (workspace) => workspace != null,
      loading: () => false,
      error: (_, __) => false,
    );

    // Check subscription state (async, will be handled in widgets)
    final workspacesAsync = ref.watch(activeWorkspacesFutureProvider);
    final hasNoWorkspace = workspacesAsync.when(
      data: (workspaces) => workspaces.isEmpty,
      loading: () => false,
      error: (_, __) => false,
    );

    // Determine which view to show based on screen width
    if (width >= 769) {
      return HomeViewDesktop(
        userId: userId,
        hasSelectedWorkspace: hasSelectedWorkspace,
        hasNoWorkspace: hasNoWorkspace,
        user: user,
        subscriptionService: subscriptionService,
      );
    } else if (width >= 481) {
      return HomeViewTablet(
        userId: userId,
        hasSelectedWorkspace: hasSelectedWorkspace,
        hasNoWorkspace: hasNoWorkspace,
        user: user,
        subscriptionService: subscriptionService,
      );
    } else {
      return HomeViewMobile(
        userId: userId,
        hasSelectedWorkspace: hasSelectedWorkspace,
        hasNoWorkspace: hasNoWorkspace,
        user: user,
        subscriptionService: subscriptionService,
      );
    }
  }
}
