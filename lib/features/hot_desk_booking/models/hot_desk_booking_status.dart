import 'package:collection/collection.dart';

enum HotDeskBookingStatus {
  pending,
  confirmed,
  checkedIn,
  completed,
  cancelled,
  noShow,
}

extension HotDeskBookingStatusX on HotDeskBookingStatus {
  static HotDeskBookingStatus fromJson(String value) {
    return HotDeskBookingStatus.values.firstWhereOrNull(
          (status) => status.name == value,
        ) ??
        HotDeskBookingStatus.pending;
  }

  String get label {
    switch (this) {
      case HotDeskBookingStatus.pending:
        return 'Pending';
      case HotDeskBookingStatus.confirmed:
        return 'Confirmed';
      case HotDeskBookingStatus.checkedIn:
        return 'Checked-in';
      case HotDeskBookingStatus.completed:
        return 'Completed';
      case HotDeskBookingStatus.cancelled:
        return 'Cancelled';
      case HotDeskBookingStatus.noShow:
        return 'No-show';
    }
  }

  bool get isActive =>
      this == HotDeskBookingStatus.pending ||
      this == HotDeskBookingStatus.confirmed ||
      this == HotDeskBookingStatus.checkedIn;

  String toJson() => name;
}
