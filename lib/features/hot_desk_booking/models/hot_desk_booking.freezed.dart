// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hot_desk_booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HotDeskBooking _$HotDeskBookingFromJson(Map<String, dynamic> json) {
  return _HotDeskBooking.fromJson(json);
}

/// @nodoc
mixin _$HotDeskBooking {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get workspaceId => throw _privateConstructorUsedError;
  String get deskId => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get startAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get endAt => throw _privateConstructorUsedError;
  @HotDeskBookingStatusConverter()
  HotDeskBookingStatus get status => throw _privateConstructorUsedError;
  @HotDeskBookingSourceConverter()
  HotDeskBookingSource get source => throw _privateConstructorUsedError;
  String? get purpose => throw _privateConstructorUsedError;
  @NullableTimestampConverter()
  DateTime? get checkInAt => throw _privateConstructorUsedError;
  @NullableTimestampConverter()
  DateTime? get checkOutAt => throw _privateConstructorUsedError;
  @NullableTimestampConverter()
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  String? get cancelledBy => throw _privateConstructorUsedError;
  String? get cancellationReason => throw _privateConstructorUsedError;
  String? get repeatSeriesId => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this HotDeskBooking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HotDeskBooking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HotDeskBookingCopyWith<HotDeskBooking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HotDeskBookingCopyWith<$Res> {
  factory $HotDeskBookingCopyWith(
    HotDeskBooking value,
    $Res Function(HotDeskBooking) then,
  ) = _$HotDeskBookingCopyWithImpl<$Res, HotDeskBooking>;
  @useResult
  $Res call({
    String id,
    String userId,
    String workspaceId,
    String deskId,
    @TimestampConverter() DateTime startAt,
    @TimestampConverter() DateTime endAt,
    @HotDeskBookingStatusConverter() HotDeskBookingStatus status,
    @HotDeskBookingSourceConverter() HotDeskBookingSource source,
    String? purpose,
    @NullableTimestampConverter() DateTime? checkInAt,
    @NullableTimestampConverter() DateTime? checkOutAt,
    @NullableTimestampConverter() DateTime? cancelledAt,
    String? cancelledBy,
    String? cancellationReason,
    String? repeatSeriesId,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
  });
}

/// @nodoc
class _$HotDeskBookingCopyWithImpl<$Res, $Val extends HotDeskBooking>
    implements $HotDeskBookingCopyWith<$Res> {
  _$HotDeskBookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HotDeskBooking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? workspaceId = null,
    Object? deskId = null,
    Object? startAt = null,
    Object? endAt = null,
    Object? status = null,
    Object? source = null,
    Object? purpose = freezed,
    Object? checkInAt = freezed,
    Object? checkOutAt = freezed,
    Object? cancelledAt = freezed,
    Object? cancelledBy = freezed,
    Object? cancellationReason = freezed,
    Object? repeatSeriesId = freezed,
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
            workspaceId: null == workspaceId
                ? _value.workspaceId
                : workspaceId // ignore: cast_nullable_to_non_nullable
                      as String,
            deskId: null == deskId
                ? _value.deskId
                : deskId // ignore: cast_nullable_to_non_nullable
                      as String,
            startAt: null == startAt
                ? _value.startAt
                : startAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endAt: null == endAt
                ? _value.endAt
                : endAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as HotDeskBookingStatus,
            source: null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as HotDeskBookingSource,
            purpose: freezed == purpose
                ? _value.purpose
                : purpose // ignore: cast_nullable_to_non_nullable
                      as String?,
            checkInAt: freezed == checkInAt
                ? _value.checkInAt
                : checkInAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            checkOutAt: freezed == checkOutAt
                ? _value.checkOutAt
                : checkOutAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            cancelledAt: freezed == cancelledAt
                ? _value.cancelledAt
                : cancelledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            cancelledBy: freezed == cancelledBy
                ? _value.cancelledBy
                : cancelledBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            cancellationReason: freezed == cancellationReason
                ? _value.cancellationReason
                : cancellationReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            repeatSeriesId: freezed == repeatSeriesId
                ? _value.repeatSeriesId
                : repeatSeriesId // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$HotDeskBookingImplCopyWith<$Res>
    implements $HotDeskBookingCopyWith<$Res> {
  factory _$$HotDeskBookingImplCopyWith(
    _$HotDeskBookingImpl value,
    $Res Function(_$HotDeskBookingImpl) then,
  ) = __$$HotDeskBookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String workspaceId,
    String deskId,
    @TimestampConverter() DateTime startAt,
    @TimestampConverter() DateTime endAt,
    @HotDeskBookingStatusConverter() HotDeskBookingStatus status,
    @HotDeskBookingSourceConverter() HotDeskBookingSource source,
    String? purpose,
    @NullableTimestampConverter() DateTime? checkInAt,
    @NullableTimestampConverter() DateTime? checkOutAt,
    @NullableTimestampConverter() DateTime? cancelledAt,
    String? cancelledBy,
    String? cancellationReason,
    String? repeatSeriesId,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
  });
}

