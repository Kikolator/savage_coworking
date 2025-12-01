import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/profile_menu_drawer.dart';
import '../widgets/sidebar_navigation.dart';

class DashboardViewTablet extends ConsumerStatefulWidget {
  const DashboardViewTablet({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<DashboardViewTablet> createState() => _DashboardViewTabletState();
}

class _DashboardViewTabletState extends ConsumerState<DashboardViewTablet> {
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
      body: Row(
        children: [
          const SidebarNavigation(),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
      endDrawer: const ProfileMenuDrawer(),
    );
  }
}


