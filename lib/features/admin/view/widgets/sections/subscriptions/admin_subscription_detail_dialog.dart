import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../providers/admin_subscription_providers.dart';
import '../../../../viewmodel/admin_subscription_view_model.dart';
import '../../../../../subscription/models/subscription_status.dart';
import '../../../../../subscription/models/subscription.dart';
import 'status_chip.dart';

class AdminSubscriptionDetailDialog extends ConsumerWidget {
  const AdminSubscriptionDetailDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(adminSubscriptionViewModelProvider);
    final viewModel = ref.read(adminSubscriptionViewModelProvider.notifier);
    final subscriptionItem = state.selectedSubscription;

    if (subscriptionItem == null) {
      return const SizedBox.shrink();
    }

    final subscription = subscriptionItem.subscription;
    final dateFormat = DateFormat('MMM d, y • h:mm a');

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Subscription Details',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailSection(
                      title: 'User Information',
                      children: [
                        _DetailRow(
                          label: 'Name',
                          value: subscriptionItem.displayName,
                        ),
                        if (subscriptionItem.userEmail != null)
                          _DetailRow(
                            label: 'Email',
                            value: subscriptionItem.userEmail!,
                          ),
                        _DetailRow(
                          label: 'User ID',
                          value: subscription.userId,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _DetailSection(
                      title: 'Subscription Information',
                      children: [
                        _DetailRow(
                          label: 'Plan',
                          value: subscription.planName,
                        ),
                        _DetailRow(
                          label: 'Status',
                          value: StatusChip(status: subscription.status),
                        ),
                        _DetailRow(
                          label: 'Billing Cycle',
                          value: subscription.billingCycle,
                        ),
                        _DetailRow(
                          label: 'Renews Automatically',
                          value: subscription.renewsAutomatically ? 'Yes' : 'No',
                        ),
                        if (subscription.cancelAtPeriodEnd)
                          _DetailRow(
                            label: 'Cancellation',
                            value: 'Will cancel at period end',
                            valueStyle: TextStyle(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _DetailSection(
                      title: 'Period Information',
                      children: [
                        _DetailRow(
                          label: 'Current Period Start',
                          value: dateFormat.format(subscription.currentPeriodStart),
                        ),
                        _DetailRow(
                          label: 'Current Period End',
                          value: dateFormat.format(subscription.currentPeriodEnd),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _DetailSection(
                      title: 'Hours Allocation',
                      children: [
                        _DetailRow(
                          label: 'Desk Hours',
                          value:
                              '${subscription.deskHoursUsed.toStringAsFixed(0)} / ${subscription.deskHours == 0 ? '∞' : subscription.deskHours.toStringAsFixed(0)}',
                        ),
                        _DetailRow(
                          label: 'Meeting Room Hours',
                          value:
                              '${subscription.meetingRoomHoursUsed.toStringAsFixed(0)} / ${subscription.meetingRoomHours == 0 ? '∞' : subscription.meetingRoomHours.toStringAsFixed(0)}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _DetailSection(
                      title: 'Stripe Information',
                      children: [
                        _DetailRow(
                          label: 'Customer ID',
                          value: subscription.stripeCustomerId,
                        ),
                        if (subscription.stripeSubscriptionId != null)
                          _DetailRow(
                            label: 'Subscription ID',
                            value: subscription.stripeSubscriptionId!,
                          ),
                        if (subscription.stripePaymentIntentId != null)
                          _DetailRow(
                            label: 'Payment Intent ID',
                            value: subscription.stripePaymentIntentId!,
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _DetailSection(
                      title: 'Actions',
                      children: [
                        if (subscription.status != SubscriptionStatus.cancelled &&
                            subscription.status != SubscriptionStatus.expired)
                          DropdownButtonFormField<SubscriptionStatus>(
                            value: subscription.status,
                            decoration: const InputDecoration(
                              labelText: 'Change Status',
                            ),
                            items: SubscriptionStatus.values
                                .where((s) =>
                                    s != SubscriptionStatus.cancelled &&
                                    s != SubscriptionStatus.expired)
                                .map(
                                  (status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status.label),
                                  ),
                                )
                                .toList(),
                            onChanged: (newStatus) async {
                              if (newStatus != null) {
                                await viewModel.updateSubscriptionStatus(
                                  subscription.id,
                                  newStatus,
                                );
                              }
                            },
                          ),
                        const SizedBox(height: 12),
                        if (subscription.status != SubscriptionStatus.cancelled &&
                            subscription.status != SubscriptionStatus.expired)
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Cancel Subscription'),
                                        content: const Text(
                                          'Cancel at period end? The subscription will remain active until the current period ends.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text('No'),
                                          ),
                                          FilledButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirmed == true && context.mounted) {
                                      await viewModel.cancelSubscription(
                                        subscription.id,
                                        false,
                                      );
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  icon: const Icon(Icons.schedule),
                                  label: const Text('Cancel at Period End'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Cancel Immediately'),
                                        content: const Text(
                                          'Are you sure you want to cancel this subscription immediately?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text('No'),
                                          ),
                                          FilledButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            style: FilledButton.styleFrom(
                                              backgroundColor:
                                                  theme.colorScheme.error,
                                            ),
                                            child: const Text('Yes, Cancel'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirmed == true && context.mounted) {
                                      await viewModel.cancelSubscription(
                                        subscription.id,
                                        true,
                                      );
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  icon: const Icon(Icons.cancel),
                                  label: const Text('Cancel Immediately'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: theme.colorScheme.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final String label;
  final dynamic value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: value is Widget
                ? value
                : Text(
                    value.toString(),
                    style: valueStyle ??
                        theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
          ),
        ],
      ),
    );
  }
}

