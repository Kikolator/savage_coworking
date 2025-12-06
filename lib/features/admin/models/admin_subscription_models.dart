import '../../subscription/models/subscription.dart';
import '../../subscription/models/subscription_plan.dart';
import '../../subscription/models/subscription_status.dart';
import '../../subscription/models/subscription_interval.dart';

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
    this.price,
    this.currency = 'usd',
    this.interval,
    this.deskHours,
    this.meetingRoomHours,
    this.features = const [],
    this.isActive = true,
    this.stripePriceId,
    this.stripeProductId,
  });

  final String? id;
  final String? name;
  final int? price; // Price in cents
  final String currency;
  final SubscriptionInterval? interval;
  final double? deskHours;
  final double? meetingRoomHours;
  final List<String> features;
  final bool isActive;
  final String? stripePriceId;
  final String? stripeProductId;

  AdminPlanFormData copyWith({
    String? id,
    String? name,
    int? price,
    String? currency,
    SubscriptionInterval? interval,
    double? deskHours,
    double? meetingRoomHours,
    List<String>? features,
    bool? isActive,
    String? stripePriceId,
    String? stripeProductId,
  }) {
    return AdminPlanFormData(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      interval: interval ?? this.interval,
      deskHours: deskHours ?? this.deskHours,
      meetingRoomHours: meetingRoomHours ?? this.meetingRoomHours,
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
      price: plan.price,
      currency: plan.currency,
      interval: plan.interval,
      deskHours: plan.deskHours,
      meetingRoomHours: plan.meetingRoomHours,
      features: List<String>.from(plan.features),
      isActive: plan.isActive,
      stripePriceId: plan.stripePriceId,
      stripeProductId: plan.stripeProductId,
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

