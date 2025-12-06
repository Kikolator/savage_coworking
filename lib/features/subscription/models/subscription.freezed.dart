// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) {
  return _Subscription.fromJson(json);
}

/// @nodoc
mixin _$Subscription {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get planId => throw _privateConstructorUsedError;
  String get planName => throw _privateConstructorUsedError;
  @SubscriptionStatusConverter()
  SubscriptionStatus get status => throw _privateConstructorUsedError;
  String? get stripeSubscriptionId => throw _privateConstructorUsedError;
  String get stripeCustomerId => throw _privateConstructorUsedError;
  String? get stripePaymentIntentId => throw _privateConstructorUsedError;
  bool get renewsAutomatically => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get currentPeriodStart => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get currentPeriodEnd => throw _privateConstructorUsedError;
  bool get cancelAtPeriodEnd => throw _privateConstructorUsedError;
  double get deskHours => throw _privateConstructorUsedError;
  double get meetingRoomHours => throw _privateConstructorUsedError;
  double get deskHoursUsed => throw _privateConstructorUsedError;
  double get meetingRoomHoursUsed => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Subscription to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionCopyWith<Subscription> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionCopyWith<$Res> {
  factory $SubscriptionCopyWith(
    Subscription value,
    $Res Function(Subscription) then,
  ) = _$SubscriptionCopyWithImpl<$Res, Subscription>;
  @useResult
  $Res call({
    String id,
    String userId,
    String planId,
    String planName,
    @SubscriptionStatusConverter() SubscriptionStatus status,
    String? stripeSubscriptionId,
    String stripeCustomerId,
    String? stripePaymentIntentId,
    bool renewsAutomatically,
    @TimestampConverter() DateTime currentPeriodStart,
    @TimestampConverter() DateTime currentPeriodEnd,
    bool cancelAtPeriodEnd,
    double deskHours,
    double meetingRoomHours,
    double deskHoursUsed,
    double meetingRoomHoursUsed,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
  });
}

/// @nodoc
class _$SubscriptionCopyWithImpl<$Res, $Val extends Subscription>
    implements $SubscriptionCopyWith<$Res> {
  _$SubscriptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? planId = null,
    Object? planName = null,
    Object? status = null,
    Object? stripeSubscriptionId = freezed,
    Object? stripeCustomerId = null,
    Object? stripePaymentIntentId = freezed,
    Object? renewsAutomatically = null,
    Object? currentPeriodStart = null,
    Object? currentPeriodEnd = null,
    Object? cancelAtPeriodEnd = null,
    Object? deskHours = null,
    Object? meetingRoomHours = null,
    Object? deskHoursUsed = null,
    Object? meetingRoomHoursUsed = null,
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
            planName: null == planName
                ? _value.planName
                : planName // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as SubscriptionStatus,
            stripeSubscriptionId: freezed == stripeSubscriptionId
                ? _value.stripeSubscriptionId
                : stripeSubscriptionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            stripeCustomerId: null == stripeCustomerId
                ? _value.stripeCustomerId
                : stripeCustomerId // ignore: cast_nullable_to_non_nullable
                      as String,
            stripePaymentIntentId: freezed == stripePaymentIntentId
                ? _value.stripePaymentIntentId
                : stripePaymentIntentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            renewsAutomatically: null == renewsAutomatically
                ? _value.renewsAutomatically
                : renewsAutomatically // ignore: cast_nullable_to_non_nullable
                      as bool,
            currentPeriodStart: null == currentPeriodStart
                ? _value.currentPeriodStart
                : currentPeriodStart // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            currentPeriodEnd: null == currentPeriodEnd
                ? _value.currentPeriodEnd
                : currentPeriodEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            cancelAtPeriodEnd: null == cancelAtPeriodEnd
                ? _value.cancelAtPeriodEnd
                : cancelAtPeriodEnd // ignore: cast_nullable_to_non_nullable
                      as bool,
            deskHours: null == deskHours
                ? _value.deskHours
                : deskHours // ignore: cast_nullable_to_non_nullable
                      as double,
            meetingRoomHours: null == meetingRoomHours
                ? _value.meetingRoomHours
                : meetingRoomHours // ignore: cast_nullable_to_non_nullable
                      as double,
            deskHoursUsed: null == deskHoursUsed
                ? _value.deskHoursUsed
                : deskHoursUsed // ignore: cast_nullable_to_non_nullable
                      as double,
            meetingRoomHoursUsed: null == meetingRoomHoursUsed
                ? _value.meetingRoomHoursUsed
                : meetingRoomHoursUsed // ignore: cast_nullable_to_non_nullable
                      as double,
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
abstract class _$$SubscriptionImplCopyWith<$Res>
    implements $SubscriptionCopyWith<$Res> {
  factory _$$SubscriptionImplCopyWith(
    _$SubscriptionImpl value,
    $Res Function(_$SubscriptionImpl) then,
  ) = __$$SubscriptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String planId,
    String planName,
    @SubscriptionStatusConverter() SubscriptionStatus status,
    String? stripeSubscriptionId,
    String stripeCustomerId,
    String? stripePaymentIntentId,
    bool renewsAutomatically,
    @TimestampConverter() DateTime currentPeriodStart,
    @TimestampConverter() DateTime currentPeriodEnd,
    bool cancelAtPeriodEnd,
    double deskHours,
    double meetingRoomHours,
    double deskHoursUsed,
    double meetingRoomHoursUsed,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
  });
}

