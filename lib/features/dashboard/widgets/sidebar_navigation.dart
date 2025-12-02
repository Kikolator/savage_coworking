import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../providers/dashboard_providers.dart';

class SidebarNavigation extends ConsumerWidget {
  const SidebarNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardViewModelProvider);
    final isExpanded = state.isSidebarExpanded;
    final isApplePlatform = Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.macOS;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: isExpanded ? 256 : 72,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildToggleButton(context, ref, isExpanded),
          const Divider(height: 1),
          Expanded(
            child: _buildNavigationItems(context, isExpanded, isApplePlatform),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    BuildContext context,
    WidgetRef ref,
    bool isExpanded,
  ) {
    return IconButton(
      icon: Icon(isExpanded ? Icons.chevron_left : Icons.chevron_right),
      onPressed: () {
        ref.read(dashboardViewModelProvider.notifier).toggleSidebar();
      },
      tooltip: isExpanded ? 'Collapse sidebar' : 'Expand sidebar',
    );
  }

  Widget _buildNavigationItems(
    BuildContext context,
    bool isExpanded,
    bool isApplePlatform,
  ) {
    final currentLocation = GoRouterState.of(context).matchedLocation;

    final navItems = [
      _NavItem(
        route: AppRoute.home,
        icon: isApplePlatform ? CupertinoIcons.house : Icons.home,
        title: 'Home',
      ),
      _NavItem(
        route: AppRoute.hotDesk,
        icon: isApplePlatform ? CupertinoIcons.desktopcomputer : Icons.desktop_windows,
        title: 'Hot Desk',
      ),
      _NavItem(
        route: AppRoute.bookings,
        icon: isApplePlatform ? CupertinoIcons.calendar : Icons.calendar_today,
        title: 'Bookings',
      ),
      _NavItem(
        route: AppRoute.settings,
        icon: isApplePlatform ? CupertinoIcons.settings : Icons.settings,
        title: 'Settings',
      ),
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: navItems.map((item) {
        final isActive = currentLocation == item.route.path;
        return _buildNavItem(context, item, isActive, isExpanded, isApplePlatform);
      }).toList(),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    _NavItem item,
    bool isActive,
    bool isExpanded,
    bool isApplePlatform,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = isActive
        ? colorScheme.primaryContainer
        : Colors.transparent;
    final foregroundColor = isActive
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurface;

    if (isApplePlatform) {
      return _buildCupertinoNavItem(
        context,
        item,
        isActive,
        isExpanded,
        backgroundColor,
        foregroundColor,
      );
    } else {
      return _buildMaterialNavItem(
        context,
        item,
        isActive,
        isExpanded,
        backgroundColor,
        foregroundColor,
      );
    }
  }

  Widget _buildMaterialNavItem(
    BuildContext context,
    _NavItem item,
    bool isActive,
    bool isExpanded,
    Color backgroundColor,
    Color foregroundColor,
  ) {
    return InkWell(
      onTap: () => context.go(item.route.path),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: EdgeInsets.symmetric(
          horizontal: isExpanded ? 16 : 0,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: isExpanded
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Icon(
              item.icon as IconData,
              color: foregroundColor,
              size: 24,
            ),
            if (isExpanded) ...[
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: foregroundColor,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCupertinoNavItem(
    BuildContext context,
    _NavItem item,
    bool isActive,
    bool isExpanded,
    Color backgroundColor,
    Color foregroundColor,
  ) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(
        horizontal: isExpanded ? 16 : 0,
        vertical: 12,
      ),
      onPressed: () => context.go(item.route.path),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: EdgeInsets.symmetric(
          horizontal: isExpanded ? 16 : 0,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: isExpanded
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Icon(
              item.icon as IconData,
              color: foregroundColor,
              size: 24,
            ),
            if (isExpanded) ...[
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: foregroundColor,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final AppRoute route;
  final dynamic icon;
  final String title;

  _NavItem({
    required this.route,
    required this.icon,
    required this.title,
  });
}

