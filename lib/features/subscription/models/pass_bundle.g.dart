// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pass_bundle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PassBundleImpl _$$PassBundleImplFromJson(Map<String, dynamic> json) =>
    _$PassBundleImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      planId: json['planId'] as String,
      status: const PassBundleStatusConverter().fromJson(
        json['status'] as String,
      ),
      totalCredits: (json['totalCredits'] as num).toInt(),
      remainingCredits: (json['remainingCredits'] as num).toInt(),
      validFrom: const TimestampConverter().fromJson(
        json['validFrom'] as Timestamp,
      ),
      validUntil: const NullableTimestampConverter().fromJson(
        json['validUntil'] as Timestamp?,
      ),
      access: Access.fromJson(json['access'] as Map<String, dynamic>),
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
      updatedAt: const TimestampConverter().fromJson(
        json['updatedAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$$PassBundleImplToJson(
  _$PassBundleImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'planId': instance.planId,
  'status': const PassBundleStatusConverter().toJson(instance.status),
  'totalCredits': instance.totalCredits,
  'remainingCredits': instance.remainingCredits,
  'validFrom': const TimestampConverter().toJson(instance.validFrom),
  'validUntil': const NullableTimestampConverter().toJson(instance.validUntil),
  'access': instance.access,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};
