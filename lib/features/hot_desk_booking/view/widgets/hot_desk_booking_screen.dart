import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/hot_desk_booking.dart';
import '../../models/hot_desk_booking_request.dart';
import '../../models/hot_desk_booking_status.dart';
import '../../models/hot_desk_booking_source.dart';
import '../../providers/desk_providers.dart';
import '../hot_desk_booking_view.dart';
import 'bookings_list_widget.dart';
import 'date_time_selector_widget.dart';
import 'desk_selector_widget.dart';
import 'quick_stats_bar.dart';
import 'booking_confirmation_dialog.dart';

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
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
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
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
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
    final isMobile = !twoColumn;

    final children = [
      _BookingFormCard(props: props, isMobile: isMobile),
      SizedBox(height: isMobile ? 16 : 24, width: isMobile ? 0 : 24),
      _BookingsListCard(bookings: props.state.bookings, props: props),
    ];

    if (twoColumn) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(flex: 2, child: children[0]),
          SizedBox(width: 24),
          Flexible(flex: 3, child: children[2]),
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading...'),
        ],
      ),
    );
  }
}

class _BookingFormCard extends ConsumerStatefulWidget {
  const _BookingFormCard({required this.props, this.isMobile = false});

  final HotDeskBookingViewProps props;
  final bool isMobile;

  @override
  ConsumerState<_BookingFormCard> createState() => _BookingFormCardState();
}

class _BookingFormCardState extends ConsumerState<_BookingFormCard> {
  final _purposeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _startAt;
  DateTime? _endAt;
  String? _selectedDeskId;
  String? _workspaceFilter;

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
    _purposeController.dispose();
    super.dispose();
  }

  void _handleDurationPreset(Duration duration) {
    if (_startAt != null) {
      setState(() {
        _endAt = _startAt!.add(duration);
      });
    }
  }

  Future<void> _handleBooking() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startAt == null || _endAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start and end time')),
      );
      return;
    }

    if (_selectedDeskId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a desk')));
      return;
    }

    // Get selected desk
    final desksAsync = ref.read(availableDesksProvider(_workspaceFilter));
    final desks = desksAsync.value;
    if (desks == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait for desks to load')),
      );
      return;
    }
    final selectedDesk = desks.firstWhere(
      (d) => d.id == _selectedDeskId,
      orElse: () => throw StateError('Desk not found'),
    );

    final request = HotDeskBookingRequest(
      workspaceId: selectedDesk.workspaceId,
      deskId: selectedDesk.id,
      startAt: _startAt!,
      endAt: _endAt!,
      purpose: _purposeController.text.trim().isEmpty
          ? null
          : _purposeController.text.trim(),
    );

    final failure = await widget.props.onCreateBooking(request);

    if (failure == null && context.mounted) {
      // Show confirmation dialog
      final booking = HotDeskBooking(
        id: '', // Will be set by repository
        userId: '', // Not needed for display
        workspaceId: selectedDesk.workspaceId,
        deskId: selectedDesk.id,
        startAt: _startAt!,
        endAt: _endAt!,
        status: HotDeskBookingStatus.pending,
        source: HotDeskBookingSource.app,
        purpose: request.purpose,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      // Reset form
      setState(() {
        _selectedDeskId = null;
        _purposeController.clear();
        final now = DateTime.now().toUtc();
        final roundedStart = DateTime(
          now.year,
          now.month,
          now.day,
          now.hour,
        ).add(const Duration(hours: 1));
        _startAt = roundedStart;
        _endAt = roundedStart.add(const Duration(hours: 2));
      });

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => BookingConfirmationDialog(
            booking: booking,
            onAddToCalendar: () {
              // TODO: Implement calendar integration
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Calendar integration coming soon'),
                ),
              );
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final desksAsync = ref.watch(availableDesksProvider(_workspaceFilter));
    final availableCount = desksAsync.value?.length ?? 0;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Book a desk',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              // Quick stats bar
              if (_startAt != null)
                QuickStatsBar(
                  availableDesksCount: availableCount,
                  selectedDate: _startAt,
                ),
              if (_startAt != null) const SizedBox(height: 16),
              // Date/time selector with presets
              DateTimeSelectorWidget(
                startAt: _startAt,
                endAt: _endAt,
                onStartChanged: (value) => setState(() => _startAt = value),
                onEndChanged: (value) => setState(() => _endAt = value),
                onDurationPreset: _handleDurationPreset,
              ),
              const SizedBox(height: 24),
              // Visual desk selector
              Text(
                'Select a desk',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              DeskSelectorWidget(
                selectedDeskId: _selectedDeskId,
                onDeskSelected: (deskId) {
                  setState(() {
                    _selectedDeskId = deskId;
                    if (deskId != null) {
                      // Update workspace filter based on selected desk
                      desksAsync.whenData((desks) {
                        final desk = desks.firstWhere((d) => d.id == deskId);
                        setState(() {
                          _workspaceFilter = desk.workspaceId;
                        });
                      });
                    }
                  });
                },
                workspaceId: _workspaceFilter,
                startAt: _startAt,
                endAt: _endAt,
              ),
              const SizedBox(height: 16),
              // Purpose field
              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(
                  labelText: 'Purpose (optional)',
                  hintText: 'e.g., Team meeting, Focus work',
                ),
                maxLength: 140,
              ),
              const SizedBox(height: 24),
              // Reserve button
              Semantics(
                label: 'Reserve selected desk',
                button: true,
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: widget.props.state.isSubmitting
                        ? null
                        : _handleBooking,
                    icon: const Icon(Icons.event_available),
                    label: const Text('Reserve desk'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(
                        double.infinity,
                        48,
                      ), // ≥48dp height
                    ),
                  ),
                ),
              ),
            ],
          ),
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
        child: BookingsListWidget(bookings: bookings, props: props),
      ),
    );
  }
}
