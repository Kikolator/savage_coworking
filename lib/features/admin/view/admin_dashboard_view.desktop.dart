import 'package:flutter/material.dart';

import 'widgets/admin_dashboard_screen.dart';
import 'admin_dashboard_view.dart';

class AdminDashboardViewDesktop extends StatelessWidget {
  const AdminDashboardViewDesktop({super.key, required this.props});

  final AdminDashboardViewProps props;

  @override
  Widget build(BuildContext context) {
    return AdminDashboardScreen(
      props: props,
      contentPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 28),
      maxContentWidth: 1200,
      useNavigationRail: true,
      showBottomNav: false,
    );
  }
}