/// @nodoc
class __$$HotDeskBookingImplCopyWithImpl<$Res>
    extends _$HotDeskBookingCopyWithImpl<$Res, _$HotDeskBookingImpl>
    implements _$$HotDeskBookingImplCopyWith<$Res> {
  __$$HotDeskBookingImplCopyWithImpl(
    _$HotDeskBookingImpl _value,
    $Res Function(_$HotDeskBookingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HotDeskBooking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? workspaceId = null,
    Object? deskId = null,
    Object? startAt = null,
    Object? endAt = null,
    Object? status = null,
    Object? source = null,
    Object? purpose = freezed,
    Object? checkInAt = freezed,
    Object? checkOutAt = freezed,
    Object? cancelledAt = freezed,
    Object? cancelledBy = freezed,
    Object? cancellationReason = freezed,
    Object? repeatSeriesId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$HotDeskBookingImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        workspaceId: null == workspaceId
            ? _value.workspaceId
            : workspaceId // ignore: cast_nullable_to_non_nullable
                  as String,
        deskId: null == deskId
            ? _value.deskId
            : deskId // ignore: cast_nullable_to_non_nullable
                  as String,
        startAt: null == startAt
            ? _value.startAt
            : startAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endAt: null == endAt
            ? _value.endAt
            : endAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as HotDeskBookingStatus,
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as HotDeskBookingSource,
        purpose: freezed == purpose
            ? _value.purpose
            : purpose // ignore: cast_nullable_to_non_nullable
                  as String?,
        checkInAt: freezed == checkInAt
            ? _value.checkInAt
            : checkInAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        checkOutAt: freezed == checkOutAt
            ? _value.checkOutAt
            : checkOutAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        cancelledAt: freezed == cancelledAt
            ? _value.cancelledAt
            : cancelledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        cancelledBy: freezed == cancelledBy
            ? _value.cancelledBy
            : cancelledBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        cancellationReason: freezed == cancellationReason
            ? _value.cancellationReason
            : cancellationReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        repeatSeriesId: freezed == repeatSeriesId
            ? _value.repeatSeriesId
            : repeatSeriesId // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$HotDeskBookingImpl implements _HotDeskBooking {
  const _$HotDeskBookingImpl({
    required this.id,
    required this.userId,
    required this.workspaceId,
    required this.deskId,
    @TimestampConverter() required this.startAt,
    @TimestampConverter() required this.endAt,
    @HotDeskBookingStatusConverter() required this.status,
    @HotDeskBookingSourceConverter() required this.source,
    this.purpose,
    @NullableTimestampConverter() this.checkInAt,
    @NullableTimestampConverter() this.checkOutAt,
    @NullableTimestampConverter() this.cancelledAt,
    this.cancelledBy,
    this.cancellationReason,
    this.repeatSeriesId,
    @TimestampConverter() required this.createdAt,
    @TimestampConverter() required this.updatedAt,
  });

  factory _$HotDeskBookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$HotDeskBookingImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String workspaceId;
  @override
  final String deskId;
  @override
  @TimestampConverter()
  final DateTime startAt;
  @override
  @TimestampConverter()
  final DateTime endAt;
  @override
  @HotDeskBookingStatusConverter()
  final HotDeskBookingStatus status;
  @override
  @HotDeskBookingSourceConverter()
  final HotDeskBookingSource source;
  @override
  final String? purpose;
  @override
  @NullableTimestampConverter()
  final DateTime? checkInAt;
  @override
  @NullableTimestampConverter()
  final DateTime? checkOutAt;
  @override
  @NullableTimestampConverter()
  final DateTime? cancelledAt;
  @override
  final String? cancelledBy;
  @override
  final String? cancellationReason;
  @override
  final String? repeatSeriesId;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;

  @override
  String toString() {
    return 'HotDeskBooking(id: $id, userId: $userId, workspaceId: $workspaceId, deskId: $deskId, startAt: $startAt, endAt: $endAt, status: $status, source: $source, purpose: $purpose, checkInAt: $checkInAt, checkOutAt: $checkOutAt, cancelledAt: $cancelledAt, cancelledBy: $cancelledBy, cancellationReason: $cancellationReason, repeatSeriesId: $repeatSeriesId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HotDeskBookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.deskId, deskId) || other.deskId == deskId) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.purpose, purpose) || other.purpose == purpose) &&
            (identical(other.checkInAt, checkInAt) ||
                other.checkInAt == checkInAt) &&
            (identical(other.checkOutAt, checkOutAt) ||
                other.checkOutAt == checkOutAt) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.cancelledBy, cancelledBy) ||
                other.cancelledBy == cancelledBy) &&
            (identical(other.cancellationReason, cancellationReason) ||
                other.cancellationReason == cancellationReason) &&
            (identical(other.repeatSeriesId, repeatSeriesId) ||
                other.repeatSeriesId == repeatSeriesId) &&
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
    workspaceId,
    deskId,
    startAt,
    endAt,
    status,
    source,
    purpose,
    checkInAt,
    checkOutAt,
    cancelledAt,
    cancelledBy,
    cancellationReason,
    repeatSeriesId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of HotDeskBooking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HotDeskBookingImplCopyWith<_$HotDeskBookingImpl> get copyWith =>
      __$$HotDeskBookingImplCopyWithImpl<_$HotDeskBookingImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HotDeskBookingImplToJson(this);
  }
}

