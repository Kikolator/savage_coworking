// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UsageImpl _$$UsageImplFromJson(Map<String, dynamic> json) => _$UsageImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  subscriptionId: json['subscriptionId'] as String?,
  passBundleId: json['passBundleId'] as String?,
  periodStart: const TimestampConverter().fromJson(
    json['periodStart'] as Timestamp,
  ),
  periodEnd: const TimestampConverter().fromJson(
    json['periodEnd'] as Timestamp,
  ),
  deskMinutesUsed: (json['deskMinutesUsed'] as num).toInt(),
  meetingMinutesUsed: (json['meetingMinutesUsed'] as num).toInt(),
  breakdown: const BreakdownMapConverter().fromJson(
    json['breakdown'] as Map<String, dynamic>?,
  ),
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
  updatedAt: const TimestampConverter().fromJson(
    json['updatedAt'] as Timestamp,
  ),
);

Map<String, dynamic> _$$UsageImplToJson(_$UsageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'subscriptionId': instance.subscriptionId,
      'passBundleId': instance.passBundleId,
      'periodStart': const TimestampConverter().toJson(instance.periodStart),
      'periodEnd': const TimestampConverter().toJson(instance.periodEnd),
      'deskMinutesUsed': instance.deskMinutesUsed,
      'meetingMinutesUsed': instance.meetingMinutesUsed,
      'breakdown': const BreakdownMapConverter().toJson(instance.breakdown),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
