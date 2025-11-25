import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts Firestore [Timestamp] values into UTC [DateTime] instances.
class TimestampConverter extends JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp json) => json.toDate().toUtc();

  @override
  Timestamp toJson(DateTime object) => Timestamp.fromDate(object.toUtc());
}

/// Converts nullable Firestore [Timestamp] to nullable UTC [DateTime].
class NullableTimestampConverter extends JsonConverter<DateTime?, Timestamp?> {
  const NullableTimestampConverter();

  @override
  DateTime? fromJson(Timestamp? json) => json?.toDate().toUtc();

  @override
  Timestamp? toJson(DateTime? object) =>
      object == null ? null : Timestamp.fromDate(object.toUtc());
}
