import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/auth_user.dart';
import '../../../workspace/view/widgets/workspace_switcher_dialog.dart';
import '../../../workspace/providers/workspace_selection_providers.dart';

enum _UserMenuAction { admin, userDashboard, switchWorkspace, logout }

class UserMenuButton extends ConsumerWidget {
  const UserMenuButton({
    super.key,
    required this.user,
    required this.onLogout,
    this.onAdminNavigate,
    this.onUserDashboardNavigate,
  });

  final AuthUser user;
  final Future<void> Function() onLogout;
  final VoidCallback? onAdminNavigate;
  final VoidCallback? onUserDashboardNavigate;

  String get _initials {
    final displayName = user.displayName?.trim();
    if (displayName == null || displayName.isEmpty) {
      final emailInitial = user.email.trim();
      return emailInitial.isNotEmpty ? emailInitial.substring(0, 1) : 'U';
    }
    return displayName.substring(0, 1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedWorkspaceAsync = ref.watch(selectedWorkspaceProvider);
    return PopupMenuButton<_UserMenuAction>(
      tooltip: 'User menu',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: const Offset(0, 12),
      onSelected: (action) => _handleSelected(context, action),
      itemBuilder: (context) {
        final items = <PopupMenuEntry<_UserMenuAction>>[
          PopupMenuItem<_UserMenuAction>(
            enabled: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName ?? 'Signed in',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const PopupMenuDivider(),
        ];

        if (user.isAdmin && onAdminNavigate != null) {
          items.add(
            const PopupMenuItem<_UserMenuAction>(
              value: _UserMenuAction.admin,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.space_dashboard_outlined),
                title: Text('Admin dashboard'),
                dense: true,
              ),
            ),
          );
        }

        if (user.isAdmin) {
          final workspaceName = selectedWorkspaceAsync.valueOrNull?.name ?? 'No workspace';
          items.add(
            PopupMenuItem<_UserMenuAction>(
              value: _UserMenuAction.switchWorkspace,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.business),
                title: const Text('Switch Workspace'),
                subtitle: Text(
                  workspaceName,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                dense: true,
              ),
            ),
          );
        }

        if (onUserDashboardNavigate != null) {
          items.add(
            const PopupMenuItem<_UserMenuAction>(
              value: _UserMenuAction.userDashboard,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.home),
                title: Text('User dashboard'),
                dense: true,
              ),
            ),
          );
        }

        items.add(
          const PopupMenuItem<_UserMenuAction>(
            value: _UserMenuAction.logout,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.logout),
              title: Text('Sign out'),
              dense: true,
            ),
          ),
        );

        return items;
      },
      child: CircleAvatar(
        radius: 18,
        backgroundImage:
            user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
        child: user.photoUrl == null
            ? Text(
                _initials.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              )
            : null,
      ),
    );
  }

  void _handleSelected(BuildContext context, _UserMenuAction action) {
    switch (action) {
      case _UserMenuAction.admin:
        onAdminNavigate?.call();
        break;
      case _UserMenuAction.userDashboard:
        onUserDashboardNavigate?.call();
        break;
      case _UserMenuAction.switchWorkspace:
        showDialog(
          context: context,
          builder: (context) => const WorkspaceSwitcherDialog(),
        );
        break;
      case _UserMenuAction.logout:
        onLogout();
        break;
    }
  }
}
