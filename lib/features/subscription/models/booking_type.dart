import 'package:collection/collection.dart';

enum BookingType {
  desk,
  meetingRoom,
}

extension BookingTypeX on BookingType {
  static BookingType fromJson(String value) {
    return BookingType.values.firstWhereOrNull(
          (type) => type.name == value,
        ) ??
        BookingType.desk;
  }

  String get label {
    switch (this) {
      case BookingType.desk:
        return 'Desk';
      case BookingType.meetingRoom:
        return 'Meeting Room';
    }
  }

  String toJson() {
    switch (this) {
      case BookingType.desk:
        return 'desk';
      case BookingType.meetingRoom:
        return 'meetingRoom';
    }
  }
}

