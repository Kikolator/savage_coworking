import 'package:collection/collection.dart';

enum SubscriptionStatus {
  active,
  cancelled,
  expired,
  trial,
  pastDue,
}

extension SubscriptionStatusX on SubscriptionStatus {
  static SubscriptionStatus fromJson(String value) {
    return SubscriptionStatus.values.firstWhereOrNull(
          (status) => status.name == value,
        ) ??
        SubscriptionStatus.trial;
  }

  String get label {
    switch (this) {
      case SubscriptionStatus.active:
        return 'Active';
      case SubscriptionStatus.cancelled:
        return 'Cancelled';
      case SubscriptionStatus.expired:
        return 'Expired';
      case SubscriptionStatus.trial:
        return 'Trial';
      case SubscriptionStatus.pastDue:
        return 'Past Due';
    }
  }

  bool get isActive => this == SubscriptionStatus.active;

  String toJson() {
    switch (this) {
      case SubscriptionStatus.active:
        return 'active';
      case SubscriptionStatus.cancelled:
        return 'cancelled';
      case SubscriptionStatus.expired:
        return 'expired';
      case SubscriptionStatus.trial:
        return 'trial';
      case SubscriptionStatus.pastDue:
        return 'past_due';
    }
  }
}