abstract class _HotDeskBooking implements HotDeskBooking {
  const factory _HotDeskBooking({
    required final String id,
    required final String userId,
    required final String workspaceId,
    required final String deskId,
    @TimestampConverter() required final DateTime startAt,
    @TimestampConverter() required final DateTime endAt,
    @HotDeskBookingStatusConverter() required final HotDeskBookingStatus status,
    @HotDeskBookingSourceConverter() required final HotDeskBookingSource source,
    final String? purpose,
    @NullableTimestampConverter() final DateTime? checkInAt,
    @NullableTimestampConverter() final DateTime? checkOutAt,
    @NullableTimestampConverter() final DateTime? cancelledAt,
    final String? cancelledBy,
    final String? cancellationReason,
    final String? repeatSeriesId,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampConverter() required final DateTime updatedAt,
  }) = _$HotDeskBookingImpl;

  factory _HotDeskBooking.fromJson(Map<String, dynamic> json) =
      _$HotDeskBookingImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get workspaceId;
  @override
  String get deskId;
  @override
  @TimestampConverter()
  DateTime get startAt;
  @override
  @TimestampConverter()
  DateTime get endAt;
  @override
  @HotDeskBookingStatusConverter()
  HotDeskBookingStatus get status;
  @override
  @HotDeskBookingSourceConverter()
  HotDeskBookingSource get source;
  @override
  String? get purpose;
  @override
  @NullableTimestampConverter()
  DateTime? get checkInAt;
  @override
  @NullableTimestampConverter()
  DateTime? get checkOutAt;
  @override
  @NullableTimestampConverter()
  DateTime? get cancelledAt;
  @override
  String? get cancelledBy;
  @override
  String? get cancellationReason;
  @override
  String? get repeatSeriesId;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;

  /// Create a copy of HotDeskBooking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HotDeskBookingImplCopyWith<_$HotDeskBookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
