import 'package:collection/collection.dart';

enum PassBundleStatus {
  active,
  consumed,
  expired,
  cancelled,
}

extension PassBundleStatusX on PassBundleStatus {
  static PassBundleStatus fromJson(String value) {
    return PassBundleStatus.values.firstWhereOrNull(
          (status) => status.name == value,
        ) ??
        PassBundleStatus.active;
  }

  String get label {
    switch (this) {
      case PassBundleStatus.active:
        return 'Active';
      case PassBundleStatus.consumed:
        return 'Consumed';
      case PassBundleStatus.expired:
        return 'Expired';
      case PassBundleStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isActive => this == PassBundleStatus.active;

  String toJson() {
    switch (this) {
      case PassBundleStatus.active:
        return 'active';
      case PassBundleStatus.consumed:
        return 'consumed';
      case PassBundleStatus.expired:
        return 'expired';
      case PassBundleStatus.cancelled:
        return 'cancelled';
    }
  }
}

