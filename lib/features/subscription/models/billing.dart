import 'package:freezed_annotation/freezed_annotation.dart';

import 'billing_period.dart';
import 'billing_type.dart';

part 'billing.freezed.dart';
part 'billing.g.dart';

@freezed
class Billing with _$Billing {
  const factory Billing({
    @BillingTypeConverter() required BillingType type,
    @BillingPeriodConverter() BillingPeriod? period,
    @Default(1) int intervalCount,
  }) = _Billing;

  factory Billing.fromJson(Map<String, dynamic> json) =>
      _$BillingFromJson(json);
}

class BillingTypeConverter extends JsonConverter<BillingType, String> {
  const BillingTypeConverter();

  @override
  BillingType fromJson(String json) => BillingTypeX.fromJson(json);

  @override
  String toJson(BillingType object) => object.toJson();
}

class BillingPeriodConverter extends JsonConverter<BillingPeriod?, String?> {
  const BillingPeriodConverter();

  @override
  BillingPeriod? fromJson(String? json) =>
      json != null ? BillingPeriodX.fromJson(json) : null;

  @override
  String? toJson(BillingPeriod? object) => object?.toJson();
}

