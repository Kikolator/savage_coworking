// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'external.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

External _$ExternalFromJson(Map<String, dynamic> json) {
  return _External.fromJson(json);
}

/// @nodoc
mixin _$External {
  String? get stripeProductId => throw _privateConstructorUsedError;
  String? get stripePriceId => throw _privateConstructorUsedError;

  /// Serializes this External to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of External
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExternalCopyWith<External> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExternalCopyWith<$Res> {
  factory $ExternalCopyWith(External value, $Res Function(External) then) =
      _$ExternalCopyWithImpl<$Res, External>;
  @useResult
  $Res call({String? stripeProductId, String? stripePriceId});
}

/// @nodoc
class _$ExternalCopyWithImpl<$Res, $Val extends External>
    implements $ExternalCopyWith<$Res> {
  _$ExternalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of External
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stripeProductId = freezed,
    Object? stripePriceId = freezed,
  }) {
    return _then(
      _value.copyWith(
            stripeProductId: freezed == stripeProductId
                ? _value.stripeProductId
                : stripeProductId // ignore: cast_nullable_to_non_nullable
                      as String?,
            stripePriceId: freezed == stripePriceId
                ? _value.stripePriceId
                : stripePriceId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExternalImplCopyWith<$Res>
    implements $ExternalCopyWith<$Res> {
  factory _$$ExternalImplCopyWith(
    _$ExternalImpl value,
    $Res Function(_$ExternalImpl) then,
  ) = __$$ExternalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? stripeProductId, String? stripePriceId});
}

/// @nodoc
class __$$ExternalImplCopyWithImpl<$Res>
    extends _$ExternalCopyWithImpl<$Res, _$ExternalImpl>
    implements _$$ExternalImplCopyWith<$Res> {
  __$$ExternalImplCopyWithImpl(
    _$ExternalImpl _value,
    $Res Function(_$ExternalImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of External
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stripeProductId = freezed,
    Object? stripePriceId = freezed,
  }) {
    return _then(
      _$ExternalImpl(
        stripeProductId: freezed == stripeProductId
            ? _value.stripeProductId
            : stripeProductId // ignore: cast_nullable_to_non_nullable
                  as String?,
        stripePriceId: freezed == stripePriceId
            ? _value.stripePriceId
            : stripePriceId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExternalImpl implements _External {
  const _$ExternalImpl({this.stripeProductId, this.stripePriceId});

  factory _$ExternalImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExternalImplFromJson(json);

  @override
  final String? stripeProductId;
  @override
  final String? stripePriceId;

  @override
  String toString() {
    return 'External(stripeProductId: $stripeProductId, stripePriceId: $stripePriceId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalImpl &&
            (identical(other.stripeProductId, stripeProductId) ||
                other.stripeProductId == stripeProductId) &&
            (identical(other.stripePriceId, stripePriceId) ||
                other.stripePriceId == stripePriceId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, stripeProductId, stripePriceId);

  /// Create a copy of External
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalImplCopyWith<_$ExternalImpl> get copyWith =>
      __$$ExternalImplCopyWithImpl<_$ExternalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExternalImplToJson(this);
  }
}

abstract class _External implements External {
  const factory _External({
    final String? stripeProductId,
    final String? stripePriceId,
  }) = _$ExternalImpl;

  factory _External.fromJson(Map<String, dynamic> json) =
      _$ExternalImpl.fromJson;

  @override
  String? get stripeProductId;
  @override
  String? get stripePriceId;

  /// Create a copy of External
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExternalImplCopyWith<_$ExternalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
