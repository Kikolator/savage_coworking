import 'package:freezed_annotation/freezed_annotation.dart';

part 'pricing.freezed.dart';
part 'pricing.g.dart';

@freezed
class Pricing with _$Pricing {
  const factory Pricing({
    required String currency,
    required int amount,
    required String billingDescription,
  }) = _Pricing;

  factory Pricing.fromJson(Map<String, dynamic> json) =>
      _$PricingFromJson(json);
}

