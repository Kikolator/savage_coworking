import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/converters/timestamp_converter.dart';
import 'breakdown.dart';

part 'usage.freezed.dart';
part 'usage.g.dart';

@freezed
class Usage with _$Usage {
  const factory Usage({
    required String id,
    required String userId,
    String? subscriptionId,
    String? passBundleId,
    @TimestampConverter() required DateTime periodStart,
    @TimestampConverter() required DateTime periodEnd,
    required int deskMinutesUsed,
    required int meetingMinutesUsed,
    @BreakdownMapConverter() Map<String, Breakdown>? breakdown,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _Usage;

  factory Usage.fromJson(Map<String, dynamic> json) => _$UsageFromJson(json);
}

extension UsageX on Usage {
  double get deskHoursUsed => deskMinutesUsed / 60.0;
  double get meetingHoursUsed => meetingMinutesUsed / 60.0;
}

// Converter for Map<String, Breakdown>
class BreakdownMapConverter
    extends JsonConverter<Map<String, Breakdown>?, Map<String, dynamic>?> {
  const BreakdownMapConverter();

  @override
  Map<String, Breakdown>? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return json.map(
      (key, value) =>
          MapEntry(key, Breakdown.fromJson(value as Map<String, dynamic>)),
    );
  }

  @override
  Map<String, dynamic>? toJson(Map<String, Breakdown>? object) {
    if (object == null) return null;
    return object.map((key, value) => MapEntry(key, value.toJson()));
  }
}
