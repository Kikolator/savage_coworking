import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'create_workspace_dialog.dart';

class NoWorkspaceDialog extends ConsumerWidget {
  const NoWorkspaceDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('No Workspace Found'),
      content: const Text(
        'You need to create a workspace before you can manage desks, rooms, bookings, and members. '
        'Would you like to create one now?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (context) => CreateWorkspaceDialog(
                onWorkspaceCreated: () {
                  // Workspace created, dialog will handle navigation
                },
              ),
            );
          },
          child: const Text('Create Workspace'),
        ),
      ],
    );
  }
}


