// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overrides.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Overrides _$OverridesFromJson(Map<String, dynamic> json) {
  return _Overrides.fromJson(json);
}

/// @nodoc
mixin _$Overrides {
  double? get deskHoursPerPeriod => throw _privateConstructorUsedError;
  double? get meetingHoursPerPeriod => throw _privateConstructorUsedError;

  /// Serializes this Overrides to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Overrides
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OverridesCopyWith<Overrides> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OverridesCopyWith<$Res> {
  factory $OverridesCopyWith(Overrides value, $Res Function(Overrides) then) =
      _$OverridesCopyWithImpl<$Res, Overrides>;
  @useResult
  $Res call({double? deskHoursPerPeriod, double? meetingHoursPerPeriod});
}

/// @nodoc
class _$OverridesCopyWithImpl<$Res, $Val extends Overrides>
    implements $OverridesCopyWith<$Res> {
  _$OverridesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Overrides
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deskHoursPerPeriod = freezed,
    Object? meetingHoursPerPeriod = freezed,
  }) {
    return _then(
      _value.copyWith(
            deskHoursPerPeriod: freezed == deskHoursPerPeriod
                ? _value.deskHoursPerPeriod
                : deskHoursPerPeriod // ignore: cast_nullable_to_non_nullable
                      as double?,
            meetingHoursPerPeriod: freezed == meetingHoursPerPeriod
                ? _value.meetingHoursPerPeriod
                : meetingHoursPerPeriod // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OverridesImplCopyWith<$Res>
    implements $OverridesCopyWith<$Res> {
  factory _$$OverridesImplCopyWith(
    _$OverridesImpl value,
    $Res Function(_$OverridesImpl) then,
  ) = __$$OverridesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double? deskHoursPerPeriod, double? meetingHoursPerPeriod});
}

/// @nodoc
class __$$OverridesImplCopyWithImpl<$Res>
    extends _$OverridesCopyWithImpl<$Res, _$OverridesImpl>
    implements _$$OverridesImplCopyWith<$Res> {
  __$$OverridesImplCopyWithImpl(
    _$OverridesImpl _value,
    $Res Function(_$OverridesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Overrides
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deskHoursPerPeriod = freezed,
    Object? meetingHoursPerPeriod = freezed,
  }) {
    return _then(
      _$OverridesImpl(
        deskHoursPerPeriod: freezed == deskHoursPerPeriod
            ? _value.deskHoursPerPeriod
            : deskHoursPerPeriod // ignore: cast_nullable_to_non_nullable
                  as double?,
        meetingHoursPerPeriod: freezed == meetingHoursPerPeriod
            ? _value.meetingHoursPerPeriod
            : meetingHoursPerPeriod // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OverridesImpl implements _Overrides {
  const _$OverridesImpl({this.deskHoursPerPeriod, this.meetingHoursPerPeriod});

  factory _$OverridesImpl.fromJson(Map<String, dynamic> json) =>
      _$$OverridesImplFromJson(json);

  @override
  final double? deskHoursPerPeriod;
  @override
  final double? meetingHoursPerPeriod;

  @override
  String toString() {
    return 'Overrides(deskHoursPerPeriod: $deskHoursPerPeriod, meetingHoursPerPeriod: $meetingHoursPerPeriod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OverridesImpl &&
            (identical(other.deskHoursPerPeriod, deskHoursPerPeriod) ||
                other.deskHoursPerPeriod == deskHoursPerPeriod) &&
            (identical(other.meetingHoursPerPeriod, meetingHoursPerPeriod) ||
                other.meetingHoursPerPeriod == meetingHoursPerPeriod));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, deskHoursPerPeriod, meetingHoursPerPeriod);

  /// Create a copy of Overrides
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OverridesImplCopyWith<_$OverridesImpl> get copyWith =>
      __$$OverridesImplCopyWithImpl<_$OverridesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OverridesImplToJson(this);
  }
}

abstract class _Overrides implements Overrides {
  const factory _Overrides({
    final double? deskHoursPerPeriod,
    final double? meetingHoursPerPeriod,
  }) = _$OverridesImpl;

  factory _Overrides.fromJson(Map<String, dynamic> json) =
      _$OverridesImpl.fromJson;

  @override
  double? get deskHoursPerPeriod;
  @override
  double? get meetingHoursPerPeriod;

  /// Create a copy of Overrides
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OverridesImplCopyWith<_$OverridesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
