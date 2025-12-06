import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_failure.freezed.dart';

@freezed
class SubscriptionFailure with _$SubscriptionFailure {
  const factory SubscriptionFailure.validation(String message) =
      _ValidationFailure;

  const factory SubscriptionFailure.notFound() = _NotFoundFailure;

  const factory SubscriptionFailure.notAuthenticated() =
      _NotAuthenticatedFailure;

  const factory SubscriptionFailure.network() = _NetworkFailure;

  const factory SubscriptionFailure.unexpected(String message) =
      _UnexpectedFailure;
}


