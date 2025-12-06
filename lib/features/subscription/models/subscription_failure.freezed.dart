// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SubscriptionFailure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) validation,
    required TResult Function() notFound,
    required TResult Function() notAuthenticated,
    required TResult Function() network,
    required TResult Function(String message) unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? validation,
    TResult? Function()? notFound,
    TResult? Function()? notAuthenticated,
    TResult? Function()? network,
    TResult? Function(String message)? unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? validation,
    TResult Function()? notFound,
    TResult Function()? notAuthenticated,
    TResult Function()? network,
    TResult Function(String message)? unexpected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ValidationFailure value) validation,
    required TResult Function(_NotFoundFailure value) notFound,
    required TResult Function(_NotAuthenticatedFailure value) notAuthenticated,
    required TResult Function(_NetworkFailure value) network,
    required TResult Function(_UnexpectedFailure value) unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ValidationFailure value)? validation,
    TResult? Function(_NotFoundFailure value)? notFound,
    TResult? Function(_NotAuthenticatedFailure value)? notAuthenticated,
    TResult? Function(_NetworkFailure value)? network,
    TResult? Function(_UnexpectedFailure value)? unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ValidationFailure value)? validation,
    TResult Function(_NotFoundFailure value)? notFound,
    TResult Function(_NotAuthenticatedFailure value)? notAuthenticated,
    TResult Function(_NetworkFailure value)? network,
    TResult Function(_UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionFailureCopyWith<$Res> {
  factory $SubscriptionFailureCopyWith(
    SubscriptionFailure value,
    $Res Function(SubscriptionFailure) then,
  ) = _$SubscriptionFailureCopyWithImpl<$Res, SubscriptionFailure>;
}

/// @nodoc
class _$SubscriptionFailureCopyWithImpl<$Res, $Val extends SubscriptionFailure>
    implements $SubscriptionFailureCopyWith<$Res> {
  _$SubscriptionFailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ValidationFailureImplCopyWith<$Res> {
  factory _$$ValidationFailureImplCopyWith(
    _$ValidationFailureImpl value,
    $Res Function(_$ValidationFailureImpl) then,
  ) = __$$ValidationFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ValidationFailureImplCopyWithImpl<$Res>
    extends _$SubscriptionFailureCopyWithImpl<$Res, _$ValidationFailureImpl>
    implements _$$ValidationFailureImplCopyWith<$Res> {
  __$$ValidationFailureImplCopyWithImpl(
    _$ValidationFailureImpl _value,
    $Res Function(_$ValidationFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubscriptionFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ValidationFailureImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ValidationFailureImpl implements _ValidationFailure {
  const _$ValidationFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'SubscriptionFailure.validation(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of SubscriptionFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationFailureImplCopyWith<_$ValidationFailureImpl> get copyWith =>
      __$$ValidationFailureImplCopyWithImpl<_$ValidationFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) validation,
    required TResult Function() notFound,
    required TResult Function() notAuthenticated,
    required TResult Function() network,
    required TResult Function(String message) unexpected,
  }) {
    return validation(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? validation,
    TResult? Function()? notFound,
    TResult? Function()? notAuthenticated,
    TResult? Function()? network,
    TResult? Function(String message)? unexpected,
  }) {
    return validation?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? validation,
    TResult Function()? notFound,
    TResult Function()? notAuthenticated,
    TResult Function()? network,
    TResult Function(String message)? unexpected,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ValidationFailure value) validation,
    required TResult Function(_NotFoundFailure value) notFound,
    required TResult Function(_NotAuthenticatedFailure value) notAuthenticated,
    required TResult Function(_NetworkFailure value) network,
    required TResult Function(_UnexpectedFailure value) unexpected,
  }) {
    return validation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ValidationFailure value)? validation,
    TResult? Function(_NotFoundFailure value)? notFound,
    TResult? Function(_NotAuthenticatedFailure value)? notAuthenticated,
    TResult? Function(_NetworkFailure value)? network,
    TResult? Function(_UnexpectedFailure value)? unexpected,
  }) {
    return validation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ValidationFailure value)? validation,
    TResult Function(_NotFoundFailure value)? notFound,
    TResult Function(_NotAuthenticatedFailure value)? notAuthenticated,
    TResult Function(_NetworkFailure value)? network,
    TResult Function(_UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(this);
    }
    return orElse();
  }
}

abstract class _ValidationFailure implements SubscriptionFailure {
  const factory _ValidationFailure(final String message) =
      _$ValidationFailureImpl;

  String get message;

