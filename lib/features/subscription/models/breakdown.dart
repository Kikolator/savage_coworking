import 'package:freezed_annotation/freezed_annotation.dart';

part 'breakdown.freezed.dart';
part 'breakdown.g.dart';

@freezed
class Breakdown with _$Breakdown {
  const factory Breakdown({
    required String date,
    required int deskMinutes,
    required int meetingMinutes,
    @Default(0) int dayPassUsed,
  }) = _Breakdown;

  factory Breakdown.fromJson(Map<String, dynamic> json) =>
      _$BreakdownFromJson(json);
}

