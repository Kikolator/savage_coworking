import '../../subscription/models/subscription.dart';
import '../../subscription/models/subscription_plan.dart';
import '../../subscription/models/subscription_status.dart';
import '../../subscription/models/plan_category.dart';
import '../../subscription/models/billing_type.dart';
import '../../subscription/models/billing_period.dart';
import '../../subscription/models/access_type.dart';
import '../../subscription/models/seat_type.dart';

/// Subscription list item with user information for admin display
class AdminSubscriptionListItem {
  const AdminSubscriptionListItem({
    required this.subscription,
    this.userEmail,
    this.userDisplayName,
  });

  final Subscription subscription;
  final String? userEmail;
  final String? userDisplayName;

  String get displayName {
    return userDisplayName ?? userEmail ?? 'Unknown User';
  }
}

/// Form data for creating or editing subscription plans
class AdminPlanFormData {
  const AdminPlanFormData({
    this.id,
    this.name,
    this.category,
    this.billingType,
    this.billingPeriod,
    this.intervalCount = 1,
    this.price,
    this.currency = 'usd',
    this.billingDescription,
    this.deskHours,
    this.meetingRoomHours,
    this.dayPassCredits,
    this.accessType,
    this.startTime,
    this.endTime,
    this.seatType,
    this.features = const [],
    this.isActive = true,
    this.stripePriceId,
    this.stripeProductId,
  });

  final String? id;
  final String? name;
  final PlanCategory? category;
  final BillingType? billingType;
  final BillingPeriod? billingPeriod;
  final int intervalCount;
  final int? price; // Price in cents
  final String currency;
  final String? billingDescription;
  final double? deskHours;
  final double? meetingRoomHours;
  final int? dayPassCredits;
  final AccessType? accessType;
  final String? startTime; // HH:mm format
  final String? endTime; // HH:mm format
  final SeatType? seatType;
  final List<String> features;
  final bool isActive;
  final String? stripePriceId;
  final String? stripeProductId;

  AdminPlanFormData copyWith({
    String? id,
    String? name,
    PlanCategory? category,
    BillingType? billingType,
    BillingPeriod? billingPeriod,
    int? intervalCount,
    int? price,
    String? currency,
    String? billingDescription,
    double? deskHours,
    double? meetingRoomHours,
    int? dayPassCredits,
    AccessType? accessType,
    String? startTime,
    String? endTime,
    SeatType? seatType,
    List<String>? features,
    bool? isActive,
    String? stripePriceId,
    String? stripeProductId,
  }) {
    return AdminPlanFormData(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      billingType: billingType ?? this.billingType,
      billingPeriod: billingPeriod ?? this.billingPeriod,
      intervalCount: intervalCount ?? this.intervalCount,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      billingDescription: billingDescription ?? this.billingDescription,
      deskHours: deskHours ?? this.deskHours,
      meetingRoomHours: meetingRoomHours ?? this.meetingRoomHours,
      dayPassCredits: dayPassCredits ?? this.dayPassCredits,
      accessType: accessType ?? this.accessType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      seatType: seatType ?? this.seatType,
      features: features ?? this.features,
      isActive: isActive ?? this.isActive,
      stripePriceId: stripePriceId ?? this.stripePriceId,
      stripeProductId: stripeProductId ?? this.stripeProductId,
    );
  }

  /// Create form data from existing plan
  factory AdminPlanFormData.fromPlan(SubscriptionPlan plan) {
    return AdminPlanFormData(
      id: plan.id,
      name: plan.name,
      category: plan.category,
      billingType: plan.billing.type,
      billingPeriod: plan.billing.period,
      intervalCount: plan.billing.intervalCount,
      price: plan.pricing.amount,
      currency: plan.pricing.currency,
      billingDescription: plan.pricing.billingDescription,
      deskHours: plan.quota.deskHoursPerPeriod,
      meetingRoomHours: plan.quota.meetingHoursPerPeriod,
      dayPassCredits: plan.quota.dayPassCredits,
      accessType: plan.quota.access.type,
      startTime: plan.quota.access.startTime,
      endTime: plan.quota.access.endTime,
      seatType: plan.quota.seatType,
      features: List<String>.from(plan.features),
      isActive: plan.isActive,
      stripePriceId: plan.external?.stripePriceId,
      stripeProductId: plan.external?.stripeProductId,
    );
  }
}

/// Filter options for subscription list
class AdminSubscriptionFilters {
  const AdminSubscriptionFilters({
    this.status,
    this.planId,
    this.searchQuery,
    this.startDate,
    this.endDate,
  });

  final SubscriptionStatus? status;
  final String? planId;
  final String? searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;

  AdminSubscriptionFilters copyWith({
    SubscriptionStatus? status,
    String? planId,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    bool clearStatus = false,
    bool clearPlanId = false,
    bool clearSearchQuery = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    return AdminSubscriptionFilters(
      status: clearStatus ? null : (status ?? this.status),
      planId: clearPlanId ? null : (planId ?? this.planId),
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
    );
  }

  bool get hasFilters {
    return status != null ||
        planId != null ||
        (searchQuery != null && searchQuery!.isNotEmpty) ||
        startDate != null ||
        endDate != null;
  }
}
