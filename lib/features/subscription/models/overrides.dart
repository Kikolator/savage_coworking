import 'package:freezed_annotation/freezed_annotation.dart';

part 'overrides.freezed.dart';
part 'overrides.g.dart';

@freezed
class Overrides with _$Overrides {
  const factory Overrides({
    double? deskHoursPerPeriod,
    double? meetingHoursPerPeriod,
  }) = _Overrides;

  factory Overrides.fromJson(Map<String, dynamic> json) =>
      _$OverridesFromJson(json);
}

