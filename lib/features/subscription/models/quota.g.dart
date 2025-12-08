// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quota.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuotaImpl _$$QuotaImplFromJson(Map<String, dynamic> json) => _$QuotaImpl(
  dayPassCredits: (json['dayPassCredits'] as num?)?.toInt(),
  deskHoursPerPeriod: (json['deskHoursPerPeriod'] as num?)?.toDouble(),
  meetingHoursPerPeriod: (json['meetingHoursPerPeriod'] as num?)?.toDouble(),
  access: Access.fromJson(json['access'] as Map<String, dynamic>),
  seatType: const SeatTypeConverter().fromJson(json['seatType'] as String?),
);

Map<String, dynamic> _$$QuotaImplToJson(_$QuotaImpl instance) =>
    <String, dynamic>{
      'dayPassCredits': instance.dayPassCredits,
      'deskHoursPerPeriod': instance.deskHoursPerPeriod,
      'meetingHoursPerPeriod': instance.meetingHoursPerPeriod,
      'access': instance.access,
      'seatType': const SeatTypeConverter().toJson(instance.seatType),
    };
