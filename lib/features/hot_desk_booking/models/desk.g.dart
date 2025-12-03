// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'desk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeskImpl _$$DeskImplFromJson(Map<String, dynamic> json) => _$DeskImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  workspaceId: json['workspaceId'] as String,
  isActive: json['isActive'] as bool,
  imageUrl: json['imageUrl'] as String?,
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
  updatedAt: const TimestampConverter().fromJson(
    json['updatedAt'] as Timestamp,
  ),
);

Map<String, dynamic> _$$DeskImplToJson(_$DeskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'workspaceId': instance.workspaceId,
      'isActive': instance.isActive,
      'imageUrl': instance.imageUrl,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
