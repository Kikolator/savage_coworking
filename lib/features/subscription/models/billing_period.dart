import 'package:collection/collection.dart';

enum BillingPeriod {
  day,
  month,
}

extension BillingPeriodX on BillingPeriod {
  static BillingPeriod fromJson(String value) {
    return BillingPeriod.values.firstWhereOrNull(
          (period) => period.name == value,
        ) ??
        BillingPeriod.month;
  }

  String get label {
    switch (this) {
      case BillingPeriod.day:
        return 'Daily';
      case BillingPeriod.month:
        return 'Monthly';
    }
  }

  String toJson() {
    switch (this) {
      case BillingPeriod.day:
        return 'day';
      case BillingPeriod.month:
        return 'month';
    }
  }
}

