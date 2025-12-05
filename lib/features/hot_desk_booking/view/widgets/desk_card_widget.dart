import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/desk.dart';
import '../../providers/workspace_providers.dart';

enum DeskAvailability { available, booked, soonAvailable }

class DeskCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final availabilityColor = _getAvailabilityColor(context);
    final isAvailable =
        availability == DeskAvailability.available ||
        availability == DeskAvailability.soonAvailable;
    final workspaceAsync = ref.watch(workspaceProvider(desk.workspaceId));
    final hasImage = desk.imageUrl != null;

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
            label:
                '${desk.name} desk in ${desk.workspaceId}, ${_getAvailabilityLabel().toLowerCase()}',
            selected: isSelected,
            button: isAvailable && onTap != null,
            child: Container(
              decoration: hasImage
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(desk.imageUrl!),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withValues(alpha: 0.3),
                          BlendMode.darken,
                        ),
                      ),
                    )
                  : null,
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
                              color: hasImage ? Colors.white : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Improved badge visibility with semi-transparent background
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: hasImage
                                ? Colors.white.withValues(alpha: 0.95)
                                : availabilityColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: hasImage
                                ? Border.all(
                                    color: availabilityColor.withValues(
                                      alpha: 0.3,
                                    ),
                                    width: 1,
                                  )
                                : null,
                            boxShadow: hasImage
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getAvailabilityIcon(),
                                size: 16,
                                color: hasImage
                                    ? availabilityColor
                                    : availabilityColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _getAvailabilityLabel(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: hasImage
                                      ? availabilityColor
                                      : availabilityColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    workspaceAsync.when(
                      data: (workspace) => Row(
                        children: [
                          Icon(
                            Icons.business_outlined,
                            size: 14,
                            color: hasImage
                                ? Colors.white.withValues(alpha: 0.9)
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              workspace?.name ?? desk.workspaceId,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: hasImage
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      loading: () => Row(
                        children: [
                          Icon(
                            Icons.business_outlined,
                            size: 14,
                            color: hasImage
                                ? Colors.white.withValues(alpha: 0.9)
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              desk.workspaceId,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: hasImage
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      error: (_, __) => Row(
                        children: [
                          Icon(
                            Icons.business_outlined,
                            size: 14,
                            color: hasImage
                                ? Colors.white.withValues(alpha: 0.9)
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              desk.workspaceId,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: hasImage
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
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
      ),
    );
  }
}
