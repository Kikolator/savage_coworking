import 'package:flutter/material.dart';

import '../../../models/admin_dashboard_data.dart';
import '../../../models/admin_dashboard_section.dart';
import 'admin_section_detail_list.dart';

class AdminOverviewSection extends StatelessWidget {
  const AdminOverviewSection({
    super.key,
    required this.data,
    required this.onNavigateToSection,
  });

  final AdminDashboardData data;
  final void Function(AdminDashboardSection section) onNavigateToSection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final operationalSections = AdminDashboardSection.values
        .where((section) => section != AdminDashboardSection.overview);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Key metrics', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: data.summaryCards
              .map(
                (card) => _SummaryCard(card: card),
              )
              .toList(),
        ),
        const SizedBox(height: 32),
        Text('Operational pulse', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        ...operationalSections.map((section) {
          final details = data.detailsFor(section);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _OverviewSectionCard(
              section: section,
              detail: details.isEmpty ? null : details.first,
              onOpen: () => onNavigateToSection(section),
            ),
          );
        }),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.card});

  final AdminSummaryCardData card;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = card.trendDelta >= 0;
    final trendColor = isPositive
        ? theme.colorScheme.primary
        : theme.colorScheme.error;
    final formattedDelta =
        '${isPositive ? '+' : ''}${card.trendDelta.toStringAsFixed(1)}%';

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 220, maxWidth: 320),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.title,
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: 12),
              Text(
                card.value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                card.trendLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formattedDelta,
                style: theme.textTheme.titleSmall?.copyWith(color: trendColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewSectionCard extends StatelessWidget {
  const _OverviewSectionCard({
    required this.section,
    required this.detail,
    required this.onOpen,
  });

  final AdminDashboardSection section;
  final AdminSectionDetail? detail;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  section.label,
                  style: theme.textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: onOpen,
                  child: const Text('View details'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (detail != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail!.title,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    detail!.subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(detail!.status),
                    backgroundColor: theme.colorScheme.surfaceVariant,
                  ),
                  if (detail!.trailing != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      detail!.trailing!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              )
            else
              Text(
                'No updates available. Check back soon.',
                style: theme.textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}
