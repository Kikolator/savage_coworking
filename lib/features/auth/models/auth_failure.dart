import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

@freezed
class AuthFailure with _$AuthFailure {
  const factory AuthFailure.invalidCredentials() = InvalidCredentials;
  const factory AuthFailure.emailAlreadyInUse() = EmailAlreadyInUse;
  const factory AuthFailure.weakPassword() = WeakPassword;
  const factory AuthFailure.network() = Network;
  const factory AuthFailure.unexpected([String? message]) = Unexpected;
}

