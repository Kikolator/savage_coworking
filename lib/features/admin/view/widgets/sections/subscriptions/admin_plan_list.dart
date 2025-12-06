import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/admin_subscription_providers.dart';
import '../../../../models/admin_subscription_models.dart';
import '../../../../../subscription/models/subscription_plan.dart';
import 'admin_plan_form_dialog.dart';

class AdminPlanList extends ConsumerWidget {
  const AdminPlanList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(adminSubscriptionViewModelProvider);
    final viewModel = ref.read(adminSubscriptionViewModelProvider.notifier);

    if (state.isLoading && state.plans.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subscription Plans',
                style: theme.textTheme.titleMedium,
              ),
              FilledButton.icon(
                onPressed: () {
                  viewModel.selectPlan(null);
                  showDialog(
                    context: context,
                    builder: (context) => const AdminPlanFormDialog(),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Create Plan'),
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 16),
        ),
        if (state.plans.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Text(
                'No plans found. Create your first plan.',
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
                final plan = state.plans[index];
                return _PlanCard(
                  plan: plan,
                  onEdit: () {
                    viewModel.selectPlan(plan);
                    showDialog(
                      context: context,
                      builder: (context) => const AdminPlanFormDialog(),
                    );
                  },
                  onDelete: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Plan'),
                        content: Text(
                          'Are you sure you want to delete "${plan.name}"? This will deactivate the plan.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: FilledButton.styleFrom(
                              backgroundColor: theme.colorScheme.error,
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && context.mounted) {
                      await viewModel.deletePlan(plan.id);
                    }
                  },
                  onToggleActive: () async {
                    await viewModel.updatePlan(
                      plan.id,
                      AdminPlanFormData.fromPlan(plan).copyWith(
                        isActive: !plan.isActive,
                      ),
                    );
                  },
                );
              },
              childCount: state.plans.length,
            ),
          ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleActive,
  });

  final SubscriptionPlan plan;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                      Row(
                        children: [
                          Text(
                            plan.name,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(plan.isActive ? 'Active' : 'Inactive'),
                            backgroundColor: plan.isActive
                                ? theme.colorScheme.primaryContainer
                                : theme.colorScheme.surfaceContainerHighest,
                            labelStyle: TextStyle(
                              color: plan.isActive
                                  ? theme.colorScheme.onPrimaryContainer
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        plan.formattedPrice,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                      onTap: onEdit,
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            plan.isActive ? Icons.visibility_off : Icons.visibility,
                          ),
                          const SizedBox(width: 8),
                          Text(plan.isActive ? 'Deactivate' : 'Activate'),
                        ],
                      ),
                      onTap: onToggleActive,
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: theme.colorScheme.error),
                          const SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ],
                      ),
                      onTap: onDelete,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PlanInfoItem(
                    label: 'Interval',
                    value: plan.billingCycle,
                  ),
                ),
                Expanded(
                  child: _PlanInfoItem(
                    label: 'Desk Hours',
                    value: plan.deskHoursLabel,
                  ),
                ),
                Expanded(
                  child: _PlanInfoItem(
                    label: 'Meeting Room Hours',
                    value: plan.meetingRoomHoursLabel,
                  ),
                ),
              ],
            ),
            if (plan.features.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: plan.features
                    .map(
                      (feature) => Chip(
                        label: Text(feature),
                        labelStyle: theme.textTheme.bodySmall,
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlanInfoItem extends StatelessWidget {
  const _PlanInfoItem({
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

