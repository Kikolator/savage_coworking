import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/converters/timestamp_converter.dart';
import 'access_type.dart';
import 'subscription_status.dart';
import 'subscription_converters.dart';

part 'membership_summary.freezed.dart';
part 'membership_summary.g.dart';

@freezed
class MembershipSummary with _$MembershipSummary {
  const factory MembershipSummary({
    String? activeSubscriptionId,
    String? planId,
    String? planName,
    @SubscriptionStatusConverter() SubscriptionStatus? status,
    @NullableTimestampConverter() DateTime? currentPeriodEnd,
    int? deskMinutesRemaining, // null = unlimited
    int? meetingMinutesRemaining, // null = unlimited
    int? remainingDayPassCredits,
    @AccessTypeConverter() AccessType? access,
  }) = _MembershipSummary;

  factory MembershipSummary.fromJson(Map<String, dynamic> json) =>
      _$MembershipSummaryFromJson(json);
}

extension MembershipSummaryX on MembershipSummary {
  bool get hasActiveSubscription => activeSubscriptionId != null;

  bool get hasUnlimitedDesk => deskMinutesRemaining == null;
  bool get hasUnlimitedMeeting => meetingMinutesRemaining == null;

  double? get deskHoursRemaining =>
      deskMinutesRemaining != null ? deskMinutesRemaining! / 60.0 : null;
  double? get meetingHoursRemaining =>
      meetingMinutesRemaining != null ? meetingMinutesRemaining! / 60.0 : null;
}

