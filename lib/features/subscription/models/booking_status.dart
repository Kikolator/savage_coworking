import 'package:collection/collection.dart';

enum BookingStatus {
  booked,
  checkedIn,
  completed,
  cancelled,
}

extension BookingStatusX on BookingStatus {
  static BookingStatus fromJson(String value) {
    return BookingStatus.values.firstWhereOrNull(
          (status) => status.name == value,
        ) ??
        BookingStatus.booked;
  }

  String get label {
    switch (this) {
      case BookingStatus.booked:
        return 'Booked';
      case BookingStatus.checkedIn:
        return 'Checked In';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isActive => this == BookingStatus.booked || this == BookingStatus.checkedIn;

  String toJson() {
    switch (this) {
      case BookingStatus.booked:
        return 'booked';
      case BookingStatus.checkedIn:
        return 'checkedIn';
      case BookingStatus.completed:
        return 'completed';
      case BookingStatus.cancelled:
        return 'cancelled';
    }
  }
}

