import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../../workspace/view/widgets/create_workspace_dialog.dart';
import '../../hot_desk_booking/providers/workspace_providers.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;
    final workspacesAsync = ref.watch(activeWorkspacesFutureProvider);

    final hasNoWorkspace = workspacesAsync.when(
      data: (workspaces) => workspaces.isEmpty,
      loading: () => false,
      error: (_, __) => false,
    );

    return Scaffold(
      body: Column(
        children: [
          if (user?.isAdmin == true && hasNoWorkspace)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.errorContainer,
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No workspace found. Create a workspace to continue.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => CreateWorkspaceDialog(
                          onWorkspaceCreated: () {
                            // Workspace created, banner will disappear
                          },
                        ),
                      );
                    },
                    child: const Text('Create Workspace'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Home',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome to Savage Coworking',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

