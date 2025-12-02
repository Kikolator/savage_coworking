import 'package:flutter/material.dart';

import '../../../models/admin_dashboard_data.dart';

class AdminSectionDetailList extends StatelessWidget {
  const AdminSectionDetailList({
    super.key,
    required this.details,
    required this.emptyLabel,
  });

  final List<AdminSectionDetail> details;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (details.isEmpty) {
      return _EmptyState(message: emptyLabel);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: details
          .map(
            (detail) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _DetailCard(detail: detail),
            ),
          )
          .toList(),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.detail});

  final AdminSectionDetail detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detail.title,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              detail.subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  backgroundColor:
                      theme.colorScheme.surfaceContainerHighest.withOpacity(0.6),
                  label: Text(detail.status),
                ),
                const Spacer(),
                if (detail.trailing != null)
                  Text(
                    detail.trailing!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
      ),
    );
  }
}
