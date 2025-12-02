import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/hot_desk_booking.dart';
import '../../models/hot_desk_booking_request.dart';
import '../../models/hot_desk_booking_status.dart';
import '../hot_desk_booking_view.dart';

class HotDeskBookingScreen extends StatelessWidget {
  const HotDeskBookingScreen({
    super.key,
    required this.props,
    required this.padding,
    this.maxWidth,
    required this.twoColumn,
  });

  final HotDeskBookingViewProps props;
  final EdgeInsets padding;
  final double? maxWidth;
  final bool twoColumn;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: props.state.isSubmitting
                ? const LinearProgressIndicator()
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth ?? double.infinity,
                ),
                child: Padding(
                  padding: padding,
                  child: props.state.isLoading
                      ? const _LoadingState()
                      : _Content(props: props, twoColumn: twoColumn),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.props, required this.twoColumn});

  final HotDeskBookingViewProps props;
  final bool twoColumn;

  @override
  Widget build(BuildContext context) {
    final children = [
      Flexible(flex: 2, child: _BookingFormCard(props: props)),
      const SizedBox(height: 24, width: 24),
      Flexible(
        flex: 3,
        child: _BookingsListCard(bookings: props.state.bookings, props: props),
      ),
    ];

    if (twoColumn) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _BookingFormCard extends StatefulWidget {
  const _BookingFormCard({required this.props});

  final HotDeskBookingViewProps props;

  @override
  State<_BookingFormCard> createState() => _BookingFormCardState();
}

class _BookingFormCardState extends State<_BookingFormCard> {
  final _workspaceController = TextEditingController();
  final _deskController = TextEditingController();
  final _purposeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _startAt;
  DateTime? _endAt;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now().toUtc();
    final roundedStart = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
    ).add(const Duration(hours: 1));
    _startAt = roundedStart;
    _endAt = roundedStart.add(const Duration(hours: 2));
  }

  @override
  void dispose() {
    _workspaceController.dispose();
    _deskController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                'Book a desk',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _workspaceController,
                decoration: const InputDecoration(
                  labelText: 'Workspace ID',
                  hintText: 'ex: workspace-01',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Workspace is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _deskController,
                decoration: const InputDecoration(
                  labelText: 'Desk ID',
                  hintText: 'ex: desk-21A',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Desk is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(
                  labelText: 'Purpose (optional)',
                ),
                maxLength: 140,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _DateTimeSelector(
                      label: 'Start',
                      value: _startAt,
                      onChanged: (value) => setState(() => _startAt = value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DateTimeSelector(
                      label: 'End',
                      value: _endAt,
                      onChanged: (value) => setState(() => _endAt = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: widget.props.state.isSubmitting
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          if (_startAt == null || _endAt == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please select start and end time',
                                ),
                              ),
                            );
                            return;
                          }

                          final request = HotDeskBookingRequest(
                            workspaceId: _workspaceController.text.trim(),
                            deskId: _deskController.text.trim(),
                            startAt: _startAt!,
                            endAt: _endAt!,
                            purpose: _purposeController.text.trim().isEmpty
                                ? null
                                : _purposeController.text.trim(),
                          );

                          await widget.props.onCreateBooking(request);
                        },
                  icon: const Icon(Icons.event_available),
                  label: const Text('Reserve desk'),
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

class _DateTimeSelector extends StatelessWidget {
  const _DateTimeSelector({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  Future<void> _pickDateTime(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: value ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(value ?? now),
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

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMM d, h:mm a');
    final text = value == null ? 'Select' : formatter.format(value!.toLocal());
    return OutlinedButton(
      onPressed: () => _pickDateTime(context),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 4),
            Text(text),
          ],
        ),
      ),
    );
  }
}

class _BookingsListCard extends StatelessWidget {
  const _BookingsListCard({required this.bookings, required this.props});

  final List<HotDeskBooking> bookings;
  final HotDeskBookingViewProps props;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming bookings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (bookings.isEmpty)
              const Text('No bookings yet. Reserve your first desk above.')
            else
              ...bookings.map(
                (booking) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _BookingTile(booking: booking, props: props),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BookingTile extends StatelessWidget {
  const _BookingTile({required this.booking, required this.props});

  final HotDeskBooking booking;
  final HotDeskBookingViewProps props;

  Color _statusColor(BuildContext context) {
    switch (booking.status) {
      case HotDeskBookingStatus.pending:
        return Colors.orange;
      case HotDeskBookingStatus.confirmed:
        return Colors.blue;
      case HotDeskBookingStatus.checkedIn:
        return Colors.green;
      case HotDeskBookingStatus.completed:
        return Colors.grey;
      case HotDeskBookingStatus.cancelled:
        return Colors.red;
      case HotDeskBookingStatus.noShow:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('EEE, MMM d • h:mm a');
    final timeRange =
        '${formatter.format(booking.startAt.toLocal())} → ${formatter.format(booking.endAt.toLocal())}';

    final statusColor = _statusColor(context);
    final chipColor = statusColor.withValues(alpha: 0.2);
    final cardColor = Theme.of(
      context,
    ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4);

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Desk ${booking.deskId}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Chip(
                  backgroundColor: chipColor,
                  label: Text(
                    booking.status.label,
                    style: TextStyle(color: statusColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Workspace: ${booking.workspaceId}'),
            const SizedBox(height: 4),
            Text(timeRange),
            if (booking.purpose != null) ...[
              const SizedBox(height: 4),
              Text('Purpose: ${booking.purpose}'),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                if (booking.status.isActive)
                  TextButton.icon(
                    onPressed: () =>
                        props.onCancelBooking(booking.id, reason: null),
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancel'),
                  ),
                if (booking.status == HotDeskBookingStatus.pending ||
                    booking.status == HotDeskBookingStatus.confirmed)
                  TextButton.icon(
                    onPressed: () => props.onCheckIn(booking.id),
                    icon: const Icon(Icons.how_to_reg),
                    label: const Text('Check in'),
                  ),
                if (booking.status == HotDeskBookingStatus.checkedIn)
                  TextButton.icon(
                    onPressed: () => props.onComplete(booking.id),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Complete'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
