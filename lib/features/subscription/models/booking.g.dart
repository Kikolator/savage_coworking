// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingImpl _$$BookingImplFromJson(Map<String, dynamic> json) =>
    _$BookingImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: const BookingTypeConverter().fromJson(json['type'] as String),
      date: json['date'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      source: const BookingSourceConverter().fromJson(
        json['source'] as Map<String, dynamic>,
      ),
      status: const BookingStatusConverter().fromJson(json['status'] as String),
      workspaceId: json['workspaceId'] as String,
      deskId: json['deskId'] as String?,
      roomId: json['roomId'] as String?,
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
      updatedAt: const TimestampConverter().fromJson(
        json['updatedAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': const BookingTypeConverter().toJson(instance.type),
      'date': instance.date,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'source': const BookingSourceConverter().toJson(instance.source),
      'status': const BookingStatusConverter().toJson(instance.status),
      'workspaceId': instance.workspaceId,
      'deskId': instance.deskId,
      'roomId': instance.roomId,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
