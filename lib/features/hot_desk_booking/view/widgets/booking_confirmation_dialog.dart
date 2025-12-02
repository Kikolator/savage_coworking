import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/hot_desk_booking.dart';

class BookingConfirmationDialog extends StatelessWidget {
  const BookingConfirmationDialog({
    super.key,
    required this.booking,
    this.onAddToCalendar,
  });

  final HotDeskBooking booking;
  final VoidCallback? onAddToCalendar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = DateFormat('EEE, MMM d, y • h:mm a');

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text('Booking Confirmed', style: theme.textTheme.titleLarge),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(
              label: 'Desk',
              value: booking.deskId,
              icon: Icons.chair_alt,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              label: 'Workspace',
              value: booking.workspaceId,
              icon: Icons.business,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              label: 'Start',
              value: formatter.format(booking.startAt.toLocal()),
              icon: Icons.access_time,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              label: 'End',
              value: formatter.format(booking.endAt.toLocal()),
              icon: Icons.event,
            ),
            if (booking.purpose != null) ...[
              const SizedBox(height: 12),
              _InfoRow(
                label: 'Purpose',
                value: booking.purpose!,
                icon: Icons.note,
              ),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking.id.isEmpty
                          ? 'Booking ID: (pending)'
                          : 'Booking ID: ${booking.id.length >= 8 ? booking.id.substring(0, 8) : booking.id}...',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        if (onAddToCalendar != null)
          FilledButton.icon(
            onPressed: () {
              onAddToCalendar!();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.calendar_today),
            label: const Text('Add to Calendar'),
          ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
