import 'package:collection/collection.dart';

enum BillingType {
  oneOff,
  recurring,
}

extension BillingTypeX on BillingType {
  static BillingType fromJson(String value) {
    return BillingType.values.firstWhereOrNull(
          (type) => type.name == value,
        ) ??
        BillingType.recurring;
  }

  String get label {
    switch (this) {
      case BillingType.oneOff:
        return 'One-time';
      case BillingType.recurring:
        return 'Recurring';
    }
  }

  String toJson() {
    switch (this) {
      case BillingType.oneOff:
        return 'oneOff';
      case BillingType.recurring:
        return 'recurring';
    }
  }
}

