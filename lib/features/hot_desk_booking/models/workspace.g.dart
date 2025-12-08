// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkspaceImpl _$$WorkspaceImplFromJson(Map<String, dynamic> json) =>
    _$WorkspaceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      country: json['country'] as String,
      companyLogoUrl: json['companyLogoUrl'] as String?,
      isActive: json['isActive'] as bool,
      businessHoursStart: json['businessHoursStart'] as String?,
      businessHoursEnd: json['businessHoursEnd'] as String?,
      businessDaysOfWeek:
          (json['businessDaysOfWeek'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
      updatedAt: const TimestampConverter().fromJson(
        json['updatedAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$$WorkspaceImplToJson(_$WorkspaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'country': instance.country,
      'companyLogoUrl': instance.companyLogoUrl,
      'isActive': instance.isActive,
      'businessHoursStart': instance.businessHoursStart,
      'businessHoursEnd': instance.businessHoursEnd,
      'businessDaysOfWeek': instance.businessDaysOfWeek,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
