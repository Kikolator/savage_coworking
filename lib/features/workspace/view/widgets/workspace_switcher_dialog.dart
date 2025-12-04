import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/providers/auth_providers.dart';
import '../../../hot_desk_booking/providers/workspace_providers.dart';
import '../../providers/workspace_selection_providers.dart';
import 'create_workspace_dialog.dart';
import 'edit_workspace_dialog.dart';

class WorkspaceSwitcherDialog extends ConsumerWidget {
  const WorkspaceSwitcherDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;
    final workspacesAsync = ref.watch(activeWorkspacesFutureProvider);
    final selectedWorkspaceIdAsync = ref.watch(selectedWorkspaceIdProvider);

    if (user == null) {
      return const AlertDialog(
        title: Text('Error'),
        content: Text('You must be logged in to switch workspaces.'),
      );
    }

    return AlertDialog(
      title: const Text('Switch Workspace'),
      content: workspacesAsync.when(
        data: (workspaces) {
          final selectedId = selectedWorkspaceIdAsync;

          if (workspaces.isEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('No workspaces available.'),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Create New Workspace'),
                  subtitle: const Text('Add a new workspace'),
                  leading: Icon(
                    Icons.add_circle_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () async {
                    // Show create workspace dialog
                    final created = await showDialog<bool>(
                      context: context,
                      builder: (context) => CreateWorkspaceDialog(
                        onWorkspaceCreated: () {
                          // Workspace created, refresh the list
                          ref.invalidate(activeWorkspacesFutureProvider);
                        },
                      ),
                    );

                    // If workspace was created, close this dialog too
                    if (created == true && context.mounted) {
                      // Refresh workspace list
                      ref.invalidate(activeWorkspacesFutureProvider);
                      // Close the switch workspace dialog so snackbars are visible
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          }

          return SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: workspaces.length + 1, // +1 for "Create New" option
              itemBuilder: (context, index) {
                // Show "Create New Workspace" option at the end
                if (index == workspaces.length) {
                  return ListTile(
                    title: const Text('Create New Workspace'),
                    subtitle: const Text('Add a new workspace'),
                    leading: Icon(
                      Icons.add_circle_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onTap: () async {
                      // Show create workspace dialog
                      final created = await showDialog<bool>(
                        context: context,
                        builder: (context) => CreateWorkspaceDialog(
                          onWorkspaceCreated: () {
                            // Workspace created, refresh the list
                            ref.invalidate(activeWorkspacesFutureProvider);
                          },
                        ),
                      );

                      // If workspace was created, close this dialog too
                      if (created == true && context.mounted) {
                        // Refresh workspace list
                        ref.invalidate(activeWorkspacesFutureProvider);
                        // Close the switch workspace dialog so snackbars are visible
                        Navigator.of(context).pop();
                      }
                    },
                  );
                }

                final workspace = workspaces[index];
                final isSelected = workspace.id == selectedId;

                return ListTile(
                  title: Text(workspace.name),
                  subtitle: Text('${workspace.location}, ${workspace.country}'),
                  leading: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : const Icon(Icons.circle_outlined),
                  selected: isSelected,
                  trailing: user.isAdmin
                      ? IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          tooltip: 'Edit workspace',
                          onPressed: () async {
                            // Show edit workspace dialog
                            final updated = await showDialog<bool>(
                              context: context,
                              builder: (context) => EditWorkspaceDialog(
                                workspace: workspace,
                                onWorkspaceUpdated: () {
                                  // Workspace updated, refresh the list
                                  ref.invalidate(activeWorkspacesFutureProvider);
                                },
                              ),
                            );

                            // If workspace was updated, refresh the list
                            if (updated == true && context.mounted) {
                              // Refresh workspace list
                              ref.invalidate(activeWorkspacesFutureProvider);
                            }
                          },
                        )
                      : null,
                  onTap: () async {
                    final error = await switchWorkspace(ref, user.id, workspace.id);
                    if (context.mounted) {
                      if (error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                        );
                      } else {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Switched to ${workspace.name}'),
                          ),
                        );
                      }
                    }
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Text('Error loading workspaces: $error'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

