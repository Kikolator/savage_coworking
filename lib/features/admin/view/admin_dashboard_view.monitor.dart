import 'package:flutter/material.dart';

import 'widgets/admin_dashboard_screen.dart';
import 'admin_dashboard_view.dart';

class AdminDashboardViewMonitor extends StatelessWidget {
  const AdminDashboardViewMonitor({super.key, required this.props});

  final AdminDashboardViewProps props;

  @override
  Widget build(BuildContext context) {
    return AdminDashboardScreen(
      props: props,
      contentPadding: const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
      maxContentWidth: 1440,
      useNavigationRail: true,
      showBottomNav: false,
    );
  }
}
