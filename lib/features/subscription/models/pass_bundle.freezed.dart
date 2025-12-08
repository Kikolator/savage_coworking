// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pass_bundle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PassBundle _$PassBundleFromJson(Map<String, dynamic> json) {
  return _PassBundle.fromJson(json);
}

/// @nodoc
mixin _$PassBundle {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get planId => throw _privateConstructorUsedError;
  @PassBundleStatusConverter()
  PassBundleStatus get status => throw _privateConstructorUsedError;
  int get totalCredits => throw _privateConstructorUsedError;
  int get remainingCredits => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get validFrom => throw _privateConstructorUsedError;
  @NullableTimestampConverter()
  DateTime? get validUntil => throw _privateConstructorUsedError;
  Access get access => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PassBundle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PassBundle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PassBundleCopyWith<PassBundle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PassBundleCopyWith<$Res> {
  factory $PassBundleCopyWith(
    PassBundle value,
    $Res Function(PassBundle) then,
  ) = _$PassBundleCopyWithImpl<$Res, PassBundle>;
  @useResult
  $Res call({
    String id,
    String userId,
    String planId,
    @PassBundleStatusConverter() PassBundleStatus status,
    int totalCredits,
    int remainingCredits,
    @TimestampConverter() DateTime validFrom,
    @NullableTimestampConverter() DateTime? validUntil,
    Access access,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
  });

  $AccessCopyWith<$Res> get access;
}

/// @nodoc
class _$PassBundleCopyWithImpl<$Res, $Val extends PassBundle>
    implements $PassBundleCopyWith<$Res> {
  _$PassBundleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PassBundle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? planId = null,
    Object? status = null,
    Object? totalCredits = null,
    Object? remainingCredits = null,
    Object? validFrom = null,
    Object? validUntil = freezed,
    Object? access = null,
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
            planId: null == planId
                ? _value.planId
                : planId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PassBundleStatus,
            totalCredits: null == totalCredits
                ? _value.totalCredits
                : totalCredits // ignore: cast_nullable_to_non_nullable
                      as int,
            remainingCredits: null == remainingCredits
                ? _value.remainingCredits
                : remainingCredits // ignore: cast_nullable_to_non_nullable
                      as int,
            validFrom: null == validFrom
                ? _value.validFrom
                : validFrom // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            validUntil: freezed == validUntil
                ? _value.validUntil
                : validUntil // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            access: null == access
                ? _value.access
                : access // ignore: cast_nullable_to_non_nullable
                      as Access,
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

  /// Create a copy of PassBundle
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
abstract class _$$PassBundleImplCopyWith<$Res>
    implements $PassBundleCopyWith<$Res> {
  factory _$$PassBundleImplCopyWith(
    _$PassBundleImpl value,
    $Res Function(_$PassBundleImpl) then,
  ) = __$$PassBundleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String planId,
    @PassBundleStatusConverter() PassBundleStatus status,
    int totalCredits,
    int remainingCredits,
    @TimestampConverter() DateTime validFrom,
    @NullableTimestampConverter() DateTime? validUntil,
    Access access,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
  });

  @override
  $AccessCopyWith<$Res> get access;
}

/// @nodoc
class __$$PassBundleImplCopyWithImpl<$Res>
    extends _$PassBundleCopyWithImpl<$Res, _$PassBundleImpl>
    implements _$$PassBundleImplCopyWith<$Res> {
  __$$PassBundleImplCopyWithImpl(
    _$PassBundleImpl _value,
    $Res Function(_$PassBundleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PassBundle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? planId = null,
    Object? status = null,
    Object? totalCredits = null,
    Object? remainingCredits = null,
    Object? validFrom = null,
    Object? validUntil = freezed,
    Object? access = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$PassBundleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        planId: null == planId
            ? _value.planId
            : planId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PassBundleStatus,
        totalCredits: null == totalCredits
            ? _value.totalCredits
            : totalCredits // ignore: cast_nullable_to_non_nullable
                  as int,
        remainingCredits: null == remainingCredits
            ? _value.remainingCredits
            : remainingCredits // ignore: cast_nullable_to_non_nullable
                  as int,
        validFrom: null == validFrom
            ? _value.validFrom
            : validFrom // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        validUntil: freezed == validUntil
            ? _value.validUntil
            : validUntil // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        access: null == access
            ? _value.access
            : access // ignore: cast_nullable_to_non_nullable
                  as Access,
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
class _$PassBundleImpl implements _PassBundle {
  const _$PassBundleImpl({
    required this.id,
    required this.userId,
    required this.planId,
    @PassBundleStatusConverter() required this.status,
    required this.totalCredits,
    required this.remainingCredits,
    @TimestampConverter() required this.validFrom,
    @NullableTimestampConverter() this.validUntil,
    required this.access,
    @TimestampConverter() required this.createdAt,
    @TimestampConverter() required this.updatedAt,
  });

  factory _$PassBundleImpl.fromJson(Map<String, dynamic> json) =>
      _$$PassBundleImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String planId;
  @override
  @PassBundleStatusConverter()
  final PassBundleStatus status;
  @override
  final int totalCredits;
  @override
  final int remainingCredits;
  @override
  @TimestampConverter()
  final DateTime validFrom;
  @override
  @NullableTimestampConverter()
  final DateTime? validUntil;
  @override
  final Access access;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PassBundle(id: $id, userId: $userId, planId: $planId, status: $status, totalCredits: $totalCredits, remainingCredits: $remainingCredits, validFrom: $validFrom, validUntil: $validUntil, access: $access, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PassBundleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.totalCredits, totalCredits) ||
                other.totalCredits == totalCredits) &&
            (identical(other.remainingCredits, remainingCredits) ||
                other.remainingCredits == remainingCredits) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            (identical(other.access, access) || other.access == access) &&
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
    planId,
    status,
    totalCredits,
    remainingCredits,
    validFrom,
    validUntil,
    access,
    createdAt,
    updatedAt,
  );

  /// Create a copy of PassBundle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PassBundleImplCopyWith<_$PassBundleImpl> get copyWith =>
      __$$PassBundleImplCopyWithImpl<_$PassBundleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PassBundleImplToJson(this);
  }
}

abstract class _PassBundle implements PassBundle {
  const factory _PassBundle({
    required final String id,
    required final String userId,
    required final String planId,
    @PassBundleStatusConverter() required final PassBundleStatus status,
    required final int totalCredits,
    required final int remainingCredits,
    @TimestampConverter() required final DateTime validFrom,
    @NullableTimestampConverter() final DateTime? validUntil,
    required final Access access,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampConverter() required final DateTime updatedAt,
  }) = _$PassBundleImpl;

  factory _PassBundle.fromJson(Map<String, dynamic> json) =
      _$PassBundleImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get planId;
  @override
  @PassBundleStatusConverter()
  PassBundleStatus get status;
  @override
  int get totalCredits;
  @override
  int get remainingCredits;
  @override
  @TimestampConverter()
  DateTime get validFrom;
  @override
  @NullableTimestampConverter()
  DateTime? get validUntil;
  @override
  Access get access;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;

  /// Create a copy of PassBundle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PassBundleImplCopyWith<_$PassBundleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
