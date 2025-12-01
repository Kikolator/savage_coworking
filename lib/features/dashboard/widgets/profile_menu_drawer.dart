import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/providers/auth_providers.dart';

class ProfileMenuDrawer extends ConsumerWidget {
  const ProfileMenuDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;
    final isApplePlatform = Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.macOS;

    if (isApplePlatform) {
      return _buildCupertinoDrawer(context, ref, user);
    } else {
      return _buildMaterialDrawer(context, ref, user);
    }
  }

  Widget _buildMaterialDrawer(
    BuildContext context,
    WidgetRef ref,
    user,
  ) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _buildUserHeader(context, user),
            const Divider(),
            _buildMenuItem(
              context,
              icon: Icons.person,
              title: 'Profile Settings',
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to profile settings
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.account_circle,
              title: 'Account Settings',
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to account settings
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.settings,
              title: 'Preferences',
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to preferences
              },
            ),
            const Spacer(),
            const Divider(),
            _buildMenuItem(
              context,
              icon: Icons.logout,
              title: 'Logout',
              onTap: () async {
                Navigator.pop(context);
                await ref.read(authViewModelProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/auth');
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCupertinoDrawer(
    BuildContext context,
    WidgetRef ref,
    user,
  ) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            _buildUserHeader(context, user),
            const Divider(),
            _buildCupertinoMenuItem(
              context,
              icon: CupertinoIcons.person,
              title: 'Profile Settings',
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to profile settings
              },
            ),
            _buildCupertinoMenuItem(
              context,
              icon: CupertinoIcons.person_circle,
              title: 'Account Settings',
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to account settings
              },
            ),
            _buildCupertinoMenuItem(
              context,
              icon: CupertinoIcons.settings,
              title: 'Preferences',
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to preferences
              },
            ),
            const Spacer(),
            const Divider(),
            _buildCupertinoMenuItem(
              context,
              icon: CupertinoIcons.arrow_right_square,
              title: 'Logout',
              onTap: () async {
                Navigator.pop(context);
                await ref.read(authViewModelProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/auth');
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, user) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            backgroundImage: user?.photoUrl != null
                ? NetworkImage(user!.photoUrl!)
                : null,
            child: user?.photoUrl == null
                ? Text(
                    user?.displayName?.substring(0, 1).toUpperCase() ??
                        user?.email.substring(0, 1).toUpperCase() ??
                        'U',
                    style: TextStyle(
                      fontSize: 32,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            user?.displayName ?? user?.email ?? 'User',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          if (user?.displayName != null && user?.email != null) ...[
            const SizedBox(height: 4),
            Text(
              user!.email,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildCupertinoMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return CupertinoListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}

