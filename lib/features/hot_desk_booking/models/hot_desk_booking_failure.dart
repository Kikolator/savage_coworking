import 'package:freezed_annotation/freezed_annotation.dart';

part 'hot_desk_booking_failure.freezed.dart';

@freezed
class HotDeskBookingFailure with _$HotDeskBookingFailure {
  const factory HotDeskBookingFailure.validation(String message) =
      _ValidationFailure;

  const factory HotDeskBookingFailure.conflict() = _ConflictFailure;

  const factory HotDeskBookingFailure.notAuthenticated() =
      _NotAuthenticatedFailure;

  const factory HotDeskBookingFailure.network() = _NetworkFailure;

  const factory HotDeskBookingFailure.unexpected(String message) =
      _UnexpectedFailure;
}
