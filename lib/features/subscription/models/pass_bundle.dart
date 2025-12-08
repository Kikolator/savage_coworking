import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/converters/timestamp_converter.dart';
import 'access.dart';
import 'pass_bundle_status.dart';
import 'subscription_converters.dart';

part 'pass_bundle.freezed.dart';
part 'pass_bundle.g.dart';

@freezed
class PassBundle with _$PassBundle {
  const factory PassBundle({
    required String id,
    required String userId,
    required String planId,
    @PassBundleStatusConverter() required PassBundleStatus status,
    required int totalCredits,
    required int remainingCredits,
    @TimestampConverter() required DateTime validFrom,
    @NullableTimestampConverter() DateTime? validUntil,
    required Access access,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _PassBundle;

  factory PassBundle.fromJson(Map<String, dynamic> json) =>
      _$PassBundleFromJson(json);
}

extension PassBundleX on PassBundle {
  bool get isActive => status.isActive;

  bool get isExpired {
    if (validUntil == null) return false;
    return DateTime.now().isAfter(validUntil!);
  }

  bool get isConsumed => remainingCredits == 0;
}

