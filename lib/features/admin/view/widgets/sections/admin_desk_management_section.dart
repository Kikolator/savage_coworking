import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../hot_desk_booking/providers/desk_providers.dart';
import 'desk_management/desk_list_widget.dart';
import 'desk_management/create_desk_dialog.dart';

class AdminDeskManagementSection extends ConsumerWidget {
  const AdminDeskManagementSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final desksAsync = ref.watch(availableDesksProvider(null));

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
        desksAsync.when(
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
                    ref.refresh(availableDesksProvider(null));
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
    showDialog(
      context: context,
      builder: (context) => CreateDeskDialog(
        onDeskCreated: () {
          // ignore: unused_result
          ref.refresh(availableDesksProvider(null));
        },
      ),
    );
  }
}

