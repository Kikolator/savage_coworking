import '../models/hot_desk_booking.dart';
import '../models/hot_desk_booking_failure.dart';
import '../models/hot_desk_booking_request.dart';
import '../models/hot_desk_booking_source.dart';
import '../models/hot_desk_booking_status.dart';
import '../repository/hot_desk_booking_repository.dart';

class HotDeskBookingService {
  HotDeskBookingService(this._repository);

  final HotDeskBookingRepository _repository;

  Stream<List<HotDeskBooking>> watchBookings(String userId) {
    return _repository.watchUserBookings(userId);
  }

  Future<(HotDeskBooking?, HotDeskBookingFailure?)> createBooking({
    required String userId,
    required HotDeskBookingRequest request,
  }) async {
    final validationFailure = _validateRequest(request);
    if (validationFailure != null) {
      return (null, validationFailure);
    }

    final hasConflict = await _repository.hasConflictingBooking(
      deskId: request.deskId,
      startAt: request.startAt,
      endAt: request.endAt,
    );

    if (hasConflict) {
      return (null, const HotDeskBookingFailure.conflict());
    }

    final now = DateTime.now().toUtc();
    final booking = HotDeskBooking(
      id: '',
      userId: userId,
      workspaceId: request.workspaceId.trim(),
      deskId: request.deskId.trim(),
      startAt: request.startAt.toUtc(),
      endAt: request.endAt.toUtc(),
      status: HotDeskBookingStatus.pending,
      source: HotDeskBookingSource.app,
      purpose: request.purpose?.trim().isEmpty ?? true
          ? null
          : request.purpose?.trim(),
      createdAt: now,
      updatedAt: now,
    );

    try {
      final saved = await _repository.createBooking(booking);
      return (saved, null);
    } catch (e) {
      return (null, HotDeskBookingFailure.unexpected(e.toString()));
    }
  }

  Future<HotDeskBookingFailure?> cancelBooking({
    required String bookingId,
    required String userId,
    String? reason,
  }) async {
    final booking = await _repository.getBooking(bookingId);
    if (booking == null) {
      return const HotDeskBookingFailure.unexpected('Booking not found');
    }
    if (booking.userId != userId) {
      return const HotDeskBookingFailure.notAuthenticated();
    }
    if (!booking.status.isActive) {
      return const HotDeskBookingFailure.validation(
        'Only active bookings can be cancelled',
      );
    }

    try {
      await _repository.updateBookingFields(bookingId, {
        'status': HotDeskBookingStatus.cancelled.name,
        'cancelledAt': DateTime.now().toUtc(),
        'cancelledBy': userId,
        'cancellationReason': reason?.trim(),
      });
      return null;
    } catch (_) {
      return const HotDeskBookingFailure.network();
    }
  }

  Future<HotDeskBookingFailure?> checkIn({
    required String bookingId,
    required String userId,
  }) async {
    final booking = await _repository.getBooking(bookingId);
    if (booking == null) {
      return const HotDeskBookingFailure.unexpected('Booking not found');
    }
    if (booking.userId != userId) {
      return const HotDeskBookingFailure.notAuthenticated();
    }
    if (booking.status != HotDeskBookingStatus.confirmed &&
        booking.status != HotDeskBookingStatus.pending) {
      return const HotDeskBookingFailure.validation(
        'Only pending or confirmed bookings can be checked in',
      );
    }

    try {
      await _repository.updateBookingFields(bookingId, {
        'status': HotDeskBookingStatus.checkedIn.name,
        'checkInAt': DateTime.now().toUtc(),
      });
      return null;
    } catch (_) {
      return const HotDeskBookingFailure.network();
    }
  }

  Future<HotDeskBookingFailure?> completeBooking({
    required String bookingId,
    required String userId,
  }) async {
    final booking = await _repository.getBooking(bookingId);
    if (booking == null) {
      return const HotDeskBookingFailure.unexpected('Booking not found');
    }
    if (booking.userId != userId) {
      return const HotDeskBookingFailure.notAuthenticated();
    }
    if (booking.status != HotDeskBookingStatus.checkedIn) {
      return const HotDeskBookingFailure.validation(
        'Only checked-in bookings can be completed',
      );
    }

    try {
      await _repository.updateBookingFields(bookingId, {
        'status': HotDeskBookingStatus.completed.name,
        'checkOutAt': DateTime.now().toUtc(),
      });
      return null;
    } catch (_) {
      return const HotDeskBookingFailure.network();
    }
  }

  HotDeskBookingFailure? _validateRequest(HotDeskBookingRequest request) {
    if (request.workspaceId.trim().isEmpty) {
      return const HotDeskBookingFailure.validation('Workspace is required');
    }
    if (request.deskId.trim().isEmpty) {
      return const HotDeskBookingFailure.validation('Desk is required');
    }
    if (!request.startAt.isBefore(request.endAt)) {
      return const HotDeskBookingFailure.validation(
        'Start time must be before end time',
      );
    }
    if (request.endAt.difference(request.startAt).inMinutes < 30) {
      return const HotDeskBookingFailure.validation(
        'Bookings must be at least 30 minutes',
      );
    }
    if (request.startAt.isBefore(DateTime.now().toUtc())) {
      return const HotDeskBookingFailure.validation(
        'Start time must be in the future',
      );
    }
    return null;
  }
}
