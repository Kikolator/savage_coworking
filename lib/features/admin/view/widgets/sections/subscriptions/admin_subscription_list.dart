import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../providers/admin_subscription_providers.dart';
import '../../../../viewmodel/admin_subscription_view_model.dart';
import '../../../../models/admin_subscription_models.dart';
import '../../../../../subscription/models/subscription_status.dart';
import '../../../../../subscription/models/subscription.dart';
import 'admin_subscription_detail_dialog.dart';
import 'status_chip.dart';

class AdminSubscriptionList extends ConsumerWidget {
  const AdminSubscriptionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(adminSubscriptionViewModelProvider);
    final viewModel = ref.read(adminSubscriptionViewModelProvider.notifier);

    if (state.isLoading && state.subscriptions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _buildFilters(context, ref, state, viewModel),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 16),
        ),
        if (state.subscriptions.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Text(
                'No subscriptions found',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = state.subscriptions[index];
                return _SubscriptionCard(
                  item: item,
                  onTap: () {
                    viewModel.selectSubscription(item);
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const AdminSubscriptionDetailDialog(),
                    );
                  },
                );
              },
              childCount: state.subscriptions.length,
            ),
          ),
      ],
    );
  }

  Widget _buildFilters(
    BuildContext context,
    WidgetRef ref,
    AdminSubscriptionState state,
    AdminSubscriptionViewModel viewModel,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search by user or plan...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: state.filters.searchQuery != null &&
                      state.filters.searchQuery!.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        viewModel.updateFilters(
                          state.filters.copyWith(clearSearchQuery: true),
                        );
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              viewModel.updateFilters(
                state.filters.copyWith(searchQuery: value.isEmpty ? null : value),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        DropdownButton<SubscriptionStatus?>(
          value: state.filters.status,
          hint: const Text('All Statuses'),
          items: [
            const DropdownMenuItem<SubscriptionStatus?>(
              value: null,
              child: Text('All Statuses'),
            ),
            ...SubscriptionStatus.values.map(
              (status) => DropdownMenuItem<SubscriptionStatus?>(
                value: status,
                child: Text(status.label),
              ),
            ),
          ],
          onChanged: (status) {
            viewModel.updateFilters(
              state.filters.copyWith(
                status: status,
                clearStatus: status == null,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({
    required this.item,
    required this.onTap,
  });

  final AdminSubscriptionListItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subscription = item.subscription;
    final dateFormat = DateFormat('MMM d, y');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.displayName,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subscription.planName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusChip(status: subscription.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      label: 'Billing',
                      value: subscription.billingCycle,
                    ),
                  ),
                  Expanded(
                    child: _InfoItem(
                      label: 'Period',
                      value:
                          '${dateFormat.format(subscription.currentPeriodStart)} - ${dateFormat.format(subscription.currentPeriodEnd)}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      label: 'Desk Hours',
                      value:
                          '${subscription.deskHoursUsed.toStringAsFixed(0)}/${subscription.deskHours == 0 ? '∞' : subscription.deskHours.toStringAsFixed(0)}',
                    ),
                  ),
                  Expanded(
                    child: _InfoItem(
                      label: 'Meeting Room Hours',
                      value:
                          '${subscription.meetingRoomHoursUsed.toStringAsFixed(0)}/${subscription.meetingRoomHours == 0 ? '∞' : subscription.meetingRoomHours.toStringAsFixed(0)}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