  /// Create a copy of SubscriptionFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidationFailureImplCopyWith<_$ValidationFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NotFoundFailureImplCopyWith<$Res> {
  factory _$$NotFoundFailureImplCopyWith(
    _$NotFoundFailureImpl value,
    $Res Function(_$NotFoundFailureImpl) then,
  ) = __$$NotFoundFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NotFoundFailureImplCopyWithImpl<$Res>
    extends _$SubscriptionFailureCopyWithImpl<$Res, _$NotFoundFailureImpl>
    implements _$$NotFoundFailureImplCopyWith<$Res> {
  __$$NotFoundFailureImplCopyWithImpl(
    _$NotFoundFailureImpl _value,
    $Res Function(_$NotFoundFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubscriptionFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NotFoundFailureImpl implements _NotFoundFailure {
  const _$NotFoundFailureImpl();

  @override
  String toString() {
    return 'SubscriptionFailure.notFound()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NotFoundFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) validation,
    required TResult Function() notFound,
    required TResult Function() notAuthenticated,
    required TResult Function() network,
    required TResult Function(String message) unexpected,
  }) {
    return notFound();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? validation,
    TResult? Function()? notFound,
    TResult? Function()? notAuthenticated,
    TResult? Function()? network,
    TResult? Function(String message)? unexpected,
  }) {
    return notFound?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? validation,
    TResult Function()? notFound,
    TResult Function()? notAuthenticated,
    TResult Function()? network,
    TResult Function(String message)? unexpected,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ValidationFailure value) validation,
    required TResult Function(_NotFoundFailure value) notFound,
    required TResult Function(_NotAuthenticatedFailure value) notAuthenticated,
    required TResult Function(_NetworkFailure value) network,
    required TResult Function(_UnexpectedFailure value) unexpected,
  }) {
    return notFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ValidationFailure value)? validation,
    TResult? Function(_NotFoundFailure value)? notFound,
    TResult? Function(_NotAuthenticatedFailure value)? notAuthenticated,
    TResult? Function(_NetworkFailure value)? network,
    TResult? Function(_UnexpectedFailure value)? unexpected,
  }) {
    return notFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ValidationFailure value)? validation,
    TResult Function(_NotFoundFailure value)? notFound,
    TResult Function(_NotAuthenticatedFailure value)? notAuthenticated,
    TResult Function(_NetworkFailure value)? network,
    TResult Function(_UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(this);
    }
    return orElse();
  }
}

abstract class _NotFoundFailure implements SubscriptionFailure {
  const factory _NotFoundFailure() = _$NotFoundFailureImpl;
}

/// @nodoc
abstract class _$$NotAuthenticatedFailureImplCopyWith<$Res> {
  factory _$$NotAuthenticatedFailureImplCopyWith(
    _$NotAuthenticatedFailureImpl value,
    $Res Function(_$NotAuthenticatedFailureImpl) then,
  ) = __$$NotAuthenticatedFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NotAuthenticatedFailureImplCopyWithImpl<$Res>
    extends
        _$SubscriptionFailureCopyWithImpl<$Res, _$NotAuthenticatedFailureImpl>
    implements _$$NotAuthenticatedFailureImplCopyWith<$Res> {
  __$$NotAuthenticatedFailureImplCopyWithImpl(
    _$NotAuthenticatedFailureImpl _value,
    $Res Function(_$NotAuthenticatedFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubscriptionFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NotAuthenticatedFailureImpl implements _NotAuthenticatedFailure {
  const _$NotAuthenticatedFailureImpl();

  @override
  String toString() {
    return 'SubscriptionFailure.notAuthenticated()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotAuthenticatedFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) validation,
    required TResult Function() notFound,
    required TResult Function() notAuthenticated,
    required TResult Function() network,
    required TResult Function(String message) unexpected,
  }) {
    return notAuthenticated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? validation,
    TResult? Function()? notFound,
    TResult? Function()? notAuthenticated,
    TResult? Function()? network,
    TResult? Function(String message)? unexpected,
  }) {
    return notAuthenticated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? validation,
    TResult Function()? notFound,
    TResult Function()? notAuthenticated,
    TResult Function()? network,
    TResult Function(String message)? unexpected,
    required TResult orElse(),
  }) {
    if (notAuthenticated != null) {
      return notAuthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ValidationFailure value) validation,
    required TResult Function(_NotFoundFailure value) notFound,
    required TResult Function(_NotAuthenticatedFailure value) notAuthenticated,
    required TResult Function(_NetworkFailure value) network,
    required TResult Function(_UnexpectedFailure value) unexpected,
  }) {
    return notAuthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ValidationFailure value)? validation,
    TResult? Function(_NotFoundFailure value)? notFound,
    TResult? Function(_NotAuthenticatedFailure value)? notAuthenticated,
    TResult? Function(_NetworkFailure value)? network,
    TResult? Function(_UnexpectedFailure value)? unexpected,
  }) {
    return notAuthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ValidationFailure value)? validation,
    TResult Function(_NotFoundFailure value)? notFound,
    TResult Function(_NotAuthenticatedFailure value)? notAuthenticated,
    TResult Function(_NetworkFailure value)? network,
    TResult Function(_UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (notAuthenticated != null) {
      return notAuthenticated(this);
    }
    return orElse();
  }
}

abstract class _NotAuthenticatedFailure implements SubscriptionFailure {
  const factory _NotAuthenticatedFailure() = _$NotAuthenticatedFailureImpl;
}

