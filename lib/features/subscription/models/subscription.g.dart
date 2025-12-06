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
      planName: json['planName'] as String,
      status: const SubscriptionStatusConverter().fromJson(
        json['status'] as String,
      ),
      stripeSubscriptionId: json['stripeSubscriptionId'] as String?,
      stripeCustomerId: json['stripeCustomerId'] as String,
      stripePaymentIntentId: json['stripePaymentIntentId'] as String?,
      renewsAutomatically: json['renewsAutomatically'] as bool,
      currentPeriodStart: const TimestampConverter().fromJson(
        json['currentPeriodStart'] as Timestamp,
      ),
      currentPeriodEnd: const TimestampConverter().fromJson(
        json['currentPeriodEnd'] as Timestamp,
      ),
      cancelAtPeriodEnd: json['cancelAtPeriodEnd'] as bool,
      deskHours: (json['deskHours'] as num).toDouble(),
      meetingRoomHours: (json['meetingRoomHours'] as num).toDouble(),
      deskHoursUsed: (json['deskHoursUsed'] as num).toDouble(),
      meetingRoomHoursUsed: (json['meetingRoomHoursUsed'] as num).toDouble(),
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
      'planName': instance.planName,
      'status': const SubscriptionStatusConverter().toJson(instance.status),
      'stripeSubscriptionId': instance.stripeSubscriptionId,
      'stripeCustomerId': instance.stripeCustomerId,
      'stripePaymentIntentId': instance.stripePaymentIntentId,
      'renewsAutomatically': instance.renewsAutomatically,
      'currentPeriodStart': const TimestampConverter().toJson(
        instance.currentPeriodStart,
      ),
      'currentPeriodEnd': const TimestampConverter().toJson(
        instance.currentPeriodEnd,
      ),
      'cancelAtPeriodEnd': instance.cancelAtPeriodEnd,
      'deskHours': instance.deskHours,
      'meetingRoomHours': instance.meetingRoomHours,
      'deskHoursUsed': instance.deskHoursUsed,
      'meetingRoomHoursUsed': instance.meetingRoomHoursUsed,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
