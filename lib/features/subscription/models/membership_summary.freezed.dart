// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MembershipSummary _$MembershipSummaryFromJson(Map<String, dynamic> json) {
  return _MembershipSummary.fromJson(json);
}

/// @nodoc
mixin _$MembershipSummary {
  String? get activeSubscriptionId => throw _privateConstructorUsedError;
  String? get planId => throw _privateConstructorUsedError;
  String? get planName => throw _privateConstructorUsedError;
  @SubscriptionStatusConverter()
  SubscriptionStatus? get status => throw _privateConstructorUsedError;
  @NullableTimestampConverter()
  DateTime? get currentPeriodEnd => throw _privateConstructorUsedError;
  int? get deskMinutesRemaining =>
      throw _privateConstructorUsedError; // null = unlimited
  int? get meetingMinutesRemaining =>
      throw _privateConstructorUsedError; // null = unlimited
  int? get remainingDayPassCredits => throw _privateConstructorUsedError;
  @AccessTypeConverter()
  AccessType? get access => throw _privateConstructorUsedError;

  /// Serializes this MembershipSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MembershipSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MembershipSummaryCopyWith<MembershipSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MembershipSummaryCopyWith<$Res> {
  factory $MembershipSummaryCopyWith(
    MembershipSummary value,
    $Res Function(MembershipSummary) then,
  ) = _$MembershipSummaryCopyWithImpl<$Res, MembershipSummary>;
  @useResult
  $Res call({
    String? activeSubscriptionId,
    String? planId,
    String? planName,
    @SubscriptionStatusConverter() SubscriptionStatus? status,
    @NullableTimestampConverter() DateTime? currentPeriodEnd,
    int? deskMinutesRemaining,
    int? meetingMinutesRemaining,
    int? remainingDayPassCredits,
    @AccessTypeConverter() AccessType? access,
  });
}

