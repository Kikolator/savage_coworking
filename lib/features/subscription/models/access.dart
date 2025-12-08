import 'package:freezed_annotation/freezed_annotation.dart';

import 'access_type.dart';

part 'access.freezed.dart';
part 'access.g.dart';

@freezed
class Access with _$Access {
  const factory Access({
    @AccessTypeConverter() required AccessType type,
    @Default([]) List<int> allowedDaysOfWeek,
    String? startTime,
    String? endTime,
  }) = _Access;

  factory Access.fromJson(Map<String, dynamic> json) =>
      _$AccessFromJson(json);
}

class AccessTypeConverter extends JsonConverter<AccessType, String> {
  const AccessTypeConverter();

  @override
  AccessType fromJson(String json) => AccessTypeX.fromJson(json);

  @override
  String toJson(AccessType object) => object.toJson();
}

