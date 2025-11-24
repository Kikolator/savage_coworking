import 'package:json_annotation/json_annotation.dart';

import 'hot_desk_booking_source.dart';
import 'hot_desk_booking_status.dart';

class HotDeskBookingStatusConverter
    extends JsonConverter<HotDeskBookingStatus, String> {
  const HotDeskBookingStatusConverter();

  @override
  HotDeskBookingStatus fromJson(String json) =>
      HotDeskBookingStatusX.fromJson(json);

  @override
  String toJson(HotDeskBookingStatus object) => object.name;
}

class HotDeskBookingSourceConverter
    extends JsonConverter<HotDeskBookingSource, String> {
  const HotDeskBookingSourceConverter();

  @override
  HotDeskBookingSource fromJson(String json) =>
      HotDeskBookingSourceX.fromJson(json);

  @override
  String toJson(HotDeskBookingSource object) => object.name;
}