/// @nodoc
class _$MembershipSummaryCopyWithImpl<$Res, $Val extends MembershipSummary>
    implements $MembershipSummaryCopyWith<$Res> {
  _$MembershipSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MembershipSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeSubscriptionId = freezed,
    Object? planId = freezed,
    Object? planName = freezed,
    Object? status = freezed,
    Object? currentPeriodEnd = freezed,
    Object? deskMinutesRemaining = freezed,
    Object? meetingMinutesRemaining = freezed,
    Object? remainingDayPassCredits = freezed,
    Object? access = freezed,
  }) {
    return _then(
      _value.copyWith(
            activeSubscriptionId: freezed == activeSubscriptionId
                ? _value.activeSubscriptionId
                : activeSubscriptionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            planId: freezed == planId
                ? _value.planId
                : planId // ignore: cast_nullable_to_non_nullable
                      as String?,
            planName: freezed == planName
                ? _value.planName
                : planName // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as SubscriptionStatus?,
            currentPeriodEnd: freezed == currentPeriodEnd
                ? _value.currentPeriodEnd
                : currentPeriodEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            deskMinutesRemaining: freezed == deskMinutesRemaining
                ? _value.deskMinutesRemaining
                : deskMinutesRemaining // ignore: cast_nullable_to_non_nullable
                      as int?,
            meetingMinutesRemaining: freezed == meetingMinutesRemaining
                ? _value.meetingMinutesRemaining
                : meetingMinutesRemaining // ignore: cast_nullable_to_non_nullable
                      as int?,
            remainingDayPassCredits: freezed == remainingDayPassCredits
                ? _value.remainingDayPassCredits
                : remainingDayPassCredits // ignore: cast_nullable_to_non_nullable
                      as int?,
            access: freezed == access
                ? _value.access
                : access // ignore: cast_nullable_to_non_nullable
                      as AccessType?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MembershipSummaryImplCopyWith<$Res>
    implements $MembershipSummaryCopyWith<$Res> {
  factory _$$MembershipSummaryImplCopyWith(
    _$MembershipSummaryImpl value,
    $Res Function(_$MembershipSummaryImpl) then,
  ) = __$$MembershipSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? activeSubscriptionId,
    String? planId,
    String? planName,
    @SubscriptionStatusConverter() SubscriptionStatus? status,
    @NullableTimestampConverter() DateTime? currentPeriodEnd,
    int? deskMinutesRemaining,
    int? meetingMinutesRemaining,
    int? remainingDayPassCredits,
    @AccessTypeConverter() AccessType? access,
  });
}

/// @nodoc
class __$$MembershipSummaryImplCopyWithImpl<$Res>
    extends _$MembershipSummaryCopyWithImpl<$Res, _$MembershipSummaryImpl>
    implements _$$MembershipSummaryImplCopyWith<$Res> {
  __$$MembershipSummaryImplCopyWithImpl(
    _$MembershipSummaryImpl _value,
    $Res Function(_$MembershipSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MembershipSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeSubscriptionId = freezed,
    Object? planId = freezed,
    Object? planName = freezed,
    Object? status = freezed,
    Object? currentPeriodEnd = freezed,
    Object? deskMinutesRemaining = freezed,
    Object? meetingMinutesRemaining = freezed,
    Object? remainingDayPassCredits = freezed,
    Object? access = freezed,
  }) {
    return _then(
      _$MembershipSummaryImpl(
        activeSubscriptionId: freezed == activeSubscriptionId
            ? _value.activeSubscriptionId
            : activeSubscriptionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        planId: freezed == planId
            ? _value.planId
            : planId // ignore: cast_nullable_to_non_nullable
                  as String?,
        planName: freezed == planName
            ? _value.planName
            : planName // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as SubscriptionStatus?,
        currentPeriodEnd: freezed == currentPeriodEnd
            ? _value.currentPeriodEnd
            : currentPeriodEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deskMinutesRemaining: freezed == deskMinutesRemaining
            ? _value.deskMinutesRemaining
            : deskMinutesRemaining // ignore: cast_nullable_to_non_nullable
                  as int?,
        meetingMinutesRemaining: freezed == meetingMinutesRemaining
            ? _value.meetingMinutesRemaining
            : meetingMinutesRemaining // ignore: cast_nullable_to_non_nullable
                  as int?,
        remainingDayPassCredits: freezed == remainingDayPassCredits
            ? _value.remainingDayPassCredits
            : remainingDayPassCredits // ignore: cast_nullable_to_non_nullable
                  as int?,
        access: freezed == access
            ? _value.access
            : access // ignore: cast_nullable_to_non_nullable
                  as AccessType?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MembershipSummaryImpl implements _MembershipSummary {
  const _$MembershipSummaryImpl({
    this.activeSubscriptionId,
    this.planId,
    this.planName,
    @SubscriptionStatusConverter() this.status,
    @NullableTimestampConverter() this.currentPeriodEnd,
    this.deskMinutesRemaining,
    this.meetingMinutesRemaining,
    this.remainingDayPassCredits,
    @AccessTypeConverter() this.access,
  });

  factory _$MembershipSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$MembershipSummaryImplFromJson(json);

  @override
  final String? activeSubscriptionId;
  @override
  final String? planId;
  @override
  final String? planName;
  @override
  @SubscriptionStatusConverter()
  final SubscriptionStatus? status;
  @override
  @NullableTimestampConverter()
  final DateTime? currentPeriodEnd;
  @override
  final int? deskMinutesRemaining;
  // null = unlimited
  @override
  final int? meetingMinutesRemaining;
  // null = unlimited
  @override
  final int? remainingDayPassCredits;
  @override
  @AccessTypeConverter()
  final AccessType? access;

  @override
  String toString() {
    return 'MembershipSummary(activeSubscriptionId: $activeSubscriptionId, planId: $planId, planName: $planName, status: $status, currentPeriodEnd: $currentPeriodEnd, deskMinutesRemaining: $deskMinutesRemaining, meetingMinutesRemaining: $meetingMinutesRemaining, remainingDayPassCredits: $remainingDayPassCredits, access: $access)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MembershipSummaryImpl &&
            (identical(other.activeSubscriptionId, activeSubscriptionId) ||
                other.activeSubscriptionId == activeSubscriptionId) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.planName, planName) ||
                other.planName == planName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currentPeriodEnd, currentPeriodEnd) ||
                other.currentPeriodEnd == currentPeriodEnd) &&
            (identical(other.deskMinutesRemaining, deskMinutesRemaining) ||
                other.deskMinutesRemaining == deskMinutesRemaining) &&
            (identical(
                  other.meetingMinutesRemaining,
                  meetingMinutesRemaining,
                ) ||
                other.meetingMinutesRemaining == meetingMinutesRemaining) &&
            (identical(
                  other.remainingDayPassCredits,
                  remainingDayPassCredits,
                ) ||
                other.remainingDayPassCredits == remainingDayPassCredits) &&
            (identical(other.access, access) || other.access == access));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    activeSubscriptionId,
    planId,
    planName,
    status,
    currentPeriodEnd,
    deskMinutesRemaining,
    meetingMinutesRemaining,
    remainingDayPassCredits,
    access,
  );

  /// Create a copy of MembershipSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MembershipSummaryImplCopyWith<_$MembershipSummaryImpl> get copyWith =>
      __$$MembershipSummaryImplCopyWithImpl<_$MembershipSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MembershipSummaryImplToJson(this);
  }
}

abstract class _MembershipSummary implements MembershipSummary {
  const factory _MembershipSummary({
    final String? activeSubscriptionId,
    final String? planId,
    final String? planName,
    @SubscriptionStatusConverter() final SubscriptionStatus? status,
    @NullableTimestampConverter() final DateTime? currentPeriodEnd,
    final int? deskMinutesRemaining,
    final int? meetingMinutesRemaining,
    final int? remainingDayPassCredits,
    @AccessTypeConverter() final AccessType? access,
  }) = _$MembershipSummaryImpl;

  factory _MembershipSummary.fromJson(Map<String, dynamic> json) =
      _$MembershipSummaryImpl.fromJson;

  @override
  String? get activeSubscriptionId;
  @override
  String? get planId;
  @override
  String? get planName;
  @override
  @SubscriptionStatusConverter()
  SubscriptionStatus? get status;
  @override
  @NullableTimestampConverter()
  DateTime? get currentPeriodEnd;
  @override
  int? get deskMinutesRemaining; // null = unlimited
  @override
  int? get meetingMinutesRemaining; // null = unlimited
  @override
  int? get remainingDayPassCredits;
  @override
  @AccessTypeConverter()
  AccessType? get access;

  /// Create a copy of MembershipSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MembershipSummaryImplCopyWith<_$MembershipSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
