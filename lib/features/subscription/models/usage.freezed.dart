// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Usage _$UsageFromJson(Map<String, dynamic> json) {
  return _Usage.fromJson(json);
}

/// @nodoc
mixin _$Usage {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get subscriptionId => throw _privateConstructorUsedError;
  String? get passBundleId => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get periodStart => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get periodEnd => throw _privateConstructorUsedError;
  int get deskMinutesUsed => throw _privateConstructorUsedError;
  int get meetingMinutesUsed => throw _privateConstructorUsedError;
  @BreakdownMapConverter()
  Map<String, Breakdown>? get breakdown => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Usage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Usage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UsageCopyWith<Usage> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsageCopyWith<$Res> {
  factory $UsageCopyWith(Usage value, $Res Function(Usage) then) =
      _$UsageCopyWithImpl<$Res, Usage>;
  @useResult
  $Res call({
    String id,
    String userId,
    String? subscriptionId,
    String? passBundleId,
    @TimestampConverter() DateTime periodStart,
    @TimestampConverter() DateTime periodEnd,
    int deskMinutesUsed,
    int meetingMinutesUsed,
    @BreakdownMapConverter() Map<String, Breakdown>? breakdown,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
  });
}

/// @nodoc
class _$UsageCopyWithImpl<$Res, $Val extends Usage>
    implements $UsageCopyWith<$Res> {
  _$UsageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Usage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? subscriptionId = freezed,
    Object? passBundleId = freezed,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? deskMinutesUsed = null,
    Object? meetingMinutesUsed = null,
    Object? breakdown = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            subscriptionId: freezed == subscriptionId
                ? _value.subscriptionId
                : subscriptionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            passBundleId: freezed == passBundleId
                ? _value.passBundleId
                : passBundleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            periodStart: null == periodStart
                ? _value.periodStart
                : periodStart // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            periodEnd: null == periodEnd
                ? _value.periodEnd
                : periodEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            deskMinutesUsed: null == deskMinutesUsed
                ? _value.deskMinutesUsed
                : deskMinutesUsed // ignore: cast_nullable_to_non_nullable
                      as int,
            meetingMinutesUsed: null == meetingMinutesUsed
                ? _value.meetingMinutesUsed
                : meetingMinutesUsed // ignore: cast_nullable_to_non_nullable
                      as int,
            breakdown: freezed == breakdown
                ? _value.breakdown
                : breakdown // ignore: cast_nullable_to_non_nullable
                      as Map<String, Breakdown>?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UsageImplCopyWith<$Res> implements $UsageCopyWith<$Res> {
  factory _$$UsageImplCopyWith(
    _$UsageImpl value,
    $Res Function(_$UsageImpl) then,
  ) = __$$UsageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String? subscriptionId,
    String? passBundleId,
    @TimestampConverter() DateTime periodStart,
    @TimestampConverter() DateTime periodEnd,
    int deskMinutesUsed,
    int meetingMinutesUsed,
    @BreakdownMapConverter() Map<String, Breakdown>? breakdown,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
  });
}

