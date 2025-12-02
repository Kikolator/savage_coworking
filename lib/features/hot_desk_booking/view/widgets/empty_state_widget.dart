import 'package:flutter/material.dart';

/// Empty state widget for when no desks are available
class NoDesksEmptyState extends StatelessWidget {
  const NoDesksEmptyState({
    super.key,
    this.onClearFilter,
    this.hasFilter = false,
  });

  final VoidCallback? onClearFilter;
  final bool hasFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chair_alt_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No desks available',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              hasFilter
                  ? 'Try adjusting your filters to see more options.'
                  : 'Check back later for available desks.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilter && onClearFilter != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onClearFilter,
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state widget for when user has no bookings
class NoBookingsEmptyState extends StatelessWidget {
  const NoBookingsEmptyState({
    super.key,
    this.onBookDesk,
  });

  final VoidCallback? onBookDesk;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_available_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No bookings yet',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Reserve your first desk to get started.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onBookDesk != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onBookDesk,
                icon: const Icon(Icons.add),
                label: const Text('Book a desk'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state widget for when a date group has no bookings
class EmptyBookingGroup extends StatelessWidget {
  const EmptyBookingGroup({super.key, required this.dateLabel});

  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          'No bookings for $dateLabel',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

