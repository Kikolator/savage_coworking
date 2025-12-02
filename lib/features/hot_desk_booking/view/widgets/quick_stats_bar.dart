import 'package:flutter/material.dart';

class QuickStatsBar extends StatelessWidget {
  const QuickStatsBar({
    super.key,
    required this.availableDesksCount,
    this.selectedDate,
  });

  final int availableDesksCount;
  final DateTime? selectedDate;

  String _getDateLabel() {
    if (selectedDate == null) return 'today';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
    );

    if (selected == today) {
      return 'today';
    } else if (selected == today.add(const Duration(days: 1))) {
      return 'tomorrow';
    } else {
      return 'selected date';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateLabel = _getDateLabel();

    return Card(
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.chair_alt,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$availableDesksCount desks available',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    'for $dateLabel',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer.withValues(
                        alpha: 0.7,
                      ),
                    ),
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

