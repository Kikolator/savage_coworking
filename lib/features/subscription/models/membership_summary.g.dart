// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MembershipSummaryImpl _$$MembershipSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$MembershipSummaryImpl(
  activeSubscriptionId: json['activeSubscriptionId'] as String?,
  planId: json['planId'] as String?,
  planName: json['planName'] as String?,
  status: _$JsonConverterFromJson<String, SubscriptionStatus>(
    json['status'],
    const SubscriptionStatusConverter().fromJson,
  ),
  currentPeriodEnd: const NullableTimestampConverter().fromJson(
    json['currentPeriodEnd'] as Timestamp?,
  ),
  deskMinutesRemaining: (json['deskMinutesRemaining'] as num?)?.toInt(),
  meetingMinutesRemaining: (json['meetingMinutesRemaining'] as num?)?.toInt(),
  remainingDayPassCredits: (json['remainingDayPassCredits'] as num?)?.toInt(),
  access: _$JsonConverterFromJson<String, AccessType>(
    json['access'],
    const AccessTypeConverter().fromJson,
  ),
);

Map<String, dynamic> _$$MembershipSummaryImplToJson(
  _$MembershipSummaryImpl instance,
) => <String, dynamic>{
  'activeSubscriptionId': instance.activeSubscriptionId,
  'planId': instance.planId,
  'planName': instance.planName,
  'status': _$JsonConverterToJson<String, SubscriptionStatus>(
    instance.status,
    const SubscriptionStatusConverter().toJson,
  ),
  'currentPeriodEnd': const NullableTimestampConverter().toJson(
    instance.currentPeriodEnd,
  ),
  'deskMinutesRemaining': instance.deskMinutesRemaining,
  'meetingMinutesRemaining': instance.meetingMinutesRemaining,
  'remainingDayPassCredits': instance.remainingDayPassCredits,
  'access': _$JsonConverterToJson<String, AccessType>(
    instance.access,
    const AccessTypeConverter().toJson,
  ),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
