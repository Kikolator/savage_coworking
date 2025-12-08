import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/converters/timestamp_converter.dart';
import 'booking_source.dart';
import 'booking_status.dart';
import 'booking_type.dart';
import 'subscription_converters.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id,
    required String userId,
    @BookingTypeConverter() required BookingType type,
    required String date, // YYYY-MM-DD format
    required String startTime, // HH:mm format
    required String endTime, // HH:mm format
    @BookingSourceConverter() required BookingSource source,
    @BookingStatusConverter() required BookingStatus status,
    required String workspaceId,
    String? deskId,
    String? roomId,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}

extension BookingX on Booking {
  bool get isActive => status.isActive;

  DateTime get startDateTime {
    final dateParts = date.split('-');
    final timeParts = startTime.split(':');
    return DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
  }

  DateTime get endDateTime {
    final dateParts = date.split('-');
    final timeParts = endTime.split(':');
    return DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
  }

  Duration get duration => endDateTime.difference(startDateTime);
}

