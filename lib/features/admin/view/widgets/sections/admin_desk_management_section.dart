import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../workspace/providers/workspace_selection_providers.dart';
import '../../../../hot_desk_booking/providers/desk_providers.dart';
import 'desk_management/desk_list_widget.dart';
import 'desk_management/create_desk_dialog.dart';

class AdminDeskManagementSection extends ConsumerWidget {
  const AdminDeskManagementSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspaceId = ref.watch(selectedWorkspaceIdProvider);
    final desksAsync = ref.watch(availableDesksProvider(workspaceId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Desk Management',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            FilledButton.icon(
              onPressed: () => _showCreateDeskDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Desk'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        workspaceId == null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.workspace_premium_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No workspace selected',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please select a workspace to manage desks.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : desksAsync.when(
                data: (desks) => DeskListWidget(desks: desks),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    children: [
                      Text('Error loading desks: $error'),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: () {
                          // ignore: unused_result
                          ref.refresh(availableDesksProvider(workspaceId));
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  void _showCreateDeskDialog(BuildContext context, WidgetRef ref) {
    final workspaceId = ref.read(selectedWorkspaceIdProvider);
    if (workspaceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a workspace first'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => CreateDeskDialog(
        onDeskCreated: () {
          // ignore: unused_result
          ref.refresh(availableDesksProvider(workspaceId));
        },
      ),
    );
  }
}
