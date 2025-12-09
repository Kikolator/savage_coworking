import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../../app/router/app_route.dart';
import '../../../core/services/firebase_functions_service.dart';
import '../../auth/providers/auth_providers.dart';
import '../../auth/viewmodel/auth_view_model.dart';
import '../../subscription/providers/subscription_providers.dart';

class ProfileMenuDrawer extends ConsumerWidget {
  const ProfileMenuDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;

    // Web always uses Material 3, regardless of underlying OS
    if (kIsWeb) {
      return _buildMaterialDrawer(context, ref, user);
    }

    // For native apps, check platform
    final isApplePlatform =
        Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.macOS;

    if (isApplePlatform) {
      return _buildCupertinoDrawer(context, ref, user);
    } else {
      return _buildMaterialDrawer(context, ref, user);
    }
  }

  Widget _buildMaterialDrawer(BuildContext context, WidgetRef ref, user) {
    return Drawer(
      width: 304, // Explicit width to prevent expansion on wide screens
      child: SafeArea(
        child: Column(
          children: [
            // Close button in upper left corner
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                tooltip: 'Close',
                padding: const EdgeInsets.all(16.0),
              ),
            ),
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
                context.go(AppRoute.settings.path);
              },
            ),
            if (user?.isAdmin == true) ...[
              const Divider(),
              _buildMenuItem(
                context,
                icon: Icons.space_dashboard_outlined,
                title: 'Admin Dashboard',
                onTap: () {
                  Navigator.pop(context);
                  context.go(AppRoute.admin.path);
                },
              ),
            ],
            const Divider(),
            _buildMenuItem(
              context,
              icon: Icons.subscriptions,
              title: 'Subscriptions',
              onTap: () {
                Navigator.pop(context);
                context.go(AppRoute.subscriptions.path);
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.receipt_long,
              title: 'Billing & Invoices',
              onTap: () {
                Navigator.pop(context);
                context.go(AppRoute.billing.path);
              },
            ),
            const Spacer(),
            // Debug Tools section (only in debug mode and if not admin)
            if (kDebugMode && user != null && !user.isAdmin) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  'Debug Tools',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
              _buildMenuItem(
                context,
                icon: Icons.admin_panel_settings,
                title: 'Set Admin (DEBUG)',
                onTap: () async {
                  // Get root navigator context before closing drawer
                  final rootContext = Navigator.of(
                    context,
                    rootNavigator: true,
                  ).context;
                  // Read providers BEFORE closing drawer (while ref is still valid)
                  final functionsService = ref.read(
                    firebaseFunctionsServiceProvider,
                  );
                  final authViewModel = ref.read(
                    authViewModelProvider.notifier,
                  );
                  // Close drawer first
                  Navigator.pop(context);
                  // Then show dialog with root context
                  await _setCurrentUserAsAdmin(
                    rootContext,
                    user,
                    functionsService,
                    authViewModel,
                  );
                },
              ),
            ],
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

  Widget _buildCupertinoDrawer(BuildContext context, WidgetRef ref, user) {
    // Use Container with width constraint instead of CupertinoPageScaffold
    // to prevent full-screen expansion
    return Container(
      width: 304, // Explicit width constraint
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border(
          left: BorderSide(color: CupertinoColors.separator, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Close button in upper left corner
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  child: const Icon(CupertinoIcons.xmark),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
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
                context.go(AppRoute.settings.path);
              },
            ),
            if (user?.isAdmin == true) ...[
              const Divider(),
              _buildCupertinoMenuItem(
                context,
                icon: CupertinoIcons.square_grid_2x2,
                title: 'Admin Dashboard',
                onTap: () {
                  Navigator.pop(context);
                  context.go(AppRoute.admin.path);
                },
              ),
            ],
            const Divider(),
            _buildCupertinoMenuItem(
              context,
              icon: CupertinoIcons.creditcard,
              title: 'Subscriptions',
              onTap: () {
                Navigator.pop(context);
                context.go(AppRoute.subscriptions.path);
              },
            ),
            _buildCupertinoMenuItem(
              context,
              icon: CupertinoIcons.doc_text,
              title: 'Billing & Invoices',
              onTap: () {
                Navigator.pop(context);
                context.go(AppRoute.billing.path);
              },
            ),
            const Spacer(),
            // Debug Tools section (only in debug mode and if not admin)
            if (kDebugMode && user != null && !user.isAdmin) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  'Debug Tools',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
              _buildCupertinoMenuItem(
                context,
                icon: CupertinoIcons.person_badge_plus,
                title: 'Set Admin (DEBUG)',
                onTap: () async {
                  // Get root navigator context before closing drawer
                  final rootContext = Navigator.of(
                    context,
                    rootNavigator: true,
                  ).context;
                  // Read providers BEFORE closing drawer (while ref is still valid)
                  final functionsService = ref.read(
                    firebaseFunctionsServiceProvider,
                  );
                  final authViewModel = ref.read(
                    authViewModelProvider.notifier,
                  );
                  // Close drawer first
                  Navigator.pop(context);
                  // Then show dialog with root context
                  await _setCurrentUserAsAdmin(
                    rootContext,
                    user,
                    functionsService,
                    authViewModel,
                  );
                },
              ),
            ],
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
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
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

  Future<void> _setCurrentUserAsAdmin(
    BuildContext context,
    user,
    FirebaseFunctionsService functionsService,
    AuthViewModel authViewModel,
  ) async {
    // Ensure we're using root navigator context that won't be unmounted
    final rootContext = Navigator.of(context, rootNavigator: true).context;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: rootContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Set Admin Claim (DEBUG)'),
        content: Text(
          'This will set admin custom claim for:\n\n'
          'Email: ${user.email}\n'
          'UID: ${user.id}\n\n'
          '⚠️ This is a debug-only feature.\n'
          'After setting, you must log out and back in for the change to take effect.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            child: const Text('Set Admin'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Show loading indicator using root context
    if (rootContext.mounted) {
      ScaffoldMessenger.of(rootContext).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 16),
              Text('Setting admin claim...'),
            ],
          ),
          duration: Duration(seconds: 30),
        ),
      );
    }

    try {
      final result = await functionsService.callFunction<Map<String, dynamic>>(
        functionName: 'setAdminClaim',
        data: {'uid': user.id, 'isAdmin': true},
      );

      if (rootContext.mounted) {
        ScaffoldMessenger.of(rootContext).hideCurrentSnackBar();

        if (result['success'] == true) {
          ScaffoldMessenger.of(rootContext).showSnackBar(
            SnackBar(
              content: const Text(
                'Admin claim set successfully! Please log out and back in for it to take effect.',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Logout',
                textColor: Colors.white,
                onPressed: () async {
                  await authViewModel.logout();
                  if (rootContext.mounted) {
                    GoRouter.of(rootContext).go('/auth');
                  }
                },
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(rootContext).showSnackBar(
            const SnackBar(
              content: Text('Failed to set admin claim'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        }
      }
    } on FirebaseFunctionsException catch (e) {
      if (rootContext.mounted) {
        ScaffoldMessenger.of(rootContext).hideCurrentSnackBar();
        ScaffoldMessenger.of(rootContext).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.message ?? e.code}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (rootContext.mounted) {
        ScaffoldMessenger.of(rootContext).hideCurrentSnackBar();
        ScaffoldMessenger.of(rootContext).showSnackBar(
          SnackBar(
            content: Text('Unexpected error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }
}
