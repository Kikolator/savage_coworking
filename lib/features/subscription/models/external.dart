import 'package:freezed_annotation/freezed_annotation.dart';

part 'external.freezed.dart';
part 'external.g.dart';

@freezed
class External with _$External {
  const factory External({
    String? stripeProductId,
    String? stripePriceId,
  }) = _External;

  factory External.fromJson(Map<String, dynamic> json) =>
      _$ExternalFromJson(json);
}

