// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BookingSource _$BookingSourceFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'subscription':
      return SubscriptionBookingSource.fromJson(json);
    case 'passBundle':
      return PassBundleBookingSource.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'BookingSource',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$BookingSource {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String subscriptionId) subscription,
    required TResult Function(String passBundleId) passBundle,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String subscriptionId)? subscription,
    TResult? Function(String passBundleId)? passBundle,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String subscriptionId)? subscription,
    TResult Function(String passBundleId)? passBundle,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SubscriptionBookingSource value) subscription,
    required TResult Function(PassBundleBookingSource value) passBundle,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SubscriptionBookingSource value)? subscription,
    TResult? Function(PassBundleBookingSource value)? passBundle,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SubscriptionBookingSource value)? subscription,
    TResult Function(PassBundleBookingSource value)? passBundle,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this BookingSource to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingSourceCopyWith<$Res> {
  factory $BookingSourceCopyWith(
    BookingSource value,
    $Res Function(BookingSource) then,
  ) = _$BookingSourceCopyWithImpl<$Res, BookingSource>;
}

/// @nodoc
class _$BookingSourceCopyWithImpl<$Res, $Val extends BookingSource>
    implements $BookingSourceCopyWith<$Res> {
  _$BookingSourceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingSource
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SubscriptionBookingSourceImplCopyWith<$Res> {
  factory _$$SubscriptionBookingSourceImplCopyWith(
    _$SubscriptionBookingSourceImpl value,
    $Res Function(_$SubscriptionBookingSourceImpl) then,
  ) = __$$SubscriptionBookingSourceImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String subscriptionId});
}

/// @nodoc
class __$$SubscriptionBookingSourceImplCopyWithImpl<$Res>
    extends _$BookingSourceCopyWithImpl<$Res, _$SubscriptionBookingSourceImpl>
    implements _$$SubscriptionBookingSourceImplCopyWith<$Res> {
  __$$SubscriptionBookingSourceImplCopyWithImpl(
    _$SubscriptionBookingSourceImpl _value,
    $Res Function(_$SubscriptionBookingSourceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? subscriptionId = null}) {
    return _then(
      _$SubscriptionBookingSourceImpl(
        subscriptionId: null == subscriptionId
            ? _value.subscriptionId
            : subscriptionId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionBookingSourceImpl implements SubscriptionBookingSource {
  const _$SubscriptionBookingSourceImpl({
    required this.subscriptionId,
    final String? $type,
  }) : $type = $type ?? 'subscription';

  factory _$SubscriptionBookingSourceImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionBookingSourceImplFromJson(json);

  @override
  final String subscriptionId;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'BookingSource.subscription(subscriptionId: $subscriptionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionBookingSourceImpl &&
            (identical(other.subscriptionId, subscriptionId) ||
                other.subscriptionId == subscriptionId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, subscriptionId);

  /// Create a copy of BookingSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionBookingSourceImplCopyWith<_$SubscriptionBookingSourceImpl>
  get copyWith =>
      __$$SubscriptionBookingSourceImplCopyWithImpl<
        _$SubscriptionBookingSourceImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String subscriptionId) subscription,
    required TResult Function(String passBundleId) passBundle,
  }) {
    return subscription(subscriptionId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String subscriptionId)? subscription,
    TResult? Function(String passBundleId)? passBundle,
  }) {
    return subscription?.call(subscriptionId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String subscriptionId)? subscription,
    TResult Function(String passBundleId)? passBundle,
    required TResult orElse(),
  }) {
    if (subscription != null) {
      return subscription(subscriptionId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SubscriptionBookingSource value) subscription,
    required TResult Function(PassBundleBookingSource value) passBundle,
  }) {
    return subscription(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SubscriptionBookingSource value)? subscription,
    TResult? Function(PassBundleBookingSource value)? passBundle,
  }) {
    return subscription?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SubscriptionBookingSource value)? subscription,
    TResult Function(PassBundleBookingSource value)? passBundle,
    required TResult orElse(),
  }) {
    if (subscription != null) {
      return subscription(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionBookingSourceImplToJson(this);
  }
}

abstract class SubscriptionBookingSource implements BookingSource {
  const factory SubscriptionBookingSource({
    required final String subscriptionId,
  }) = _$SubscriptionBookingSourceImpl;

  factory SubscriptionBookingSource.fromJson(Map<String, dynamic> json) =
      _$SubscriptionBookingSourceImpl.fromJson;

  String get subscriptionId;

  /// Create a copy of BookingSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionBookingSourceImplCopyWith<_$SubscriptionBookingSourceImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PassBundleBookingSourceImplCopyWith<$Res> {
  factory _$$PassBundleBookingSourceImplCopyWith(
    _$PassBundleBookingSourceImpl value,
    $Res Function(_$PassBundleBookingSourceImpl) then,
  ) = __$$PassBundleBookingSourceImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String passBundleId});
}

