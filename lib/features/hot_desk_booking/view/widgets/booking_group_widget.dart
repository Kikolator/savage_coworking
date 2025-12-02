import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/hot_desk_booking.dart';
import '../../models/hot_desk_booking_status.dart';
import '../hot_desk_booking_view.dart';
import 'empty_state_widget.dart';

class BookingGroupWidget extends StatefulWidget {
  const BookingGroupWidget({
    super.key,
    required this.dateLabel,
    required this.bookings,
    required this.props,
    this.initiallyExpanded = true,
  });

  final String dateLabel;
  final List<HotDeskBooking> bookings;
  final HotDeskBookingViewProps props;
  final bool initiallyExpanded;

  @override
  State<BookingGroupWidget> createState() => _BookingGroupWidgetState();
}

class _BookingGroupWidgetState extends State<BookingGroupWidget> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.bookings.isEmpty) {
      return EmptyBookingGroup(dateLabel: widget.dateLabel);
    }

    return Card(
      child: Column(
        children: [
          Semantics(
            label: '${widget.dateLabel} bookings group, ${widget.bookings.length} bookings',
            button: true,
            child: InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      widget.dateLabel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text('${widget.bookings.length}'),
                      backgroundColor: theme.colorScheme.primaryContainer,
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: _isExpanded ? 0 : 0.5,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.expand_more),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isExpanded)
            ...widget.bookings.map(
              (booking) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _BookingTile(
                  booking: booking,
                  props: widget.props,
                ),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _BookingTile extends StatelessWidget {
  const _BookingTile({
    required this.booking,
    required this.props,
  });

  final HotDeskBooking booking;
  final HotDeskBookingViewProps props;

  Color _statusColor(BuildContext context) {
    switch (booking.status) {
      case HotDeskBookingStatus.pending:
        return Colors.orange;
      case HotDeskBookingStatus.confirmed:
        return Colors.blue;
      case HotDeskBookingStatus.checkedIn:
        return Colors.green;
      case HotDeskBookingStatus.completed:
        return Colors.grey;
      case HotDeskBookingStatus.cancelled:
        return Colors.red;
      case HotDeskBookingStatus.noShow:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = DateFormat('h:mm a');
    final timeRange =
        '${formatter.format(booking.startAt.toLocal())} → ${formatter.format(booking.endAt.toLocal())}';

    final statusColor = _statusColor(context);
    final chipColor = statusColor.withValues(alpha: 0.2);
    final cardColor = theme.colorScheme.surfaceContainerHighest.withValues(
      alpha: 0.4,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Desk: ${booking.deskId}',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Chip(
                    backgroundColor: chipColor,
                    label: Text(
                      booking.status.label,
                      style: TextStyle(color: statusColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('Workspace: ${booking.workspaceId}'),
              const SizedBox(height: 4),
              Text(timeRange),
              if (booking.purpose != null) ...[
                const SizedBox(height: 4),
                Text('Purpose: ${booking.purpose}'),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  if (booking.status.isActive)
                    TextButton.icon(
                      onPressed: () =>
                          props.onCancelBooking(booking.id, reason: null),
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancel'),
                    ),
                  if (booking.status == HotDeskBookingStatus.pending ||
                      booking.status == HotDeskBookingStatus.confirmed)
                    TextButton.icon(
                      onPressed: () => props.onCheckIn(booking.id),
                      icon: const Icon(Icons.how_to_reg),
                      label: const Text('Check in'),
                    ),
                  if (booking.status == HotDeskBookingStatus.checkedIn)
                    TextButton.icon(
                      onPressed: () => props.onComplete(booking.id),
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Complete'),
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

