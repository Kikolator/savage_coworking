// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccessImpl _$$AccessImplFromJson(Map<String, dynamic> json) => _$AccessImpl(
  type: const AccessTypeConverter().fromJson(json['type'] as String),
  allowedDaysOfWeek:
      (json['allowedDaysOfWeek'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  startTime: json['startTime'] as String?,
  endTime: json['endTime'] as String?,
);

Map<String, dynamic> _$$AccessImplToJson(_$AccessImpl instance) =>
    <String, dynamic>{
      'type': const AccessTypeConverter().toJson(instance.type),
      'allowedDaysOfWeek': instance.allowedDaysOfWeek,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };
