import 'package:freezed_annotation/freezed_annotation.dart';

part 'display.freezed.dart';
part 'display.g.dart';

@freezed
class Display with _$Display {
  const factory Display({
    required String planName,
    required int priceAmount,
    required String priceCurrency,
  }) = _Display;

  factory Display.fromJson(Map<String, dynamic> json) =>
      _$DisplayFromJson(json);
}

