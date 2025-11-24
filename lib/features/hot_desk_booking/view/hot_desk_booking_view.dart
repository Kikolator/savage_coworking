import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../../auth/view/auth_view.dart';
import '../models/hot_desk_booking_request.dart';
import '../models/hot_desk_booking_failure.dart';
import '../providers/hot_desk_booking_providers.dart';
import '../viewmodel/hot_desk_booking_view_model.dart';
import 'hot_desk_booking_view.desktop.dart';
import 'hot_desk_booking_view.monitor.dart';
import 'hot_desk_booking_view.phone.dart';
import 'hot_desk_booking_view.tablet.dart';

class HotDeskBookingView extends ConsumerWidget {
  const HotDeskBookingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final width = MediaQuery.of(context).size.width;

    if (authState.user == null) {
      return const AuthView();
    }

    final userId = authState.user!.id;
    final state = ref.watch(hotDeskBookingViewModelProvider(userId));
    final viewModel = ref.read(
      hotDeskBookingViewModelProvider(userId).notifier,
    );

    ref.listen<HotDeskBookingFailure?>(
      hotDeskBookingViewModelProvider(userId).select((state) => state.failure),
      (previous, next) {
        if (next == null) return;
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(SnackBar(content: Text(_failureMessage(next))));
        viewModel.clearFailure();
      },
    );

    HotDeskBookingStatefulBuilder builder;

    if (width >= 1280) {
      builder = (props) => HotDeskBookingViewMonitor(props: props);
    } else if (width >= 769) {
      builder = (props) => HotDeskBookingViewDesktop(props: props);
    } else if (width >= 481) {
      builder = (props) => HotDeskBookingViewTablet(props: props);
    } else {
      builder = (props) => HotDeskBookingViewPhone(props: props);
    }

    final props = HotDeskBookingViewProps(
      state: state,
      onCreateBooking: viewModel.createBooking,
      onCancelBooking: viewModel.cancelBooking,
      onCheckIn: viewModel.checkIn,
      onComplete: viewModel.complete,
    );

    return builder(props);
  }

  String _failureMessage(HotDeskBookingFailure failure) {
    return failure.when(
      validation: (message) => message,
      conflict: () => 'This desk is already booked for that time.',
      notAuthenticated: () => 'You are not allowed to modify this booking.',
      network: () => 'Network error. Please try again.',
      unexpected: (message) => 'Unexpected error: $message',
    );
  }
}

typedef HotDeskBookingStatefulBuilder =
    Widget Function(HotDeskBookingViewProps props);

class HotDeskBookingViewProps {
  const HotDeskBookingViewProps({
    required this.state,
    required this.onCreateBooking,
    required this.onCancelBooking,
    required this.onCheckIn,
    required this.onComplete,
  });

  final HotDeskBookingState state;
  final Future<HotDeskBookingFailure?> Function(HotDeskBookingRequest request)
  onCreateBooking;
  final Future<HotDeskBookingFailure?> Function(
    String bookingId, {
    String? reason,
  })
  onCancelBooking;
  final Future<HotDeskBookingFailure?> Function(String bookingId) onCheckIn;
  final Future<HotDeskBookingFailure?> Function(String bookingId) onComplete;
}
