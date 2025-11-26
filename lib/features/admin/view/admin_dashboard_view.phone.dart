import 'package:flutter/material.dart';

import 'widgets/admin_dashboard_screen.dart';
import 'admin_dashboard_view.dart';

class AdminDashboardViewPhone extends StatelessWidget {
  const AdminDashboardViewPhone({super.key, required this.props});

  final AdminDashboardViewProps props;

  @override
  Widget build(BuildContext context) {
    return AdminDashboardScreen(
      props: props,
      contentPadding: const EdgeInsets.all(16),
      maxContentWidth: 700,
      useNavigationRail: false,
      showBottomNav: true,
    );
  }
}
