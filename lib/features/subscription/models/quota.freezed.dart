// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quota.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Quota _$QuotaFromJson(Map<String, dynamic> json) {
  return _Quota.fromJson(json);
}

/// @nodoc
mixin _$Quota {
  int? get dayPassCredits => throw _privateConstructorUsedError;
  double? get deskHoursPerPeriod => throw _privateConstructorUsedError;
  double? get meetingHoursPerPeriod => throw _privateConstructorUsedError;
  Access get access => throw _privateConstructorUsedError;
  @SeatTypeConverter()
  SeatType? get seatType => throw _privateConstructorUsedError;

  /// Serializes this Quota to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Quota
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuotaCopyWith<Quota> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuotaCopyWith<$Res> {
  factory $QuotaCopyWith(Quota value, $Res Function(Quota) then) =
      _$QuotaCopyWithImpl<$Res, Quota>;
  @useResult
  $Res call({
    int? dayPassCredits,
    double? deskHoursPerPeriod,
    double? meetingHoursPerPeriod,
    Access access,
    @SeatTypeConverter() SeatType? seatType,
  });

  $AccessCopyWith<$Res> get access;
}

/// @nodoc
class _$QuotaCopyWithImpl<$Res, $Val extends Quota>
    implements $QuotaCopyWith<$Res> {
  _$QuotaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Quota
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayPassCredits = freezed,
    Object? deskHoursPerPeriod = freezed,
    Object? meetingHoursPerPeriod = freezed,
    Object? access = null,
    Object? seatType = freezed,
  }) {
    return _then(
      _value.copyWith(
            dayPassCredits: freezed == dayPassCredits
                ? _value.dayPassCredits
                : dayPassCredits // ignore: cast_nullable_to_non_nullable
                      as int?,
            deskHoursPerPeriod: freezed == deskHoursPerPeriod
                ? _value.deskHoursPerPeriod
                : deskHoursPerPeriod // ignore: cast_nullable_to_non_nullable
                      as double?,
            meetingHoursPerPeriod: freezed == meetingHoursPerPeriod
                ? _value.meetingHoursPerPeriod
                : meetingHoursPerPeriod // ignore: cast_nullable_to_non_nullable
                      as double?,
            access: null == access
                ? _value.access
                : access // ignore: cast_nullable_to_non_nullable
                      as Access,
            seatType: freezed == seatType
                ? _value.seatType
                : seatType // ignore: cast_nullable_to_non_nullable
                      as SeatType?,
          )
          as $Val,
    );
  }

  /// Create a copy of Quota
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccessCopyWith<$Res> get access {
    return $AccessCopyWith<$Res>(_value.access, (value) {
      return _then(_value.copyWith(access: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuotaImplCopyWith<$Res> implements $QuotaCopyWith<$Res> {
  factory _$$QuotaImplCopyWith(
    _$QuotaImpl value,
    $Res Function(_$QuotaImpl) then,
  ) = __$$QuotaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? dayPassCredits,
    double? deskHoursPerPeriod,
    double? meetingHoursPerPeriod,
    Access access,
    @SeatTypeConverter() SeatType? seatType,
  });

  @override
  $AccessCopyWith<$Res> get access;
}

/// @nodoc
class __$$QuotaImplCopyWithImpl<$Res>
    extends _$QuotaCopyWithImpl<$Res, _$QuotaImpl>
    implements _$$QuotaImplCopyWith<$Res> {
  __$$QuotaImplCopyWithImpl(
    _$QuotaImpl _value,
    $Res Function(_$QuotaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Quota
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayPassCredits = freezed,
    Object? deskHoursPerPeriod = freezed,
    Object? meetingHoursPerPeriod = freezed,
    Object? access = null,
    Object? seatType = freezed,
  }) {
    return _then(
      _$QuotaImpl(
        dayPassCredits: freezed == dayPassCredits
            ? _value.dayPassCredits
            : dayPassCredits // ignore: cast_nullable_to_non_nullable
                  as int?,
        deskHoursPerPeriod: freezed == deskHoursPerPeriod
            ? _value.deskHoursPerPeriod
            : deskHoursPerPeriod // ignore: cast_nullable_to_non_nullable
                  as double?,
        meetingHoursPerPeriod: freezed == meetingHoursPerPeriod
            ? _value.meetingHoursPerPeriod
            : meetingHoursPerPeriod // ignore: cast_nullable_to_non_nullable
                  as double?,
        access: null == access
            ? _value.access
            : access // ignore: cast_nullable_to_non_nullable
                  as Access,
        seatType: freezed == seatType
            ? _value.seatType
            : seatType // ignore: cast_nullable_to_non_nullable
                  as SeatType?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuotaImpl implements _Quota {
  const _$QuotaImpl({
    this.dayPassCredits,
    this.deskHoursPerPeriod,
    this.meetingHoursPerPeriod,
    required this.access,
    @SeatTypeConverter() this.seatType,
  });

  factory _$QuotaImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuotaImplFromJson(json);

  @override
  final int? dayPassCredits;
  @override
  final double? deskHoursPerPeriod;
  @override
  final double? meetingHoursPerPeriod;
  @override
  final Access access;
  @override
  @SeatTypeConverter()
  final SeatType? seatType;

  @override
  String toString() {
    return 'Quota(dayPassCredits: $dayPassCredits, deskHoursPerPeriod: $deskHoursPerPeriod, meetingHoursPerPeriod: $meetingHoursPerPeriod, access: $access, seatType: $seatType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuotaImpl &&
            (identical(other.dayPassCredits, dayPassCredits) ||
                other.dayPassCredits == dayPassCredits) &&
            (identical(other.deskHoursPerPeriod, deskHoursPerPeriod) ||
                other.deskHoursPerPeriod == deskHoursPerPeriod) &&
            (identical(other.meetingHoursPerPeriod, meetingHoursPerPeriod) ||
                other.meetingHoursPerPeriod == meetingHoursPerPeriod) &&
            (identical(other.access, access) || other.access == access) &&
            (identical(other.seatType, seatType) ||
                other.seatType == seatType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    dayPassCredits,
    deskHoursPerPeriod,
    meetingHoursPerPeriod,
    access,
    seatType,
  );

  /// Create a copy of Quota
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuotaImplCopyWith<_$QuotaImpl> get copyWith =>
      __$$QuotaImplCopyWithImpl<_$QuotaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuotaImplToJson(this);
  }
}

abstract class _Quota implements Quota {
  const factory _Quota({
    final int? dayPassCredits,
    final double? deskHoursPerPeriod,
    final double? meetingHoursPerPeriod,
    required final Access access,
    @SeatTypeConverter() final SeatType? seatType,
  }) = _$QuotaImpl;

  factory _Quota.fromJson(Map<String, dynamic> json) = _$QuotaImpl.fromJson;

  @override
  int? get dayPassCredits;
  @override
  double? get deskHoursPerPeriod;
  @override
  double? get meetingHoursPerPeriod;
  @override
  Access get access;
  @override
  @SeatTypeConverter()
  SeatType? get seatType;

  /// Create a copy of Quota
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuotaImplCopyWith<_$QuotaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
