// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'breakdown.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Breakdown _$BreakdownFromJson(Map<String, dynamic> json) {
  return _Breakdown.fromJson(json);
}

/// @nodoc
mixin _$Breakdown {
  String get date => throw _privateConstructorUsedError;
  int get deskMinutes => throw _privateConstructorUsedError;
  int get meetingMinutes => throw _privateConstructorUsedError;
  int get dayPassUsed => throw _privateConstructorUsedError;

  /// Serializes this Breakdown to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Breakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BreakdownCopyWith<Breakdown> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreakdownCopyWith<$Res> {
  factory $BreakdownCopyWith(Breakdown value, $Res Function(Breakdown) then) =
      _$BreakdownCopyWithImpl<$Res, Breakdown>;
  @useResult
  $Res call({
    String date,
    int deskMinutes,
    int meetingMinutes,
    int dayPassUsed,
  });
}

/// @nodoc
class _$BreakdownCopyWithImpl<$Res, $Val extends Breakdown>
    implements $BreakdownCopyWith<$Res> {
  _$BreakdownCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Breakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? deskMinutes = null,
    Object? meetingMinutes = null,
    Object? dayPassUsed = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            deskMinutes: null == deskMinutes
                ? _value.deskMinutes
                : deskMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            meetingMinutes: null == meetingMinutes
                ? _value.meetingMinutes
                : meetingMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            dayPassUsed: null == dayPassUsed
                ? _value.dayPassUsed
                : dayPassUsed // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BreakdownImplCopyWith<$Res>
    implements $BreakdownCopyWith<$Res> {
  factory _$$BreakdownImplCopyWith(
    _$BreakdownImpl value,
    $Res Function(_$BreakdownImpl) then,
  ) = __$$BreakdownImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String date,
    int deskMinutes,
    int meetingMinutes,
    int dayPassUsed,
  });
}

/// @nodoc
class __$$BreakdownImplCopyWithImpl<$Res>
    extends _$BreakdownCopyWithImpl<$Res, _$BreakdownImpl>
    implements _$$BreakdownImplCopyWith<$Res> {
  __$$BreakdownImplCopyWithImpl(
    _$BreakdownImpl _value,
    $Res Function(_$BreakdownImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Breakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? deskMinutes = null,
    Object? meetingMinutes = null,
    Object? dayPassUsed = null,
  }) {
    return _then(
      _$BreakdownImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        deskMinutes: null == deskMinutes
            ? _value.deskMinutes
            : deskMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        meetingMinutes: null == meetingMinutes
            ? _value.meetingMinutes
            : meetingMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        dayPassUsed: null == dayPassUsed
            ? _value.dayPassUsed
            : dayPassUsed // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BreakdownImpl implements _Breakdown {
  const _$BreakdownImpl({
    required this.date,
    required this.deskMinutes,
    required this.meetingMinutes,
    this.dayPassUsed = 0,
  });

  factory _$BreakdownImpl.fromJson(Map<String, dynamic> json) =>
      _$$BreakdownImplFromJson(json);

  @override
  final String date;
  @override
  final int deskMinutes;
  @override
  final int meetingMinutes;
  @override
  @JsonKey()
  final int dayPassUsed;

  @override
  String toString() {
    return 'Breakdown(date: $date, deskMinutes: $deskMinutes, meetingMinutes: $meetingMinutes, dayPassUsed: $dayPassUsed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreakdownImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.deskMinutes, deskMinutes) ||
                other.deskMinutes == deskMinutes) &&
            (identical(other.meetingMinutes, meetingMinutes) ||
                other.meetingMinutes == meetingMinutes) &&
            (identical(other.dayPassUsed, dayPassUsed) ||
                other.dayPassUsed == dayPassUsed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, deskMinutes, meetingMinutes, dayPassUsed);

  /// Create a copy of Breakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BreakdownImplCopyWith<_$BreakdownImpl> get copyWith =>
      __$$BreakdownImplCopyWithImpl<_$BreakdownImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BreakdownImplToJson(this);
  }
}

abstract class _Breakdown implements Breakdown {
  const factory _Breakdown({
    required final String date,
    required final int deskMinutes,
    required final int meetingMinutes,
    final int dayPassUsed,
  }) = _$BreakdownImpl;

  factory _Breakdown.fromJson(Map<String, dynamic> json) =
      _$BreakdownImpl.fromJson;

  @override
  String get date;
  @override
  int get deskMinutes;
  @override
  int get meetingMinutes;
  @override
  int get dayPassUsed;

  /// Create a copy of Breakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BreakdownImplCopyWith<_$BreakdownImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
