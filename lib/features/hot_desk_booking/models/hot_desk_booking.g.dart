// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hot_desk_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HotDeskBookingImpl _$$HotDeskBookingImplFromJson(Map<String, dynamic> json) =>
    _$HotDeskBookingImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      workspaceId: json['workspaceId'] as String,
      deskId: json['deskId'] as String,
      startAt: const TimestampConverter().fromJson(
        json['startAt'] as Timestamp,
      ),
      endAt: const TimestampConverter().fromJson(json['endAt'] as Timestamp),
      status: const HotDeskBookingStatusConverter().fromJson(
        json['status'] as String,
      ),
      source: const HotDeskBookingSourceConverter().fromJson(
        json['source'] as String,
      ),
      purpose: json['purpose'] as String?,
      checkInAt: const NullableTimestampConverter().fromJson(
        json['checkInAt'] as Timestamp?,
      ),
      checkOutAt: const NullableTimestampConverter().fromJson(
        json['checkOutAt'] as Timestamp?,
      ),
      cancelledAt: const NullableTimestampConverter().fromJson(
        json['cancelledAt'] as Timestamp?,
      ),
      cancelledBy: json['cancelledBy'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
      repeatSeriesId: json['repeatSeriesId'] as String?,
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
      updatedAt: const TimestampConverter().fromJson(
        json['updatedAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$$HotDeskBookingImplToJson(
  _$HotDeskBookingImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'workspaceId': instance.workspaceId,
  'deskId': instance.deskId,
  'startAt': const TimestampConverter().toJson(instance.startAt),
  'endAt': const TimestampConverter().toJson(instance.endAt),
  'status': const HotDeskBookingStatusConverter().toJson(instance.status),
  'source': const HotDeskBookingSourceConverter().toJson(instance.source),
  'purpose': instance.purpose,
  'checkInAt': const NullableTimestampConverter().toJson(instance.checkInAt),
  'checkOutAt': const NullableTimestampConverter().toJson(instance.checkOutAt),
  'cancelledAt': const NullableTimestampConverter().toJson(
    instance.cancelledAt,
  ),
  'cancelledBy': instance.cancelledBy,
  'cancellationReason': instance.cancellationReason,
  'repeatSeriesId': instance.repeatSeriesId,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};
