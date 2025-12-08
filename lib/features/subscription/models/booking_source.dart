import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_source.freezed.dart';
part 'booking_source.g.dart';

@freezed
sealed class BookingSource with _$BookingSource {
  const factory BookingSource.subscription({
    required String subscriptionId,
  }) = SubscriptionBookingSource;

  const factory BookingSource.passBundle({
    required String passBundleId,
  }) = PassBundleBookingSource;

  factory BookingSource.fromJson(Map<String, dynamic> json) =>
      _$BookingSourceFromJson(json);
}

// Custom converter for Firestore serialization
class BookingSourceConverter extends JsonConverter<BookingSource, Map<String, dynamic>> {
  const BookingSourceConverter();

  @override
  BookingSource fromJson(Map<String, dynamic> json) {
    final kind = json['kind'] as String;
    if (kind == 'subscription') {
      return BookingSource.subscription(
        subscriptionId: json['subscriptionId'] as String,
      );
    } else if (kind == 'passBundle') {
      return BookingSource.passBundle(
        passBundleId: json['passBundleId'] as String,
      );
    }
    throw ArgumentError('Invalid booking source kind: $kind');
  }

  @override
  Map<String, dynamic> toJson(BookingSource object) {
    return switch (object) {
      SubscriptionBookingSource(:final subscriptionId) => {
          'kind': 'subscription',
          'subscriptionId': subscriptionId,
        },
      PassBundleBookingSource(:final passBundleId) => {
          'kind': 'passBundle',
          'passBundleId': passBundleId,
        },
    };
  }
}

