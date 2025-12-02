import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Combined date-time selector with quick presets
class DateTimeSelectorWidget extends StatelessWidget {
  const DateTimeSelectorWidget({
    super.key,
    required this.startAt,
    required this.endAt,
    required this.onStartChanged,
    required this.onEndChanged,
    this.onDurationPreset,
  });

  final DateTime? startAt;
  final DateTime? endAt;
  final ValueChanged<DateTime?> onStartChanged;
  final ValueChanged<DateTime?> onEndChanged;
  final ValueChanged<Duration>? onDurationPreset;

  Future<void> _pickDateTime(
    BuildContext context,
    DateTime? initial,
    ValueChanged<DateTime?> onChanged,
  ) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initial ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial ?? now),
    );
    if (time == null || !context.mounted) return;

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    onChanged(selected.toUtc());
  }

  void _applyQuickDatePreset(String preset, BuildContext context) {
    final now = DateTime.now();
    DateTime newStart;

    switch (preset) {
      case 'today':
        newStart = DateTime(
          now.year,
          now.month,
          now.day,
          now.hour + 1, // Next hour
          0,
        );
        break;
      case 'tomorrow':
        newStart = DateTime(
          now.year,
          now.month,
          now.day + 1,
          9, // 9 AM
          0,
        );
        break;
      case 'thisWeek':
        final daysUntilMonday = (DateTime.monday - now.weekday) % 7;
        newStart = DateTime(
          now.year,
          now.month,
          now.day + (daysUntilMonday == 0 ? 7 : daysUntilMonday),
          9,
          0,
        );
        break;
      default:
        return;
    }

    onStartChanged(newStart.toUtc());
    onEndChanged(newStart.add(const Duration(hours: 2)).toUtc());
  }

  void _applyDurationPreset(String preset) {
    if (startAt == null || onDurationPreset == null) return;

    Duration duration;
    switch (preset) {
      case '2h':
        duration = const Duration(hours: 2);
        break;
      case 'halfDay':
        duration = const Duration(hours: 4);
        break;
      case 'fullDay':
        duration = const Duration(hours: 8);
        break;
      default:
        return;
    }

    onDurationPreset!(duration);
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMM d, h:mm a');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick date presets
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _QuickPresetChip(
              label: 'Today',
              icon: Icons.today,
              onTap: () => _applyQuickDatePreset('today', context),
            ),
            _QuickPresetChip(
              label: 'Tomorrow',
              icon: Icons.event,
              onTap: () => _applyQuickDatePreset('tomorrow', context),
            ),
            _QuickPresetChip(
              label: 'This Week',
              icon: Icons.calendar_view_week,
              onTap: () => _applyQuickDatePreset('thisWeek', context),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Date-time selectors
        Row(
          children: [
            Expanded(
              child: _DateTimeField(
                label: 'Start',
                value: startAt,
                formatter: formatter,
                onTap: () => _pickDateTime(context, startAt, onStartChanged),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DateTimeField(
                label: 'End',
                value: endAt,
                formatter: formatter,
                onTap: () => _pickDateTime(context, endAt, onEndChanged),
              ),
            ),
          ],
        ),
        if (startAt != null && endAt != null) ...[
          const SizedBox(height: 12),
          // Duration presets
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _DurationPresetChip(
                label: '2 hours',
                onTap: () => _applyDurationPreset('2h'),
              ),
              _DurationPresetChip(
                label: 'Half day',
                onTap: () => _applyDurationPreset('halfDay'),
              ),
              _DurationPresetChip(
                label: 'Full day',
                onTap: () => _applyDurationPreset('fullDay'),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _QuickPresetChip extends StatelessWidget {
  const _QuickPresetChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Quick preset: $label',
      button: true,
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        onSelected: (_) => onTap(),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class _DurationPresetChip extends StatelessWidget {
  const _DurationPresetChip({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      onSelected: (_) => onTap(),
    );
  }
}

class _DateTimeField extends StatelessWidget {
  const _DateTimeField({
    required this.label,
    required this.value,
    required this.formatter,
    required this.onTap,
  });

  final String label;
  final DateTime? value;
  final DateFormat formatter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = value == null
        ? 'Select'
        : formatter.format(value!.toLocal());
    return Semantics(
      label: '$label date and time: $text',
      button: true,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48), // Ensure touch target ≥48dp
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 4),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}

