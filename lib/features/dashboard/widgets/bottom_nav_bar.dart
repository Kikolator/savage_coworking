import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final isApplePlatform = Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.macOS;

    if (isApplePlatform) {
      return _buildCupertinoNavBar(context, currentLocation);
    } else {
      return _buildMaterialNavBar(context, currentLocation);
    }
  }

  Widget _buildMaterialNavBar(BuildContext context, String currentLocation) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _getCurrentIndex(currentLocation),
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.desktop_windows),
          label: 'Hot Desk',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }

  Widget _buildCupertinoNavBar(BuildContext context, String currentLocation) {
    return CupertinoTabBar(
      currentIndex: _getCurrentIndex(currentLocation),
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.house),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.desktopcomputer),
          label: 'Hot Desk',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.calendar),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.settings),
          label: 'Settings',
        ),
      ],
    );
  }

  int _getCurrentIndex(String currentLocation) {
    if (currentLocation == AppRoute.home.path) return 0;
    if (currentLocation == AppRoute.hotDesk.path) return 1;
    if (currentLocation == AppRoute.bookings.path) return 2;
    if (currentLocation == AppRoute.settings.path) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoute.home.path);
        break;
      case 1:
        context.go(AppRoute.hotDesk.path);
        break;
      case 2:
        context.go(AppRoute.bookings.path);
        break;
      case 3:
        context.go(AppRoute.settings.path);
        break;
    }
  }
}

