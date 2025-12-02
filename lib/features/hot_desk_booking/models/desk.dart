import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/converters/timestamp_converter.dart';

part 'desk.freezed.dart';
part 'desk.g.dart';

@freezed
class Desk with _$Desk {
  const factory Desk({
    required String id,
    required String name,
    required String workspaceId,
    required bool isActive,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _Desk;

  factory Desk.fromJson(Map<String, dynamic> json) => _$DeskFromJson(json);
}
