import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../app/router/app_route.dart';
import '../../../../hot_desk_booking/models/hot_desk_booking.dart';
import '../../../../hot_desk_booking/models/hot_desk_booking_status.dart';
import '../../../../hot_desk_booking/providers/hot_desk_booking_providers.dart';
import '../../../../hot_desk_booking/providers/workspace_providers.dart';

class UpcomingBookingsCard extends ConsumerWidget {
  const UpcomingBookingsCard({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(hotDeskBookingViewModelProvider(userId));
    final theme = Theme.of(context);

    if (state.isLoading) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upcoming Bookings',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      );
    }

    final now = DateTime.now().toUtc();
    final upcomingBookings = state.bookings
        .where((booking) =>
            booking.status.isActive && booking.startAt.isAfter(now))
        .toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));

    final displayBookings = upcomingBookings.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Bookings',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (upcomingBookings.length > 5)
                  TextButton(
                    onPressed: () => context.go(AppRoute.bookings.path),
                    child: const Text('View All'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (displayBookings.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No upcoming bookings',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FilledButton.icon(
                        onPressed: () => context.go(AppRoute.hotDesk.path),
                        icon: const Icon(Icons.add),
                        label: const Text('Book a Desk'),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...displayBookings.map((booking) => _BookingItem(
                    booking: booking,
                    ref: ref,
                  )),
          ],
        ),
      ),
    );
  }
}

class _BookingItem extends ConsumerWidget {
  const _BookingItem({required this.booking, required this.ref});

  final HotDeskBooking booking;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final workspaceAsync = ref.watch(workspaceProvider(booking.workspaceId));

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 48,
            decoration: BoxDecoration(
              color: _getStatusColor(booking.status, theme),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workspaceAsync.value?.name ?? 'Workspace',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatBookingTime(booking),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (booking.purpose != null && booking.purpose!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    booking.purpose!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(booking.status, theme).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              booking.status.label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: _getStatusColor(booking.status, theme),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(HotDeskBookingStatus status, ThemeData theme) {
    switch (status) {
      case HotDeskBookingStatus.pending:
        return Colors.orange;
      case HotDeskBookingStatus.confirmed:
        return theme.colorScheme.primary;
      case HotDeskBookingStatus.checkedIn:
        return Colors.green;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  String _formatBookingTime(HotDeskBooking booking) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');
    final startLocal = booking.startAt.toLocal();
    final endLocal = booking.endAt.toLocal();

    if (startLocal.day == endLocal.day &&
        startLocal.month == endLocal.month &&
        startLocal.year == endLocal.year) {
      return '${dateFormat.format(startLocal)} • ${timeFormat.format(startLocal)} - ${timeFormat.format(endLocal)}';
    } else {
      return '${dateFormat.format(startLocal)} ${timeFormat.format(startLocal)} - ${dateFormat.format(endLocal)} ${timeFormat.format(endLocal)}';
    }
  }
}

