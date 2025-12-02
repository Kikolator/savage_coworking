import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';

/// Bottom navigation bar widget that adapts to platform (Material/Cupertino).
///
/// Platform detection logic:
/// - Web: Always uses Material 3 (regardless of underlying OS)
/// - Native iOS/macOS: Uses Cupertino style
/// - Native Android/other: Uses Material 3
///
/// Follows Material 3 and Cupertino design guidelines:
/// - Fixed type navigation (M3 best practice)
/// - Proper icon sizing (24dp)
/// - Minimum touch targets (48x48dp)
/// - Proper spacing and padding
/// - Accessibility support
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    
    // Web always uses Material 3, regardless of underlying OS
    if (kIsWeb) {
      return _buildMaterialNavBar(context, currentLocation);
    }
    
    // For native apps, check platform
    final isApplePlatform =
        Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.macOS;

    if (isApplePlatform) {
      return _buildCupertinoNavBar(context, currentLocation);
    } else {
      return _buildMaterialNavBar(context, currentLocation);
    }
  }

  /// Builds Material 3 bottom navigation bar.
  ///
  /// Uses fixed type (M3 best practice) and follows theme configuration.
  Widget _buildMaterialNavBar(BuildContext context, String currentLocation) {
    final currentIndex = _getCurrentIndex(currentLocation);

    return SafeArea(
      child: BottomNavigationBar(
        // Use fixed type for M3 (not shifting)
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
        // Theme colors are applied automatically via bottomNavigationBarTheme
        // Explicitly set icon size to 24dp (M3 standard)
        iconSize: 24,
        // Ensure proper spacing between items
        selectedFontSize: 12,
        unselectedFontSize: 12,
        // Minimum touch target is handled by BottomNavigationBar (48dp height)
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
            tooltip: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.desktop_windows_outlined),
            activeIcon: Icon(Icons.desktop_windows),
            label: 'Hot Desk',
            tooltip: 'Hot Desk Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Bookings',
            tooltip: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
            tooltip: 'Settings',
          ),
        ],
      ),
    );
  }

  /// Builds Cupertino-style bottom navigation bar for iOS/macOS.
  ///
  /// Follows iOS Human Interface Guidelines with proper spacing and styling.
  Widget _buildCupertinoNavBar(BuildContext context, String currentLocation) {
    final currentIndex = _getCurrentIndex(currentLocation);

    return SafeArea(
      child: CupertinoTabBar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
        // CupertinoTabBar handles proper spacing automatically
        // Icon size defaults to appropriate size for iOS
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.desktopcomputer),
            activeIcon: Icon(CupertinoIcons.desktopcomputer),
            label: 'Hot Desk',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar),
            activeIcon: Icon(CupertinoIcons.calendar),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            activeIcon: Icon(CupertinoIcons.settings_solid),
            label: 'Settings',
          ),
        ],
      ),
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