/// @nodoc
class __$$UsageImplCopyWithImpl<$Res>
    extends _$UsageCopyWithImpl<$Res, _$UsageImpl>
    implements _$$UsageImplCopyWith<$Res> {
  __$$UsageImplCopyWithImpl(
    _$UsageImpl _value,
    $Res Function(_$UsageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Usage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? subscriptionId = freezed,
    Object? passBundleId = freezed,
    Object? periodStart = null,
    Object? periodEnd = null,
    Object? deskMinutesUsed = null,
    Object? meetingMinutesUsed = null,
    Object? breakdown = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$UsageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        subscriptionId: freezed == subscriptionId
            ? _value.subscriptionId
            : subscriptionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        passBundleId: freezed == passBundleId
            ? _value.passBundleId
            : passBundleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        periodStart: null == periodStart
            ? _value.periodStart
            : periodStart // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        periodEnd: null == periodEnd
            ? _value.periodEnd
            : periodEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        deskMinutesUsed: null == deskMinutesUsed
            ? _value.deskMinutesUsed
            : deskMinutesUsed // ignore: cast_nullable_to_non_nullable
                  as int,
        meetingMinutesUsed: null == meetingMinutesUsed
            ? _value.meetingMinutesUsed
            : meetingMinutesUsed // ignore: cast_nullable_to_non_nullable
                  as int,
        breakdown: freezed == breakdown
            ? _value._breakdown
            : breakdown // ignore: cast_nullable_to_non_nullable
                  as Map<String, Breakdown>?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UsageImpl implements _Usage {
  const _$UsageImpl({
    required this.id,
    required this.userId,
    this.subscriptionId,
    this.passBundleId,
    @TimestampConverter() required this.periodStart,
    @TimestampConverter() required this.periodEnd,
    required this.deskMinutesUsed,
    required this.meetingMinutesUsed,
    @BreakdownMapConverter() final Map<String, Breakdown>? breakdown,
    @TimestampConverter() required this.createdAt,
    @TimestampConverter() required this.updatedAt,
  }) : _breakdown = breakdown;

  factory _$UsageImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsageImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? subscriptionId;
  @override
  final String? passBundleId;
  @override
  @TimestampConverter()
  final DateTime periodStart;
  @override
  @TimestampConverter()
  final DateTime periodEnd;
  @override
  final int deskMinutesUsed;
  @override
  final int meetingMinutesUsed;
  final Map<String, Breakdown>? _breakdown;
  @override
  @BreakdownMapConverter()
  Map<String, Breakdown>? get breakdown {
    final value = _breakdown;
    if (value == null) return null;
    if (_breakdown is EqualUnmodifiableMapView) return _breakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Usage(id: $id, userId: $userId, subscriptionId: $subscriptionId, passBundleId: $passBundleId, periodStart: $periodStart, periodEnd: $periodEnd, deskMinutesUsed: $deskMinutesUsed, meetingMinutesUsed: $meetingMinutesUsed, breakdown: $breakdown, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.subscriptionId, subscriptionId) ||
                other.subscriptionId == subscriptionId) &&
            (identical(other.passBundleId, passBundleId) ||
                other.passBundleId == passBundleId) &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.periodEnd, periodEnd) ||
                other.periodEnd == periodEnd) &&
            (identical(other.deskMinutesUsed, deskMinutesUsed) ||
                other.deskMinutesUsed == deskMinutesUsed) &&
            (identical(other.meetingMinutesUsed, meetingMinutesUsed) ||
                other.meetingMinutesUsed == meetingMinutesUsed) &&
            const DeepCollectionEquality().equals(
              other._breakdown,
              _breakdown,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    subscriptionId,
    passBundleId,
    periodStart,
    periodEnd,
    deskMinutesUsed,
    meetingMinutesUsed,
    const DeepCollectionEquality().hash(_breakdown),
    createdAt,
    updatedAt,
  );

  /// Create a copy of Usage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UsageImplCopyWith<_$UsageImpl> get copyWith =>
      __$$UsageImplCopyWithImpl<_$UsageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UsageImplToJson(this);
  }
}

abstract class _Usage implements Usage {
  const factory _Usage({
    required final String id,
    required final String userId,
    final String? subscriptionId,
    final String? passBundleId,
    @TimestampConverter() required final DateTime periodStart,
    @TimestampConverter() required final DateTime periodEnd,
    required final int deskMinutesUsed,
    required final int meetingMinutesUsed,
    @BreakdownMapConverter() final Map<String, Breakdown>? breakdown,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampConverter() required final DateTime updatedAt,
  }) = _$UsageImpl;

  factory _Usage.fromJson(Map<String, dynamic> json) = _$UsageImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get subscriptionId;
  @override
  String? get passBundleId;
  @override
  @TimestampConverter()
  DateTime get periodStart;
  @override
  @TimestampConverter()
  DateTime get periodEnd;
  @override
  int get deskMinutesUsed;
  @override
  int get meetingMinutesUsed;
  @override
  @BreakdownMapConverter()
  Map<String, Breakdown>? get breakdown;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;

  /// Create a copy of Usage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UsageImplCopyWith<_$UsageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
