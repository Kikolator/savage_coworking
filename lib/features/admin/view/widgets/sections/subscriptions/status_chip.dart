import 'package:flutter/material.dart';

import '../../../../../subscription/models/subscription_status.dart';

/// Reusable status chip widget with theme-based color coding
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.status,
    this.size = StatusChipSize.medium,
  });

  final SubscriptionStatus status;
  final StatusChipSize size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final (backgroundColor, textColor) = _getColors(colorScheme);

    final textStyle = size == StatusChipSize.small
        ? theme.textTheme.labelSmall
        : theme.textTheme.labelMedium;

    return Chip(
      label: Text(
        status.label,
        style: textStyle?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: backgroundColor,
      padding: EdgeInsets.symmetric(
        horizontal: size == StatusChipSize.small ? 8 : 12,
        vertical: size == StatusChipSize.small ? 4 : 6,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  (Color, Color) _getColors(ColorScheme colorScheme) {
    switch (status) {
      case SubscriptionStatus.active:
        return (
          colorScheme.primaryContainer,
          colorScheme.onPrimaryContainer,
        );
      case SubscriptionStatus.cancelled:
      case SubscriptionStatus.expired:
        return (
          colorScheme.errorContainer,
          colorScheme.onErrorContainer,
        );
      case SubscriptionStatus.trial:
        return (
          colorScheme.tertiaryContainer,
          colorScheme.onTertiaryContainer,
        );
      case SubscriptionStatus.pastDue:
        return (
          colorScheme.secondaryContainer,
          colorScheme.onSecondaryContainer,
        );
    }
  }
}

enum StatusChipSize {
  small,
  medium,
}