/// @nodoc
class __$$SubscriptionImplCopyWithImpl<$Res>
    extends _$SubscriptionCopyWithImpl<$Res, _$SubscriptionImpl>
    implements _$$SubscriptionImplCopyWith<$Res> {
  __$$SubscriptionImplCopyWithImpl(
    _$SubscriptionImpl _value,
    $Res Function(_$SubscriptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? planId = null,
    Object? planName = null,
    Object? status = null,
    Object? stripeSubscriptionId = freezed,
    Object? stripeCustomerId = null,
    Object? stripePaymentIntentId = freezed,
    Object? renewsAutomatically = null,
    Object? currentPeriodStart = null,
    Object? currentPeriodEnd = null,
    Object? cancelAtPeriodEnd = null,
    Object? deskHours = null,
    Object? meetingRoomHours = null,
    Object? deskHoursUsed = null,
    Object? meetingRoomHoursUsed = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$SubscriptionImpl(
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
        planName: null == planName
            ? _value.planName
            : planName // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as SubscriptionStatus,
        stripeSubscriptionId: freezed == stripeSubscriptionId
            ? _value.stripeSubscriptionId
            : stripeSubscriptionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        stripeCustomerId: null == stripeCustomerId
            ? _value.stripeCustomerId
            : stripeCustomerId // ignore: cast_nullable_to_non_nullable
                  as String,
        stripePaymentIntentId: freezed == stripePaymentIntentId
            ? _value.stripePaymentIntentId
            : stripePaymentIntentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        renewsAutomatically: null == renewsAutomatically
            ? _value.renewsAutomatically
            : renewsAutomatically // ignore: cast_nullable_to_non_nullable
                  as bool,
        currentPeriodStart: null == currentPeriodStart
            ? _value.currentPeriodStart
            : currentPeriodStart // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        currentPeriodEnd: null == currentPeriodEnd
            ? _value.currentPeriodEnd
            : currentPeriodEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        cancelAtPeriodEnd: null == cancelAtPeriodEnd
            ? _value.cancelAtPeriodEnd
            : cancelAtPeriodEnd // ignore: cast_nullable_to_non_nullable
                  as bool,
        deskHours: null == deskHours
            ? _value.deskHours
            : deskHours // ignore: cast_nullable_to_non_nullable
                  as double,
        meetingRoomHours: null == meetingRoomHours
            ? _value.meetingRoomHours
            : meetingRoomHours // ignore: cast_nullable_to_non_nullable
                  as double,
        deskHoursUsed: null == deskHoursUsed
            ? _value.deskHoursUsed
            : deskHoursUsed // ignore: cast_nullable_to_non_nullable
                  as double,
        meetingRoomHoursUsed: null == meetingRoomHoursUsed
            ? _value.meetingRoomHoursUsed
            : meetingRoomHoursUsed // ignore: cast_nullable_to_non_nullable
                  as double,
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
class _$SubscriptionImpl implements _Subscription {
  const _$SubscriptionImpl({
    required this.id,
    required this.userId,
    required this.planId,
    required this.planName,
    @SubscriptionStatusConverter() required this.status,
    this.stripeSubscriptionId,
    required this.stripeCustomerId,
    this.stripePaymentIntentId,
    required this.renewsAutomatically,
    @TimestampConverter() required this.currentPeriodStart,
    @TimestampConverter() required this.currentPeriodEnd,
    required this.cancelAtPeriodEnd,
    required this.deskHours,
    required this.meetingRoomHours,
    required this.deskHoursUsed,
    required this.meetingRoomHoursUsed,
    @TimestampConverter() required this.createdAt,
    @TimestampConverter() required this.updatedAt,
  });

  factory _$SubscriptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String planId;
  @override
  final String planName;
  @override
  @SubscriptionStatusConverter()
  final SubscriptionStatus status;
  @override
  final String? stripeSubscriptionId;
  @override
  final String stripeCustomerId;
  @override
  final String? stripePaymentIntentId;
  @override
  final bool renewsAutomatically;
  @override
  @TimestampConverter()
  final DateTime currentPeriodStart;
  @override
  @TimestampConverter()
  final DateTime currentPeriodEnd;
  @override
  final bool cancelAtPeriodEnd;
  @override
  final double deskHours;
  @override
  final double meetingRoomHours;
  @override
  final double deskHoursUsed;
  @override
  final double meetingRoomHoursUsed;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Subscription(id: $id, userId: $userId, planId: $planId, planName: $planName, status: $status, stripeSubscriptionId: $stripeSubscriptionId, stripeCustomerId: $stripeCustomerId, stripePaymentIntentId: $stripePaymentIntentId, renewsAutomatically: $renewsAutomatically, currentPeriodStart: $currentPeriodStart, currentPeriodEnd: $currentPeriodEnd, cancelAtPeriodEnd: $cancelAtPeriodEnd, deskHours: $deskHours, meetingRoomHours: $meetingRoomHours, deskHoursUsed: $deskHoursUsed, meetingRoomHoursUsed: $meetingRoomHoursUsed, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.planName, planName) ||
                other.planName == planName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.stripeSubscriptionId, stripeSubscriptionId) ||
                other.stripeSubscriptionId == stripeSubscriptionId) &&
            (identical(other.stripeCustomerId, stripeCustomerId) ||
                other.stripeCustomerId == stripeCustomerId) &&
            (identical(other.stripePaymentIntentId, stripePaymentIntentId) ||
                other.stripePaymentIntentId == stripePaymentIntentId) &&
            (identical(other.renewsAutomatically, renewsAutomatically) ||
                other.renewsAutomatically == renewsAutomatically) &&
            (identical(other.currentPeriodStart, currentPeriodStart) ||
                other.currentPeriodStart == currentPeriodStart) &&
            (identical(other.currentPeriodEnd, currentPeriodEnd) ||
                other.currentPeriodEnd == currentPeriodEnd) &&
            (identical(other.cancelAtPeriodEnd, cancelAtPeriodEnd) ||
                other.cancelAtPeriodEnd == cancelAtPeriodEnd) &&
            (identical(other.deskHours, deskHours) ||
                other.deskHours == deskHours) &&
            (identical(other.meetingRoomHours, meetingRoomHours) ||
                other.meetingRoomHours == meetingRoomHours) &&
            (identical(other.deskHoursUsed, deskHoursUsed) ||
                other.deskHoursUsed == deskHoursUsed) &&
            (identical(other.meetingRoomHoursUsed, meetingRoomHoursUsed) ||
                other.meetingRoomHoursUsed == meetingRoomHoursUsed) &&
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
    planName,
    status,
    stripeSubscriptionId,
    stripeCustomerId,
    stripePaymentIntentId,
    renewsAutomatically,
    currentPeriodStart,
    currentPeriodEnd,
    cancelAtPeriodEnd,
    deskHours,
    meetingRoomHours,
    deskHoursUsed,
    meetingRoomHoursUsed,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      __$$SubscriptionImplCopyWithImpl<_$SubscriptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionImplToJson(this);
  }
}

abstract class _Subscription implements Subscription {
  const factory _Subscription({
    required final String id,
    required final String userId,
    required final String planId,
    required final String planName,
    @SubscriptionStatusConverter() required final SubscriptionStatus status,
    final String? stripeSubscriptionId,
    required final String stripeCustomerId,
    final String? stripePaymentIntentId,
    required final bool renewsAutomatically,
    @TimestampConverter() required final DateTime currentPeriodStart,
    @TimestampConverter() required final DateTime currentPeriodEnd,
    required final bool cancelAtPeriodEnd,
    required final double deskHours,
    required final double meetingRoomHours,
    required final double deskHoursUsed,
    required final double meetingRoomHoursUsed,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampConverter() required final DateTime updatedAt,
  }) = _$SubscriptionImpl;

  factory _Subscription.fromJson(Map<String, dynamic> json) =
      _$SubscriptionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get planId;
  @override
  String get planName;
  @override
  @SubscriptionStatusConverter()
  SubscriptionStatus get status;
  @override
  String? get stripeSubscriptionId;
  @override
  String get stripeCustomerId;
  @override
  String? get stripePaymentIntentId;
  @override
  bool get renewsAutomatically;
  @override
  @TimestampConverter()
  DateTime get currentPeriodStart;
  @override
  @TimestampConverter()
  DateTime get currentPeriodEnd;
  @override
  bool get cancelAtPeriodEnd;
  @override
  double get deskHours;
  @override
  double get meetingRoomHours;
  @override
  double get deskHoursUsed;
  @override
  double get meetingRoomHoursUsed;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
