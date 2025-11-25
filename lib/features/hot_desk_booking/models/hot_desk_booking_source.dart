import 'package:collection/collection.dart';

enum HotDeskBookingSource { app, admin, system }

extension HotDeskBookingSourceX on HotDeskBookingSource {
  static HotDeskBookingSource fromJson(String value) {
    return HotDeskBookingSource.values.firstWhereOrNull(
          (source) => source.name == value,
        ) ??
        HotDeskBookingSource.app;
  }

  String toJson() => name;
}
