import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/converters/timestamp_converter.dart';
import 'hot_desk_booking_converters.dart';
import 'hot_desk_booking_source.dart';
import 'hot_desk_booking_status.dart';

part 'hot_desk_booking.freezed.dart';
part 'hot_desk_booking.g.dart';

@freezed
class HotDeskBooking with _$HotDeskBooking {
  const factory HotDeskBooking({
    required String id,
    required String userId,
    required String workspaceId,
    required String deskId,
    @TimestampConverter() required DateTime startAt,
    @TimestampConverter() required DateTime endAt,
    @HotDeskBookingStatusConverter() required HotDeskBookingStatus status,
    @HotDeskBookingSourceConverter() required HotDeskBookingSource source,
    String? purpose,
    @NullableTimestampConverter() DateTime? checkInAt,
    @NullableTimestampConverter() DateTime? checkOutAt,
    @NullableTimestampConverter() DateTime? cancelledAt,
    String? cancelledBy,
    String? cancellationReason,
    String? repeatSeriesId,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _HotDeskBooking;

  factory HotDeskBooking.fromJson(Map<String, dynamic> json) =>
      _$HotDeskBookingFromJson(json);
}
