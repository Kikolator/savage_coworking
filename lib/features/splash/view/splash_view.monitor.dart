import 'dart:ui';

import 'package:flutter/material.dart';
import '../viewmodel/splash_view_model.dart';

class SplashViewMonitor extends StatelessWidget {
  const SplashViewMonitor({
    super.key,
    required this.state,
    required this.onRetry,
  });

  final SplashState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.25),
              theme.colorScheme.surfaceVariant,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(48),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _MonitorStatusGrid(
                    state: state,
                    onRetry: onRetry,
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: const [
                      Expanded(child: _MonitorSchedulePanel()),
                      SizedBox(height: 24),
                      Expanded(child: _MonitorMetrics()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MonitorStatusGrid extends StatelessWidget {
  const _MonitorStatusGrid({
    required this.state,
    required this.onRetry,
  });

  final SplashState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Savage Command Center',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Monitoring hybrid teams, desk readiness, and concierge requests.',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: const [
                  _MonitorStatusTile(
                    title: 'Hybrid pods',
                    value: '6 active',
                    icon: Icons.hub_rounded,
                  ),
                  _MonitorStatusTile(
                    title: 'Desks prepped',
                    value: '48 / 48',
                    icon: Icons.roofing_outlined,
                  ),
                  _MonitorStatusTile(
                    title: 'Deliveries',
                    value: '3 awaiting',
                    icon: Icons.local_shipping_outlined,
                  ),
                  _MonitorStatusTile(
                    title: 'Visitors',
                    value: '12 signed in',
                    icon: Icons.verified_user_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (state.isLoading)
              const LinearProgressIndicator(minHeight: 8)
            else
              const SizedBox(height: 8),
            if (state.errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                state.errorMessage!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: state.isLoading ? null : onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MonitorStatusTile extends StatelessWidget {
  const _MonitorStatusTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonitorSchedulePanel extends StatelessWidget {
  const _MonitorSchedulePanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = [
      ('07:45', 'Facilities walkthrough', 'Ops Team'),
      ('09:00', 'Investor tour', 'Experience Crew'),
      ('10:30', 'Product workshop', 'Hybrid Room 2'),
      ('15:00', 'Community social', 'Café'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Operational timeline',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Text(
                    item.$1,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  title: Text(item.$2),
                  subtitle: Text(item.$3),
                );
              },
              separatorBuilder: (_, __) => Divider(
                color: theme.colorScheme.onSurface.withOpacity(0.08),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonitorMetrics extends StatelessWidget {
  const _MonitorMetrics();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final metrics = [
      ('Occupancy', '82%', Icons.groups_outlined),
      ('Focus pods', '5 free', Icons.headset_mic_outlined),
      ('Coffee bar', 'Ready', Icons.coffee_outlined),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.06),
        ),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live metrics',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          for (final metric in metrics) ...[
            _MetricCard(
              title: metric.$1,
              value: metric.$2,
              icon: metric.$3,
            ),
            if (metric != metrics.last)
              Divider(
                height: 32,
                color: theme.colorScheme.onSurface.withOpacity(0.08),
              ),
          ],
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
