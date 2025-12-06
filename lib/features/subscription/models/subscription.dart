import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/converters/timestamp_converter.dart';
import 'subscription_converters.dart';
import 'subscription_status.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

@freezed
class Subscription with _$Subscription {
  const factory Subscription({
    required String id,
    required String userId,
    required String planId,
    required String planName,
    @SubscriptionStatusConverter() required SubscriptionStatus status,
    String? stripeSubscriptionId,
    required String stripeCustomerId,
    String? stripePaymentIntentId,
    required bool renewsAutomatically,
    @TimestampConverter() required DateTime currentPeriodStart,
    @TimestampConverter() required DateTime currentPeriodEnd,
    required bool cancelAtPeriodEnd,
    required double deskHours,
    required double meetingRoomHours,
    required double deskHoursUsed,
    required double meetingRoomHoursUsed,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);
}

extension SubscriptionX on Subscription {
  double get deskHoursLeft {
    if (deskHours == 0) return double.infinity;
    return (deskHours - deskHoursUsed).clamp(0, double.infinity);
  }

  double get meetingRoomHoursLeft {
    if (meetingRoomHours == 0) return double.infinity;
    return (meetingRoomHours - meetingRoomHoursUsed)
        .clamp(0, double.infinity);
  }

  String get billingCycle {
    return renewsAutomatically ? 'Monthly' : 'One-time';
  }

  bool get isActive => status.isActive;
}


