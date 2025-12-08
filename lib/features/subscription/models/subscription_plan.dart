import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/converters/timestamp_converter.dart';
import 'billing.dart';
import 'billing_period.dart';
import 'billing_type.dart';
import 'external.dart';
import 'plan_category.dart';
import 'pricing.dart';
import 'quota.dart';
import 'subscription_converters.dart';

part 'subscription_plan.freezed.dart';
part 'subscription_plan.g.dart';

@freezed
class SubscriptionPlan with _$SubscriptionPlan {
  const factory SubscriptionPlan({
    required String id,
    required String name,
    @PlanCategoryConverter() required PlanCategory category,
    required Billing billing,
    required Quota quota,
    required Pricing pricing,
    External? external,
    required List<String> features,
    required bool isActive,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _SubscriptionPlan;

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPlanFromJson(json);
}

extension SubscriptionPlanX on SubscriptionPlan {
  String get formattedPrice {
    final amount = pricing.amount / 100;
    return '\$${amount.toStringAsFixed(2)}';
  }

  String get billingCycle {
    if (billing.type == BillingType.oneOff) {
      return 'One-time';
    }
    return '${billing.intervalCount} ${billing.period?.label ?? 'month'}';
  }

  String get deskHoursLabel {
    final hours = quota.deskHoursPerPeriod;
    if (hours == null || hours == 0) return 'Unlimited';
    return '${hours.toStringAsFixed(0)} hours';
  }

  String get meetingHoursLabel {
    final hours = quota.meetingHoursPerPeriod;
    if (hours == null || hours == 0) return 'Unlimited';
    return '${hours.toStringAsFixed(0)} hours';
  }
}
