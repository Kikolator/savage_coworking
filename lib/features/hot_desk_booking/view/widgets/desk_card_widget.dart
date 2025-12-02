import 'package:flutter/material.dart';

import '../../models/desk.dart';

enum DeskAvailability {
  available,
  booked,
  soonAvailable,
}

class DeskCard extends StatelessWidget {
  const DeskCard({
    super.key,
    required this.desk,
    required this.isSelected,
    required this.availability,
    this.onTap,
  });

  final Desk desk;
  final bool isSelected;
  final DeskAvailability availability;
  final VoidCallback? onTap;

  Color _getAvailabilityColor(BuildContext context) {
    switch (availability) {
      case DeskAvailability.available:
        return Colors.green;
      case DeskAvailability.booked:
        return Colors.red;
      case DeskAvailability.soonAvailable:
        return Colors.orange;
    }
  }

  String _getAvailabilityLabel() {
    switch (availability) {
      case DeskAvailability.available:
        return 'Available';
      case DeskAvailability.booked:
        return 'Booked';
      case DeskAvailability.soonAvailable:
        return 'Soon';
    }
  }

  IconData _getAvailabilityIcon() {
    switch (availability) {
      case DeskAvailability.available:
        return Icons.check_circle_outline;
      case DeskAvailability.booked:
        return Icons.block;
      case DeskAvailability.soonAvailable:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final availabilityColor = _getAvailabilityColor(context);
    final isAvailable = availability == DeskAvailability.available;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Card(
        elevation: isSelected ? 4 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: isAvailable ? onTap : null,
          borderRadius: BorderRadius.circular(12),
            child: Semantics(
            label: '${desk.name} desk in ${desk.workspaceId}, ${_getAvailabilityLabel().toLowerCase()}',
            selected: isSelected,
            button: isAvailable,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      desk.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: availabilityColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getAvailabilityIcon(),
                          size: 14,
                          color: availabilityColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getAvailabilityLabel(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: availabilityColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      desk.workspaceId,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (isSelected) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Selected',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

