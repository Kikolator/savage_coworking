import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../auth/providers/auth_providers.dart';
import '../../auth/view/auth_view.dart';
import '../../auth/view/widgets/user_menu_button.dart';
import '../models/admin_dashboard_section.dart';
import '../providers/admin_dashboard_providers.dart';
import '../viewmodel/admin_dashboard_view_model.dart';
import 'admin_dashboard_view.desktop.dart';
import 'admin_dashboard_view.monitor.dart';
import 'admin_dashboard_view.phone.dart';
import 'admin_dashboard_view.tablet.dart';

class AdminDashboardView extends ConsumerWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;
    if (user == null) {
      return const AuthView();
    }
    if (!user.isAdmin) {
      return const _AdminAccessDeniedView();
    }

    final state = ref.watch(adminDashboardViewModelProvider);
    final viewModel = ref.read(adminDashboardViewModelProvider.notifier);
    final authViewModel = ref.read(authViewModelProvider.notifier);

    final props = AdminDashboardViewProps(
      state: state,
      userMenuBuilder: (context) => UserMenuButton(
        user: user,
        onLogout: authViewModel.logout,
        onUserDashboardNavigate: () => context.go(AppRoute.home.path),
      ),
      onSectionSelected: viewModel.selectSection,
      onRefresh: viewModel.loadDashboard,
    );

    final width = MediaQuery.of(context).size.width;
    if (width >= 1280) {
      return AdminDashboardViewMonitor(props: props);
    } else if (width >= 769) {
      return AdminDashboardViewDesktop(props: props);
    } else if (width >= 481) {
      return AdminDashboardViewTablet(props: props);
    } else {
      return AdminDashboardViewPhone(props: props);
    }
  }
}

typedef AdminDashboardBuilder = Widget Function(AdminDashboardViewProps props);

class AdminDashboardViewProps {
  const AdminDashboardViewProps({
    required this.state,
    required this.userMenuBuilder,
    required this.onSectionSelected,
    required this.onRefresh,
  });

  final AdminDashboardState state;
  final WidgetBuilder userMenuBuilder;
  final void Function(AdminDashboardSection section) onSectionSelected;
  final Future<void> Function() onRefresh;
}

class _AdminAccessDeniedView extends StatelessWidget {
  const _AdminAccessDeniedView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Admin access required',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Your account does not have permission to view the admin console.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go(AppRoute.hotDesk.path),
              child: const Text('Back to desks'),
            ),
          ],
        ),
      ),
    );
  }
}
