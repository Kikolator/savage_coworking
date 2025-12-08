// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pricing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PricingImpl _$$PricingImplFromJson(Map<String, dynamic> json) =>
    _$PricingImpl(
      currency: json['currency'] as String,
      amount: (json['amount'] as num).toInt(),
      billingDescription: json['billingDescription'] as String,
    );

Map<String, dynamic> _$$PricingImplToJson(_$PricingImpl instance) =>
    <String, dynamic>{
      'currency': instance.currency,
      'amount': instance.amount,
      'billingDescription': instance.billingDescription,
    };
