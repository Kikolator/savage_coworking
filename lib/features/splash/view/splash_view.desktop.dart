import 'dart:ui';

import 'package:flutter/material.dart';
import '../viewmodel/splash_view_model.dart';

class SplashViewDesktop extends StatelessWidget {
  const SplashViewDesktop({
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
              theme.colorScheme.surfaceVariant,
              theme.colorScheme.primary.withOpacity(0.3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _StatusBoard(
                        state: state,
                        onRetry: onRetry,
                      ),
                    ),
                    const SizedBox(width: 48),
                    const Expanded(
                      flex: 2,
                      child: _SchedulePanel(),
                    ),
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

class _StatusBoard extends StatelessWidget {
  const _StatusBoard({
    required this.state,
    required this.onRetry,
  });

  final SplashState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Savage Coworking',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We are syncing reservations and team preferences.',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 24,
              runSpacing: 16,
              children: [
                _StatusBadge(
                  label: 'Desks',
                  value: '48 ready',
                  icon: Icons.event_seat_outlined,
                ),
                _StatusBadge(
                  label: 'Visitors',
                  value: '12 arrivals',
                  icon: Icons.badge_outlined,
                ),
                _StatusBadge(
                  label: 'Meetings',
                  value: '5 today',
                  icon: Icons.video_call_outlined,
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (state.isLoading)
              const LinearProgressIndicator(minHeight: 6)
            else
              const SizedBox(height: 6),
            if (state.errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                state.errorMessage!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: state.isLoading ? null : onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry sync'),
              ),
            ],
            const Spacer(),
            Text(
              'Need help? ops@savage.work',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.35),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
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

class _SchedulePanel extends StatelessWidget {
  const _SchedulePanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = [
      ('08:30', 'Design stand-up', 'War room A'),
      ('09:15', 'Client visit', 'Lounge'),
      ('11:00', 'Hybrid sync', 'Zoom / Desk 12'),
      ('13:00', 'Ops retro', 'Workshop'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s flow',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
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
                  subtitle: Text(
                    item.$3,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                );
              },
              separatorBuilder: (_, __) => Divider(
                color: theme.colorScheme.onSurface.withOpacity(0.08),
              ),
              itemCount: items.length,
            ),
          ),
        ],
      ),
    );
  }
}
