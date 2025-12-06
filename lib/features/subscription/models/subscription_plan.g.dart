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
  price: (json['price'] as num).toInt(),
  currency: json['currency'] as String,
  interval: const SubscriptionIntervalConverter().fromJson(
    json['interval'] as String,
  ),
  deskHours: (json['deskHours'] as num).toDouble(),
  meetingRoomHours: (json['meetingRoomHours'] as num).toDouble(),
  features: (json['features'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  isActive: json['isActive'] as bool,
  stripePriceId: json['stripePriceId'] as String?,
  stripeProductId: json['stripeProductId'] as String?,
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
  'price': instance.price,
  'currency': instance.currency,
  'interval': const SubscriptionIntervalConverter().toJson(instance.interval),
  'deskHours': instance.deskHours,
  'meetingRoomHours': instance.meetingRoomHours,
  'features': instance.features,
  'isActive': instance.isActive,
  'stripePriceId': instance.stripePriceId,
  'stripeProductId': instance.stripeProductId,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};
