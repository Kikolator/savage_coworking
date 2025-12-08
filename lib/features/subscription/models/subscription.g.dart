// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscriptionImpl _$$SubscriptionImplFromJson(Map<String, dynamic> json) =>
    _$SubscriptionImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      planId: json['planId'] as String,
      status: const SubscriptionStatusConverter().fromJson(
        json['status'] as String,
      ),
      billing: Billing.fromJson(json['billing'] as Map<String, dynamic>),
      effectiveQuota: Quota.fromJson(
        json['effectiveQuota'] as Map<String, dynamic>,
      ),
      overrides: json['overrides'] == null
          ? null
          : Overrides.fromJson(json['overrides'] as Map<String, dynamic>),
      display: Display.fromJson(json['display'] as Map<String, dynamic>),
      stripeCustomerId: json['stripeCustomerId'] as String,
      stripeSubscriptionId: json['stripeSubscriptionId'] as String?,
      currentPeriodStart: const TimestampConverter().fromJson(
        json['currentPeriodStart'] as Timestamp,
      ),
      currentPeriodEnd: const TimestampConverter().fromJson(
        json['currentPeriodEnd'] as Timestamp,
      ),
      cancelAtPeriodEnd: json['cancelAtPeriodEnd'] as bool,
      cancelledAt: const NullableTimestampConverter().fromJson(
        json['cancelledAt'] as Timestamp?,
      ),
      cancelledBy: json['cancelledBy'] as String?,
      assignedDeskId: json['assignedDeskId'] as String?,
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
      updatedAt: const TimestampConverter().fromJson(
        json['updatedAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$$SubscriptionImplToJson(_$SubscriptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'planId': instance.planId,
      'status': const SubscriptionStatusConverter().toJson(instance.status),
      'billing': instance.billing,
      'effectiveQuota': instance.effectiveQuota,
      'overrides': instance.overrides,
      'display': instance.display,
      'stripeCustomerId': instance.stripeCustomerId,
      'stripeSubscriptionId': instance.stripeSubscriptionId,
      'currentPeriodStart': const TimestampConverter().toJson(
        instance.currentPeriodStart,
      ),
      'currentPeriodEnd': const TimestampConverter().toJson(
        instance.currentPeriodEnd,
      ),
      'cancelAtPeriodEnd': instance.cancelAtPeriodEnd,
      'cancelledAt': const NullableTimestampConverter().toJson(
        instance.cancelledAt,
      ),
      'cancelledBy': instance.cancelledBy,
      'assignedDeskId': instance.assignedDeskId,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
