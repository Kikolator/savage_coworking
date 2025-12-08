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
  @SubscriptionStatusConverter()
  SubscriptionStatus get status => throw _privateConstructorUsedError;
  Billing get billing => throw _privateConstructorUsedError;
  Quota get effectiveQuota => throw _privateConstructorUsedError;
  Overrides? get overrides => throw _privateConstructorUsedError;
  Display get display => throw _privateConstructorUsedError;
  String get stripeCustomerId => throw _privateConstructorUsedError;
  String? get stripeSubscriptionId => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get currentPeriodStart => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get currentPeriodEnd => throw _privateConstructorUsedError;
  bool get cancelAtPeriodEnd => throw _privateConstructorUsedError;
  @NullableTimestampConverter()
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  String? get cancelledBy => throw _privateConstructorUsedError;
  String? get assignedDeskId => throw _privateConstructorUsedError;
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
    @SubscriptionStatusConverter() SubscriptionStatus status,
    Billing billing,
    Quota effectiveQuota,
    Overrides? overrides,
    Display display,
    String stripeCustomerId,
    String? stripeSubscriptionId,
    @TimestampConverter() DateTime currentPeriodStart,
    @TimestampConverter() DateTime currentPeriodEnd,
    bool cancelAtPeriodEnd,
    @NullableTimestampConverter() DateTime? cancelledAt,
    String? cancelledBy,
    String? assignedDeskId,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
  });

  $BillingCopyWith<$Res> get billing;
  $QuotaCopyWith<$Res> get effectiveQuota;
  $OverridesCopyWith<$Res>? get overrides;
  $DisplayCopyWith<$Res> get display;
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
    Object? status = null,
    Object? billing = null,
    Object? effectiveQuota = null,
    Object? overrides = freezed,
    Object? display = null,
    Object? stripeCustomerId = null,
    Object? stripeSubscriptionId = freezed,
    Object? currentPeriodStart = null,
    Object? currentPeriodEnd = null,
    Object? cancelAtPeriodEnd = null,
    Object? cancelledAt = freezed,
    Object? cancelledBy = freezed,
    Object? assignedDeskId = freezed,
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
                      as SubscriptionStatus,
            billing: null == billing
                ? _value.billing
                : billing // ignore: cast_nullable_to_non_nullable
                      as Billing,
            effectiveQuota: null == effectiveQuota
                ? _value.effectiveQuota
                : effectiveQuota // ignore: cast_nullable_to_non_nullable
                      as Quota,
            overrides: freezed == overrides
                ? _value.overrides
                : overrides // ignore: cast_nullable_to_non_nullable
                      as Overrides?,
            display: null == display
                ? _value.display
                : display // ignore: cast_nullable_to_non_nullable
                      as Display,
            stripeCustomerId: null == stripeCustomerId
                ? _value.stripeCustomerId
                : stripeCustomerId // ignore: cast_nullable_to_non_nullable
                      as String,
            stripeSubscriptionId: freezed == stripeSubscriptionId
                ? _value.stripeSubscriptionId
                : stripeSubscriptionId // ignore: cast_nullable_to_non_nullable
                      as String?,
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
            cancelledAt: freezed == cancelledAt
                ? _value.cancelledAt
                : cancelledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            cancelledBy: freezed == cancelledBy
                ? _value.cancelledBy
                : cancelledBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            assignedDeskId: freezed == assignedDeskId
                ? _value.assignedDeskId
                : assignedDeskId // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BillingCopyWith<$Res> get billing {
    return $BillingCopyWith<$Res>(_value.billing, (value) {
      return _then(_value.copyWith(billing: value) as $Val);
    });
  }

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuotaCopyWith<$Res> get effectiveQuota {
    return $QuotaCopyWith<$Res>(_value.effectiveQuota, (value) {
      return _then(_value.copyWith(effectiveQuota: value) as $Val);
    });
  }

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OverridesCopyWith<$Res>? get overrides {
    if (_value.overrides == null) {
      return null;
    }

    return $OverridesCopyWith<$Res>(_value.overrides!, (value) {
      return _then(_value.copyWith(overrides: value) as $Val);
    });
  }

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DisplayCopyWith<$Res> get display {
    return $DisplayCopyWith<$Res>(_value.display, (value) {
      return _then(_value.copyWith(display: value) as $Val);
    });
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
    @SubscriptionStatusConverter() SubscriptionStatus status,
    Billing billing,
    Quota effectiveQuota,
    Overrides? overrides,
    Display display,
    String stripeCustomerId,
    String? stripeSubscriptionId,
    @TimestampConverter() DateTime currentPeriodStart,
    @TimestampConverter() DateTime currentPeriodEnd,
    bool cancelAtPeriodEnd,
    @NullableTimestampConverter() DateTime? cancelledAt,
    String? cancelledBy,
    String? assignedDeskId,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
  });

  @override
  $BillingCopyWith<$Res> get billing;
  @override
  $QuotaCopyWith<$Res> get effectiveQuota;
  @override
  $OverridesCopyWith<$Res>? get overrides;
  @override
  $DisplayCopyWith<$Res> get display;
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
    Object? status = null,
    Object? billing = null,
    Object? effectiveQuota = null,
    Object? overrides = freezed,
    Object? display = null,
    Object? stripeCustomerId = null,
    Object? stripeSubscriptionId = freezed,
    Object? currentPeriodStart = null,
    Object? currentPeriodEnd = null,
    Object? cancelAtPeriodEnd = null,
    Object? cancelledAt = freezed,
    Object? cancelledBy = freezed,
    Object? assignedDeskId = freezed,
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
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as SubscriptionStatus,
        billing: null == billing
            ? _value.billing
            : billing // ignore: cast_nullable_to_non_nullable
                  as Billing,
        effectiveQuota: null == effectiveQuota
            ? _value.effectiveQuota
            : effectiveQuota // ignore: cast_nullable_to_non_nullable
                  as Quota,
        overrides: freezed == overrides
            ? _value.overrides
            : overrides // ignore: cast_nullable_to_non_nullable
                  as Overrides?,
        display: null == display
            ? _value.display
            : display // ignore: cast_nullable_to_non_nullable
                  as Display,
        stripeCustomerId: null == stripeCustomerId
            ? _value.stripeCustomerId
            : stripeCustomerId // ignore: cast_nullable_to_non_nullable
                  as String,
        stripeSubscriptionId: freezed == stripeSubscriptionId
            ? _value.stripeSubscriptionId
            : stripeSubscriptionId // ignore: cast_nullable_to_non_nullable
                  as String?,
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
        cancelledAt: freezed == cancelledAt
            ? _value.cancelledAt
            : cancelledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        cancelledBy: freezed == cancelledBy
            ? _value.cancelledBy
            : cancelledBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        assignedDeskId: freezed == assignedDeskId
            ? _value.assignedDeskId
            : assignedDeskId // ignore: cast_nullable_to_non_nullable
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
class _$SubscriptionImpl implements _Subscription {
  const _$SubscriptionImpl({
    required this.id,
    required this.userId,
    required this.planId,
    @SubscriptionStatusConverter() required this.status,
    required this.billing,
    required this.effectiveQuota,
    this.overrides,
    required this.display,
    required this.stripeCustomerId,
    this.stripeSubscriptionId,
    @TimestampConverter() required this.currentPeriodStart,
    @TimestampConverter() required this.currentPeriodEnd,
    required this.cancelAtPeriodEnd,
    @NullableTimestampConverter() this.cancelledAt,
    this.cancelledBy,
    this.assignedDeskId,
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
  @SubscriptionStatusConverter()
  final SubscriptionStatus status;
  @override
  final Billing billing;
  @override
  final Quota effectiveQuota;
  @override
  final Overrides? overrides;
  @override
  final Display display;
  @override
  final String stripeCustomerId;
  @override
  final String? stripeSubscriptionId;
  @override
  @TimestampConverter()
  final DateTime currentPeriodStart;
  @override
  @TimestampConverter()
  final DateTime currentPeriodEnd;
  @override
  final bool cancelAtPeriodEnd;
  @override
  @NullableTimestampConverter()
  final DateTime? cancelledAt;
  @override
  final String? cancelledBy;
  @override
  final String? assignedDeskId;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Subscription(id: $id, userId: $userId, planId: $planId, status: $status, billing: $billing, effectiveQuota: $effectiveQuota, overrides: $overrides, display: $display, stripeCustomerId: $stripeCustomerId, stripeSubscriptionId: $stripeSubscriptionId, currentPeriodStart: $currentPeriodStart, currentPeriodEnd: $currentPeriodEnd, cancelAtPeriodEnd: $cancelAtPeriodEnd, cancelledAt: $cancelledAt, cancelledBy: $cancelledBy, assignedDeskId: $assignedDeskId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.billing, billing) || other.billing == billing) &&
            (identical(other.effectiveQuota, effectiveQuota) ||
                other.effectiveQuota == effectiveQuota) &&
            (identical(other.overrides, overrides) ||
                other.overrides == overrides) &&
            (identical(other.display, display) || other.display == display) &&
            (identical(other.stripeCustomerId, stripeCustomerId) ||
                other.stripeCustomerId == stripeCustomerId) &&
            (identical(other.stripeSubscriptionId, stripeSubscriptionId) ||
                other.stripeSubscriptionId == stripeSubscriptionId) &&
            (identical(other.currentPeriodStart, currentPeriodStart) ||
                other.currentPeriodStart == currentPeriodStart) &&
            (identical(other.currentPeriodEnd, currentPeriodEnd) ||
                other.currentPeriodEnd == currentPeriodEnd) &&
            (identical(other.cancelAtPeriodEnd, cancelAtPeriodEnd) ||
                other.cancelAtPeriodEnd == cancelAtPeriodEnd) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.cancelledBy, cancelledBy) ||
                other.cancelledBy == cancelledBy) &&
            (identical(other.assignedDeskId, assignedDeskId) ||
                other.assignedDeskId == assignedDeskId) &&
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
    billing,
    effectiveQuota,
    overrides,
    display,
    stripeCustomerId,
    stripeSubscriptionId,
    currentPeriodStart,
    currentPeriodEnd,
    cancelAtPeriodEnd,
    cancelledAt,
    cancelledBy,
    assignedDeskId,
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
    @SubscriptionStatusConverter() required final SubscriptionStatus status,
    required final Billing billing,
    required final Quota effectiveQuota,
    final Overrides? overrides,
    required final Display display,
    required final String stripeCustomerId,
    final String? stripeSubscriptionId,
    @TimestampConverter() required final DateTime currentPeriodStart,
    @TimestampConverter() required final DateTime currentPeriodEnd,
    required final bool cancelAtPeriodEnd,
    @NullableTimestampConverter() final DateTime? cancelledAt,
    final String? cancelledBy,
    final String? assignedDeskId,
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
  @SubscriptionStatusConverter()
  SubscriptionStatus get status;
  @override
  Billing get billing;
  @override
  Quota get effectiveQuota;
  @override
  Overrides? get overrides;
  @override
  Display get display;
  @override
  String get stripeCustomerId;
  @override
  String? get stripeSubscriptionId;
  @override
  @TimestampConverter()
  DateTime get currentPeriodStart;
  @override
  @TimestampConverter()
  DateTime get currentPeriodEnd;
  @override
  bool get cancelAtPeriodEnd;
  @override
  @NullableTimestampConverter()
  DateTime? get cancelledAt;
  @override
  String? get cancelledBy;
  @override
  String? get assignedDeskId;
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
