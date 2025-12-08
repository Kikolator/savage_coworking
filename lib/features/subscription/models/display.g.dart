// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'display.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DisplayImpl _$$DisplayImplFromJson(Map<String, dynamic> json) =>
    _$DisplayImpl(
      planName: json['planName'] as String,
      priceAmount: (json['priceAmount'] as num).toInt(),
      priceCurrency: json['priceCurrency'] as String,
    );

Map<String, dynamic> _$$DisplayImplToJson(_$DisplayImpl instance) =>
    <String, dynamic>{
      'planName': instance.planName,
      'priceAmount': instance.priceAmount,
      'priceCurrency': instance.priceCurrency,
    };
