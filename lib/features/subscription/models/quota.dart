import 'package:freezed_annotation/freezed_annotation.dart';

import 'access.dart';
import 'seat_type.dart';

part 'quota.freezed.dart';
part 'quota.g.dart';

@freezed
class Quota with _$Quota {
  const factory Quota({
    int? dayPassCredits,
    double? deskHoursPerPeriod,
    double? meetingHoursPerPeriod,
    required Access access,
    @SeatTypeConverter() SeatType? seatType,
  }) = _Quota;

  factory Quota.fromJson(Map<String, dynamic> json) => _$QuotaFromJson(json);
}

class SeatTypeConverter extends JsonConverter<SeatType?, String?> {
  const SeatTypeConverter();

  @override
  SeatType? fromJson(String? json) =>
      json != null ? SeatTypeX.fromJson(json) : null;

  @override
  String? toJson(SeatType? object) => object?.toJson();
}

