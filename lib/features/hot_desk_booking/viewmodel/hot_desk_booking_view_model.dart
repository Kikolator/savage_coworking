import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/hot_desk_booking.dart';
import '../models/hot_desk_booking_failure.dart';
import '../models/hot_desk_booking_request.dart';
import '../service/hot_desk_booking_service.dart';

class HotDeskBookingState {
  final bool isLoading;
  final bool isSubmitting;
  final List<HotDeskBooking> bookings;
  final HotDeskBookingFailure? failure;

  const HotDeskBookingState({
    this.isLoading = true,
    this.isSubmitting = false,
    this.bookings = const [],
    this.failure,
  });

  HotDeskBookingState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<HotDeskBooking>? bookings,
    HotDeskBookingFailure? failure,
  }) {
    return HotDeskBookingState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      bookings: bookings ?? this.bookings,
      failure: failure,
    );
  }
}

class HotDeskBookingViewModel extends StateNotifier<HotDeskBookingState> {
  HotDeskBookingViewModel(this._service, this._userId)
    : super(const HotDeskBookingState()) {
    _subscription = _service
        .watchBookings(_userId)
        .listen(
          (bookings) {
            state = state.copyWith(
              isLoading: false,
              bookings: bookings,
              failure: null,
            );
          },
          onError: (error, stackTrace) {
            state = state.copyWith(
              isLoading: false,
              failure: HotDeskBookingFailure.unexpected(error.toString()),
            );
          },
        );
  }

  final HotDeskBookingService _service;
  final String _userId;
  StreamSubscription<List<HotDeskBooking>>? _subscription;

  Future<HotDeskBookingFailure?> createBooking(
    HotDeskBookingRequest request,
  ) async {
    state = state.copyWith(isSubmitting: true, failure: null);
    final (_, failure) = await _service.createBooking(
      userId: _userId,
      request: request,
    );

    state = state.copyWith(isSubmitting: false, failure: failure);
    return failure;
  }

  Future<HotDeskBookingFailure?> cancelBooking(
    String bookingId, {
    String? reason,
  }) async {
    state = state.copyWith(isSubmitting: true, failure: null);
    final failure = await _service.cancelBooking(
      bookingId: bookingId,
      userId: _userId,
      reason: reason,
    );
    state = state.copyWith(isSubmitting: false, failure: failure);
    return failure;
  }

  Future<HotDeskBookingFailure?> checkIn(String bookingId) async {
    state = state.copyWith(isSubmitting: true, failure: null);
    final failure = await _service.checkIn(
      bookingId: bookingId,
      userId: _userId,
    );
    state = state.copyWith(isSubmitting: false, failure: failure);
    return failure;
  }

  Future<HotDeskBookingFailure?> complete(String bookingId) async {
    state = state.copyWith(isSubmitting: true, failure: null);
    final failure = await _service.completeBooking(
      bookingId: bookingId,
      userId: _userId,
    );
    state = state.copyWith(isSubmitting: false, failure: failure);
    return failure;
  }

  void clearFailure() {
    if (state.failure != null) {
      state = state.copyWith(failure: null);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
