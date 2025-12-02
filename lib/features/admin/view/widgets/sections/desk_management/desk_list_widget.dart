import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../hot_desk_booking/models/desk.dart';
import '../../../../../hot_desk_booking/providers/desk_providers.dart';
import 'edit_desk_dialog.dart';

class DeskListWidget extends ConsumerWidget {
  const DeskListWidget({super.key, required this.desks});

  final List<Desk> desks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (desks.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chair_alt_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'No desks yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your first desk to get started',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: desks.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final desk = desks[index];
          return _DeskListItem(
            desk: desk,
            onEdit: () => _showEditDialog(context, ref, desk),
            onDelete: () => _showDeleteConfirmation(context, ref, desk),
            onToggleActive: () => _toggleActive(context, ref, desk),
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Desk desk) {
    showDialog(
      context: context,
      builder: (context) => EditDeskDialog(
        desk: desk,
        onDeskUpdated: () {
          // ignore: unused_result
          ref.refresh(availableDesksProvider(null));
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, Desk desk) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Desk'),
        content: Text('Are you sure you want to delete "${desk.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final service = ref.read(deskServiceProvider);
              final error = await service.deleteDesk(desk.id);
              if (context.mounted) {
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                } else {
                  // ignore: unused_result
                  ref.refresh(availableDesksProvider(null));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Desk deleted successfully')),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _toggleActive(BuildContext context, WidgetRef ref, Desk desk) {
    final service = ref.read(deskServiceProvider);
    service.updateDesk(desk.id, isActive: !desk.isActive).then((error) {
      if (context.mounted) {
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else {
          // ignore: unused_result
          ref.refresh(availableDesksProvider(null));
        }
      }
    });
  }
}

class _DeskListItem extends StatelessWidget {
  const _DeskListItem({
    required this.desk,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleActive,
  });

  final Desk desk;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleActive;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(desk.name),
      subtitle: Text('Workspace: ${desk.workspaceId}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(value: desk.isActive, onChanged: (_) => onToggleActive()),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
            tooltip: 'Edit desk',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
            tooltip: 'Delete desk',
            color: Theme.of(context).colorScheme.error,
          ),
        ],
      ),
      leading: Icon(
        desk.isActive ? Icons.chair_alt : Icons.chair_alt_outlined,
        color: desk.isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
