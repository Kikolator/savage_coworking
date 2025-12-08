import 'package:collection/collection.dart';

enum AccessType {
  business,
  $24_7,
}

extension AccessTypeX on AccessType {
  static AccessType fromJson(String value) {
    return AccessType.values.firstWhereOrNull(
          (type) => type.name == value || type.toJson() == value,
        ) ??
        AccessType.business;
  }

  String get label {
    switch (this) {
      case AccessType.business:
        return 'Business Hours';
      case AccessType.$24_7:
        return '24/7';
    }
  }

  String toJson() {
    switch (this) {
      case AccessType.business:
        return 'business';
      case AccessType.$24_7:
        return '24_7';
    }
  }
}

