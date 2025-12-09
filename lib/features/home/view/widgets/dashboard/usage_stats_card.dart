import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../hot_desk_booking/models/hot_desk_booking_status.dart';
import '../../../../hot_desk_booking/providers/hot_desk_booking_providers.dart';
import '../../../../subscription/models/subscription.dart';

class UsageStatsCard extends ConsumerWidget {
  const UsageStatsCard({
    super.key,
    required this.userId,
    required this.subscription,
  });

  final String userId;
  final Subscription subscription;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(hotDeskBookingViewModelProvider(userId));
    final theme = Theme.of(context);

    // Calculate usage from completed bookings in current period
    final periodStart = subscription.currentPeriodStart.toUtc();
    final periodEnd = subscription.currentPeriodEnd.toUtc();

    final periodBookings = state.bookings.where((booking) {
      final bookingStart = booking.startAt.toUtc();
      return bookingStart.isAfter(periodStart) &&
          bookingStart.isBefore(periodEnd) &&
          (booking.status == HotDeskBookingStatus.completed ||
              booking.status == HotDeskBookingStatus.checkedIn);
    }).toList();

    double deskHoursUsed = 0;
    for (final booking in periodBookings) {
      final duration = booking.endAt.difference(booking.startAt);
      deskHoursUsed += duration.inMinutes / 60.0;
    }

    final deskHoursQuota = subscription.effectiveQuota.deskHoursPerPeriod;
    final meetingHoursQuota = subscription.effectiveQuota.meetingHoursPerPeriod;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usage Statistics',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            if (deskHoursQuota != null && deskHoursQuota > 0)
              _UsageItem(
                label: 'Desk Hours',
                used: deskHoursUsed,
                total: deskHoursQuota,
                icon: Icons.desktop_windows,
                theme: theme,
              ),
            if (deskHoursQuota != null && deskHoursQuota > 0)
              const SizedBox(height: 24),
            if (meetingHoursQuota != null && meetingHoursQuota > 0)
              _UsageItem(
                label: 'Meeting Hours',
                used: 0, // TODO: Calculate from meeting room bookings
                total: meetingHoursQuota,
                icon: Icons.video_call,
                theme: theme,
              ),
            if ((deskHoursQuota == null || deskHoursQuota == 0) &&
                (meetingHoursQuota == null || meetingHoursQuota == 0))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Unlimited access',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _UsageItem extends StatelessWidget {
  const _UsageItem({
    required this.label,
    required this.used,
    required this.total,
    required this.icon,
    required this.theme,
  });

  final String label;
  final double used;
  final double total;
  final IconData icon;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? (used / total).clamp(0.0, 1.0) : 0.0;
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '${used.toStringAsFixed(1)} / ${total.toStringAsFixed(1)} hrs',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              percentage > 0.9
                  ? colorScheme.error
                  : percentage > 0.7
                      ? Colors.orange
                      : colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

