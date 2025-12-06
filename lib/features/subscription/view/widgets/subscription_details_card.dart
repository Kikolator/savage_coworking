import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/subscription.dart';
import '../../models/subscription_status.dart';

class SubscriptionDetailsCard extends StatelessWidget {
  const SubscriptionDetailsCard({
    super.key,
    required this.subscription,
    required this.onCancelSubscription,
  });

  final Subscription subscription;
  final Future<void> Function(bool cancelAtPeriodEnd) onCancelSubscription;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final deskHoursLeft = subscription.deskHoursLeft;
    final meetingRoomHoursLeft = subscription.meetingRoomHoursLeft;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subscription.planName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: subscription.status.isActive
                              ? Colors.green[100]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          subscription.status.label,
                          style: TextStyle(
                            color: subscription.status.isActive
                                ? Colors.green[800]
                                : Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (subscription.cancelAtPeriodEnd)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Cancelling at period end',
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),
            _DetailRow(
              label: 'Billing Cycle',
              value: subscription.billingCycle,
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 16),
            _DetailRow(
              label: 'Period Start',
              value: dateFormat.format(subscription.currentPeriodStart),
              icon: Icons.event,
            ),
            const SizedBox(height: 16),
            _DetailRow(
              label: 'Period End',
              value: dateFormat.format(subscription.currentPeriodEnd),
              icon: Icons.event_available,
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),
            const Text(
              'Hours Remaining',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _HoursCard(
              icon: Icons.desk,
              label: 'Desk Hours',
              used: subscription.deskHoursUsed,
              total: subscription.deskHours,
              remaining: deskHoursLeft,
            ),
            const SizedBox(height: 12),
            _HoursCard(
              icon: Icons.meeting_room,
              label: 'Meeting Room Hours',
              used: subscription.meetingRoomHoursUsed,
              total: subscription.meetingRoomHours,
              remaining: meetingRoomHoursLeft,
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),
            if (subscription.status.isActive && !subscription.cancelAtPeriodEnd)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showCancelDialog(context),
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Cancel Subscription'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCancelDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Subscription'),
        content: const Text(
          'Do you want to cancel immediately or at the end of the current period?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel Now'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cancel at Period End'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Keep Subscription'),
          ),
        ],
      ),
    );

    if (result != null) {
      await onCancelSubscription(result);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result
                  ? 'Subscription will be cancelled at period end'
                  : 'Subscription cancelled',
            ),
          ),
        );
      }
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _HoursCard extends StatelessWidget {
  const _HoursCard({
    required this.icon,
    required this.label,
    required this.used,
    required this.total,
    required this.remaining,
  });

  final IconData icon;
  final String label;
  final double used;
  final double total;
  final double remaining;

  @override
  Widget build(BuildContext context) {
    final isUnlimited = total == 0;
    final progress = isUnlimited ? 0.0 : (used / total).clamp(0.0, 1.0);
    final remainingText = isUnlimited
        ? 'Unlimited'
        : remaining == double.infinity
            ? 'Unlimited'
            : '${remaining.toStringAsFixed(1)} hours left';

    return Card(
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: Colors.blue[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  remainingText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: remaining == 0 && !isUnlimited
                        ? Colors.red[700]
                        : Colors.blue[700],
                  ),
                ),
              ],
            ),
            if (!isUnlimited) ...[
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 1.0 ? Colors.red : Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${used.toStringAsFixed(1)} / ${total.toStringAsFixed(0)} hours used',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

