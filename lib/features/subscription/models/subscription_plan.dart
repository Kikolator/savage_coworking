import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/converters/timestamp_converter.dart';
import 'subscription_converters.dart';
import 'subscription_interval.dart';

part 'subscription_plan.freezed.dart';
part 'subscription_plan.g.dart';

@freezed
class SubscriptionPlan with _$SubscriptionPlan {
  const factory SubscriptionPlan({
    required String id,
    required String name,
    required int price, // Price in cents
    required String currency,
    @SubscriptionIntervalConverter() required SubscriptionInterval interval,
    required double deskHours, // 0 = unlimited
    required double meetingRoomHours, // 0 = unlimited
    required List<String> features,
    required bool isActive,
    String? stripePriceId,
    String? stripeProductId,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _SubscriptionPlan;

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPlanFromJson(json);
}

extension SubscriptionPlanX on SubscriptionPlan {
  String get formattedPrice {
    final amount = price / 100;
    return '\$${amount.toStringAsFixed(2)}';
  }

  String get billingCycle {
    return interval.label;
  }

  String get deskHoursLabel {
    if (deskHours == 0) return 'Unlimited';
    return '${deskHours.toStringAsFixed(0)} hours';
  }

  String get meetingRoomHoursLabel {
    if (meetingRoomHours == 0) return 'Unlimited';
    return '${meetingRoomHours.toStringAsFixed(0)} hours';
  }
}


