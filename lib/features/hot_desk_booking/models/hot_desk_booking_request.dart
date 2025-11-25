import 'package:freezed_annotation/freezed_annotation.dart';

part 'hot_desk_booking_request.freezed.dart';

@freezed
class HotDeskBookingRequest with _$HotDeskBookingRequest {
  const factory HotDeskBookingRequest({
    required String workspaceId,
    required String deskId,
    required DateTime startAt,
    required DateTime endAt,
    String? purpose,
  }) = _HotDeskBookingRequest;
}
