import 'package:flutter/material.dart';

import 'widgets/admin_dashboard_screen.dart';
import 'admin_dashboard_view.dart';

class AdminDashboardViewTablet extends StatelessWidget {
  const AdminDashboardViewTablet({super.key, required this.props});

  final AdminDashboardViewProps props;

  @override
  Widget build(BuildContext context) {
    return AdminDashboardScreen(
      props: props,
      contentPadding: const EdgeInsets.all(24),
      maxContentWidth: 900,
      useNavigationRail: false,
      showBottomNav: true,
    );
  }
}
