import 'package:collection/collection.dart';

enum SeatType {
  hot,
  fixed,
}

extension SeatTypeX on SeatType {
  static SeatType fromJson(String value) {
    return SeatType.values.firstWhereOrNull(
          (type) => type.name == value,
        ) ??
        SeatType.hot;
  }

  String get label {
    switch (this) {
      case SeatType.hot:
        return 'Hot Desk';
      case SeatType.fixed:
        return 'Fixed Desk';
    }
  }

  String toJson() {
    switch (this) {
      case SeatType.hot:
        return 'hot';
      case SeatType.fixed:
        return 'fixed';
    }
  }
}

