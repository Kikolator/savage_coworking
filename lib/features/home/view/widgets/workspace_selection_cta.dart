import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/providers/auth_providers.dart';
import '../../../hot_desk_booking/models/workspace.dart';
import '../../../hot_desk_booking/providers/workspace_providers.dart';
import '../../../workspace/providers/workspace_selection_providers.dart';

class WorkspaceSelectionCTA extends ConsumerStatefulWidget {
  const WorkspaceSelectionCTA({super.key});

  @override
  ConsumerState<WorkspaceSelectionCTA> createState() =>
      _WorkspaceSelectionCTAState();
}

class _WorkspaceSelectionCTAState extends ConsumerState<WorkspaceSelectionCTA> {
  bool _isLoading = false;

  Future<void> _showWorkspaceSelectionDialog() async {
    setState(() => _isLoading = true);
    
    try {
      final workspaces = await ref.read(activeWorkspacesFutureProvider.future);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (workspaces.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No workspaces available. Please contact an administrator.'),
          ),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) => _WorkspaceSelectionDialog(workspaces: workspaces),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading workspaces: ${error.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.business,
                    color: colorScheme.onPrimaryContainer,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose a Workspace',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Select a workspace to start booking desks and managing your reservations.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _showWorkspaceSelectionDialog,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.arrow_forward),
                label: const Text('Choose Workspace'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceSelectionDialog extends ConsumerStatefulWidget {
  const _WorkspaceSelectionDialog({required this.workspaces});

  final List<Workspace> workspaces;

  @override
  ConsumerState<_WorkspaceSelectionDialog> createState() =>
      _WorkspaceSelectionDialogState();
}

class _WorkspaceSelectionDialogState
    extends ConsumerState<_WorkspaceSelectionDialog> {
  bool _isSubmitting = false;

  Future<void> _selectWorkspace(Workspace workspace) async {
    final authState = ref.read(authViewModelProvider);
    final user = authState.user;
    if (user == null) return;

    setState(() => _isSubmitting = true);

    try {
      final error = await switchWorkspace(ref, user.id, workspace.id);
      if (!mounted) return;

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to select workspace: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Workspace selected successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select Workspace',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _isSubmitting
                        ? null
                        : () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.workspaces.length,
                itemBuilder: (context, index) {
                  final workspace = widget.workspaces[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.business,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    title: Text(workspace.name),
                    subtitle: Text('${workspace.location}, ${workspace.country}'),
                    trailing: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.chevron_right),
                    onTap: _isSubmitting
                        ? null
                        : () => _selectWorkspace(workspace),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

