// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscriptionPlanImpl _$$SubscriptionPlanImplFromJson(
  Map<String, dynamic> json,
) => _$SubscriptionPlanImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  category: const PlanCategoryConverter().fromJson(json['category'] as String),
  billing: Billing.fromJson(json['billing'] as Map<String, dynamic>),
  quota: Quota.fromJson(json['quota'] as Map<String, dynamic>),
  pricing: Pricing.fromJson(json['pricing'] as Map<String, dynamic>),
  external: json['external'] == null
      ? null
      : External.fromJson(json['external'] as Map<String, dynamic>),
  features: (json['features'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  isActive: json['isActive'] as bool,
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
  updatedAt: const TimestampConverter().fromJson(
    json['updatedAt'] as Timestamp,
  ),
);

Map<String, dynamic> _$$SubscriptionPlanImplToJson(
  _$SubscriptionPlanImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': const PlanCategoryConverter().toJson(instance.category),
  'billing': instance.billing,
  'quota': instance.quota,
  'pricing': instance.pricing,
  'external': instance.external,
  'features': instance.features,
  'isActive': instance.isActive,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};
