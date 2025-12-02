import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'dashboard_view.desktop.dart';
import 'dashboard_view.mobile.dart';
import 'dashboard_view.tablet.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenTypeLayout.builder(
      mobile: (_) => DashboardViewMobile(child: child),
      tablet: (_) => DashboardViewTablet(child: child),
      desktop: (_) => DashboardViewDesktop(child: child),
    );
  }
}
