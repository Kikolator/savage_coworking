// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BillingImpl _$$BillingImplFromJson(Map<String, dynamic> json) =>
    _$BillingImpl(
      type: const BillingTypeConverter().fromJson(json['type'] as String),
      period: const BillingPeriodConverter().fromJson(
        json['period'] as String?,
      ),
      intervalCount: (json['intervalCount'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$BillingImplToJson(_$BillingImpl instance) =>
    <String, dynamic>{
      'type': const BillingTypeConverter().toJson(instance.type),
      'period': const BillingPeriodConverter().toJson(instance.period),
      'intervalCount': instance.intervalCount,
    };
