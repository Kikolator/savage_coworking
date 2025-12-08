// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breakdown.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BreakdownImpl _$$BreakdownImplFromJson(Map<String, dynamic> json) =>
    _$BreakdownImpl(
      date: json['date'] as String,
      deskMinutes: (json['deskMinutes'] as num).toInt(),
      meetingMinutes: (json['meetingMinutes'] as num).toInt(),
      dayPassUsed: (json['dayPassUsed'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$BreakdownImplToJson(_$BreakdownImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'deskMinutes': instance.deskMinutes,
      'meetingMinutes': instance.meetingMinutes,
      'dayPassUsed': instance.dayPassUsed,
    };
