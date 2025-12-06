import 'package:collection/collection.dart';

enum SubscriptionInterval {
  month,
  oneOff,
}

extension SubscriptionIntervalX on SubscriptionInterval {
  static SubscriptionInterval fromJson(String value) {
    return SubscriptionInterval.values.firstWhereOrNull(
          (interval) => interval.name == value,
        ) ??
        SubscriptionInterval.month;
  }

  String get label {
    switch (this) {
      case SubscriptionInterval.month:
        return 'Monthly';
      case SubscriptionInterval.oneOff:
        return 'One-time';
    }
  }

  String toJson() {
    switch (this) {
      case SubscriptionInterval.month:
        return 'month';
      case SubscriptionInterval.oneOff:
        return 'one_off';
    }
  }
}