/// @nodoc
abstract class _$$NetworkFailureImplCopyWith<$Res> {
  factory _$$NetworkFailureImplCopyWith(
    _$NetworkFailureImpl value,
    $Res Function(_$NetworkFailureImpl) then,
  ) = __$$NetworkFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NetworkFailureImplCopyWithImpl<$Res>
    extends _$SubscriptionFailureCopyWithImpl<$Res, _$NetworkFailureImpl>
    implements _$$NetworkFailureImplCopyWith<$Res> {
  __$$NetworkFailureImplCopyWithImpl(
    _$NetworkFailureImpl _value,
    $Res Function(_$NetworkFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubscriptionFailure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NetworkFailureImpl implements _NetworkFailure {
  const _$NetworkFailureImpl();

  @override
  String toString() {
    return 'SubscriptionFailure.network()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NetworkFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) validation,
    required TResult Function() notFound,
    required TResult Function() notAuthenticated,
    required TResult Function() network,
    required TResult Function(String message) unexpected,
  }) {
    return network();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? validation,
    TResult? Function()? notFound,
    TResult? Function()? notAuthenticated,
    TResult? Function()? network,
    TResult? Function(String message)? unexpected,
  }) {
    return network?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? validation,
    TResult Function()? notFound,
    TResult Function()? notAuthenticated,
    TResult Function()? network,
    TResult Function(String message)? unexpected,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ValidationFailure value) validation,
    required TResult Function(_NotFoundFailure value) notFound,
    required TResult Function(_NotAuthenticatedFailure value) notAuthenticated,
    required TResult Function(_NetworkFailure value) network,
    required TResult Function(_UnexpectedFailure value) unexpected,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ValidationFailure value)? validation,
    TResult? Function(_NotFoundFailure value)? notFound,
    TResult? Function(_NotAuthenticatedFailure value)? notAuthenticated,
    TResult? Function(_NetworkFailure value)? network,
    TResult? Function(_UnexpectedFailure value)? unexpected,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ValidationFailure value)? validation,
    TResult Function(_NotFoundFailure value)? notFound,
    TResult Function(_NotAuthenticatedFailure value)? notAuthenticated,
    TResult Function(_NetworkFailure value)? network,
    TResult Function(_UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class _NetworkFailure implements SubscriptionFailure {
  const factory _NetworkFailure() = _$NetworkFailureImpl;
}

/// @nodoc
abstract class _$$UnexpectedFailureImplCopyWith<$Res> {
  factory _$$UnexpectedFailureImplCopyWith(
    _$UnexpectedFailureImpl value,
    $Res Function(_$UnexpectedFailureImpl) then,
  ) = __$$UnexpectedFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$UnexpectedFailureImplCopyWithImpl<$Res>
    extends _$SubscriptionFailureCopyWithImpl<$Res, _$UnexpectedFailureImpl>
    implements _$$UnexpectedFailureImplCopyWith<$Res> {
  __$$UnexpectedFailureImplCopyWithImpl(
    _$UnexpectedFailureImpl _value,
    $Res Function(_$UnexpectedFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubscriptionFailure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$UnexpectedFailureImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UnexpectedFailureImpl implements _UnexpectedFailure {
  const _$UnexpectedFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'SubscriptionFailure.unexpected(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnexpectedFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of SubscriptionFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnexpectedFailureImplCopyWith<_$UnexpectedFailureImpl> get copyWith =>
      __$$UnexpectedFailureImplCopyWithImpl<_$UnexpectedFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) validation,
    required TResult Function() notFound,
    required TResult Function() notAuthenticated,
    required TResult Function() network,
    required TResult Function(String message) unexpected,
  }) {
    return unexpected(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? validation,
    TResult? Function()? notFound,
    TResult? Function()? notAuthenticated,
    TResult? Function()? network,
    TResult? Function(String message)? unexpected,
  }) {
    return unexpected?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? validation,
    TResult Function()? notFound,
    TResult Function()? notAuthenticated,
    TResult Function()? network,
    TResult Function(String message)? unexpected,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ValidationFailure value) validation,
    required TResult Function(_NotFoundFailure value) notFound,
    required TResult Function(_NotAuthenticatedFailure value) notAuthenticated,
    required TResult Function(_NetworkFailure value) network,
    required TResult Function(_UnexpectedFailure value) unexpected,
  }) {
    return unexpected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ValidationFailure value)? validation,
    TResult? Function(_NotFoundFailure value)? notFound,
    TResult? Function(_NotAuthenticatedFailure value)? notAuthenticated,
    TResult? Function(_NetworkFailure value)? network,
    TResult? Function(_UnexpectedFailure value)? unexpected,
  }) {
    return unexpected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ValidationFailure value)? validation,
    TResult Function(_NotFoundFailure value)? notFound,
    TResult Function(_NotAuthenticatedFailure value)? notAuthenticated,
    TResult Function(_NetworkFailure value)? network,
    TResult Function(_UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected(this);
    }
    return orElse();
  }
}

abstract class _UnexpectedFailure implements SubscriptionFailure {
  const factory _UnexpectedFailure(final String message) =
      _$UnexpectedFailureImpl;

  String get message;

  /// Create a copy of SubscriptionFailure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnexpectedFailureImplCopyWith<_$UnexpectedFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
