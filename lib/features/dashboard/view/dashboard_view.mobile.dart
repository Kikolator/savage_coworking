import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/profile_menu_drawer.dart';

class DashboardViewMobile extends ConsumerStatefulWidget {
  const DashboardViewMobile({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<DashboardViewMobile> createState() =>
      _DashboardViewMobileState();
}

class _DashboardViewMobileState extends ConsumerState<DashboardViewMobile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Savage Coworking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
            tooltip: 'Profile',
          ),
        ],
      ),
      body: widget.child,
      endDrawer: const ProfileMenuDrawer(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
