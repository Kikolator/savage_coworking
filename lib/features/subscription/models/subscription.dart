import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/converters/timestamp_converter.dart';
import 'billing.dart';
import 'billing_period.dart';
import 'display.dart';
import 'overrides.dart';
import 'quota.dart';
import 'subscription_status.dart';
import 'subscription_converters.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

@freezed
class Subscription with _$Subscription {
  const factory Subscription({
    required String id,
    required String userId,
    required String planId,
    @SubscriptionStatusConverter() required SubscriptionStatus status,
    required Billing billing,
    required Quota effectiveQuota,
    Overrides? overrides,
    required Display display,
    required String stripeCustomerId,
    String? stripeSubscriptionId,
    @TimestampConverter() required DateTime currentPeriodStart,
    @TimestampConverter() required DateTime currentPeriodEnd,
    required bool cancelAtPeriodEnd,
    @NullableTimestampConverter() DateTime? cancelledAt,
    String? cancelledBy,
    String? assignedDeskId,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);
}

extension SubscriptionX on Subscription {
  String get billingCycle {
    return '${billing.intervalCount} ${billing.period?.label ?? 'month'}';
  }

  bool get isActive => status.isActive;

  // Helper getters for quota (for display purposes)
  // Note: Actual usage comes from Usage collection
  double? get deskHoursPerPeriod => effectiveQuota.deskHoursPerPeriod;
  double? get meetingHoursPerPeriod => effectiveQuota.meetingHoursPerPeriod;

  bool get hasUnlimitedDesk =>
      deskHoursPerPeriod == null || deskHoursPerPeriod == 0;
  bool get hasUnlimitedMeeting =>
      meetingHoursPerPeriod == null || meetingHoursPerPeriod == 0;
}