/// @nodoc
class __$$PassBundleBookingSourceImplCopyWithImpl<$Res>
    extends _$BookingSourceCopyWithImpl<$Res, _$PassBundleBookingSourceImpl>
    implements _$$PassBundleBookingSourceImplCopyWith<$Res> {
  __$$PassBundleBookingSourceImplCopyWithImpl(
    _$PassBundleBookingSourceImpl _value,
    $Res Function(_$PassBundleBookingSourceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? passBundleId = null}) {
    return _then(
      _$PassBundleBookingSourceImpl(
        passBundleId: null == passBundleId
            ? _value.passBundleId
            : passBundleId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PassBundleBookingSourceImpl implements PassBundleBookingSource {
  const _$PassBundleBookingSourceImpl({
    required this.passBundleId,
    final String? $type,
  }) : $type = $type ?? 'passBundle';

  factory _$PassBundleBookingSourceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PassBundleBookingSourceImplFromJson(json);

  @override
  final String passBundleId;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'BookingSource.passBundle(passBundleId: $passBundleId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PassBundleBookingSourceImpl &&
            (identical(other.passBundleId, passBundleId) ||
                other.passBundleId == passBundleId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, passBundleId);

  /// Create a copy of BookingSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PassBundleBookingSourceImplCopyWith<_$PassBundleBookingSourceImpl>
  get copyWith =>
      __$$PassBundleBookingSourceImplCopyWithImpl<
        _$PassBundleBookingSourceImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String subscriptionId) subscription,
    required TResult Function(String passBundleId) passBundle,
  }) {
    return passBundle(passBundleId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String subscriptionId)? subscription,
    TResult? Function(String passBundleId)? passBundle,
  }) {
    return passBundle?.call(passBundleId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String subscriptionId)? subscription,
    TResult Function(String passBundleId)? passBundle,
    required TResult orElse(),
  }) {
    if (passBundle != null) {
      return passBundle(passBundleId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SubscriptionBookingSource value) subscription,
    required TResult Function(PassBundleBookingSource value) passBundle,
  }) {
    return passBundle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SubscriptionBookingSource value)? subscription,
    TResult? Function(PassBundleBookingSource value)? passBundle,
  }) {
    return passBundle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SubscriptionBookingSource value)? subscription,
    TResult Function(PassBundleBookingSource value)? passBundle,
    required TResult orElse(),
  }) {
    if (passBundle != null) {
      return passBundle(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PassBundleBookingSourceImplToJson(this);
  }
}

abstract class PassBundleBookingSource implements BookingSource {
  const factory PassBundleBookingSource({required final String passBundleId}) =
      _$PassBundleBookingSourceImpl;

  factory PassBundleBookingSource.fromJson(Map<String, dynamic> json) =
      _$PassBundleBookingSourceImpl.fromJson;

  String get passBundleId;

  /// Create a copy of BookingSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PassBundleBookingSourceImplCopyWith<_$PassBundleBookingSourceImpl>
  get copyWith => throw _privateConstructorUsedError;
}
