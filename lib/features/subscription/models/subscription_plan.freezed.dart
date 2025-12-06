// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SubscriptionPlan _$SubscriptionPlanFromJson(Map<String, dynamic> json) {
  return _SubscriptionPlan.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionPlan {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError; // Price in cents
  String get currency => throw _privateConstructorUsedError;
  @SubscriptionIntervalConverter()
  SubscriptionInterval get interval => throw _privateConstructorUsedError;
  double get deskHours => throw _privateConstructorUsedError; // 0 = unlimited
  double get meetingRoomHours =>
      throw _privateConstructorUsedError; // 0 = unlimited
  List<String> get features => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get stripePriceId => throw _privateConstructorUsedError;
  String? get stripeProductId => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SubscriptionPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionPlanCopyWith<SubscriptionPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionPlanCopyWith<$Res> {
  factory $SubscriptionPlanCopyWith(
    SubscriptionPlan value,
    $Res Function(SubscriptionPlan) then,
  ) = _$SubscriptionPlanCopyWithImpl<$Res, SubscriptionPlan>;
  @useResult
  $Res call({
    String id,
    String name,
    int price,
    String currency,
    @SubscriptionIntervalConverter() SubscriptionInterval interval,
    double deskHours,
    double meetingRoomHours,
    List<String> features,
    bool isActive,
    String? stripePriceId,
    String? stripeProductId,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
  });
}

/// @nodoc
class _$SubscriptionPlanCopyWithImpl<$Res, $Val extends SubscriptionPlan>
    implements $SubscriptionPlanCopyWith<$Res> {
  _$SubscriptionPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? currency = null,
    Object? interval = null,
    Object? deskHours = null,
    Object? meetingRoomHours = null,
    Object? features = null,
    Object? isActive = null,
    Object? stripePriceId = freezed,
    Object? stripeProductId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as int,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            interval: null == interval
                ? _value.interval
                : interval // ignore: cast_nullable_to_non_nullable
                      as SubscriptionInterval,
            deskHours: null == deskHours
                ? _value.deskHours
                : deskHours // ignore: cast_nullable_to_non_nullable
                      as double,
            meetingRoomHours: null == meetingRoomHours
                ? _value.meetingRoomHours
                : meetingRoomHours // ignore: cast_nullable_to_non_nullable
                      as double,
            features: null == features
                ? _value.features
                : features // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            stripePriceId: freezed == stripePriceId
                ? _value.stripePriceId
                : stripePriceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            stripeProductId: freezed == stripeProductId
                ? _value.stripeProductId
                : stripeProductId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$SubscriptionPlanImplCopyWith<$Res>
    implements $SubscriptionPlanCopyWith<$Res> {
  factory _$$SubscriptionPlanImplCopyWith(
    _$SubscriptionPlanImpl value,
    $Res Function(_$SubscriptionPlanImpl) then,
  ) = __$$SubscriptionPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    int price,
    String currency,
    @SubscriptionIntervalConverter() SubscriptionInterval interval,
    double deskHours,
    double meetingRoomHours,
    List<String> features,
    bool isActive,
    String? stripePriceId,
    String? stripeProductId,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
  });
}

/// @nodoc
class __$$SubscriptionPlanImplCopyWithImpl<$Res>
    extends _$SubscriptionPlanCopyWithImpl<$Res, _$SubscriptionPlanImpl>
    implements _$$SubscriptionPlanImplCopyWith<$Res> {
  __$$SubscriptionPlanImplCopyWithImpl(
    _$SubscriptionPlanImpl _value,
    $Res Function(_$SubscriptionPlanImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubscriptionPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? currency = null,
    Object? interval = null,
    Object? deskHours = null,
    Object? meetingRoomHours = null,
    Object? features = null,
    Object? isActive = null,
    Object? stripePriceId = freezed,
    Object? stripeProductId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$SubscriptionPlanImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as int,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        interval: null == interval
            ? _value.interval
            : interval // ignore: cast_nullable_to_non_nullable
                  as SubscriptionInterval,
        deskHours: null == deskHours
            ? _value.deskHours
            : deskHours // ignore: cast_nullable_to_non_nullable
                  as double,
        meetingRoomHours: null == meetingRoomHours
            ? _value.meetingRoomHours
            : meetingRoomHours // ignore: cast_nullable_to_non_nullable
                  as double,
        features: null == features
            ? _value._features
            : features // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        stripePriceId: freezed == stripePriceId
            ? _value.stripePriceId
            : stripePriceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        stripeProductId: freezed == stripeProductId
            ? _value.stripeProductId
            : stripeProductId // ignore: cast_nullable_to_non_nullable
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
class _$SubscriptionPlanImpl implements _SubscriptionPlan {
  const _$SubscriptionPlanImpl({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    @SubscriptionIntervalConverter() required this.interval,
    required this.deskHours,
    required this.meetingRoomHours,
    required final List<String> features,
    required this.isActive,
    this.stripePriceId,
    this.stripeProductId,
    @TimestampConverter() required this.createdAt,
    @TimestampConverter() required this.updatedAt,
  }) : _features = features;

  factory _$SubscriptionPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionPlanImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int price;
  // Price in cents
  @override
  final String currency;
  @override
  @SubscriptionIntervalConverter()
  final SubscriptionInterval interval;
  @override
  final double deskHours;
  // 0 = unlimited
  @override
  final double meetingRoomHours;
  // 0 = unlimited
  final List<String> _features;
  // 0 = unlimited
  @override
  List<String> get features {
    if (_features is EqualUnmodifiableListView) return _features;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_features);
  }

  @override
  final bool isActive;
  @override
  final String? stripePriceId;
  @override
  final String? stripeProductId;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;

  @override
  String toString() {
    return 'SubscriptionPlan(id: $id, name: $name, price: $price, currency: $currency, interval: $interval, deskHours: $deskHours, meetingRoomHours: $meetingRoomHours, features: $features, isActive: $isActive, stripePriceId: $stripePriceId, stripeProductId: $stripeProductId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.deskHours, deskHours) ||
                other.deskHours == deskHours) &&
            (identical(other.meetingRoomHours, meetingRoomHours) ||
                other.meetingRoomHours == meetingRoomHours) &&
            const DeepCollectionEquality().equals(other._features, _features) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.stripePriceId, stripePriceId) ||
                other.stripePriceId == stripePriceId) &&
            (identical(other.stripeProductId, stripeProductId) ||
                other.stripeProductId == stripeProductId) &&
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
    name,
    price,
    currency,
    interval,
    deskHours,
    meetingRoomHours,
    const DeepCollectionEquality().hash(_features),
    isActive,
    stripePriceId,
    stripeProductId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of SubscriptionPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionPlanImplCopyWith<_$SubscriptionPlanImpl> get copyWith =>
      __$$SubscriptionPlanImplCopyWithImpl<_$SubscriptionPlanImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionPlanImplToJson(this);
  }
}

abstract class _SubscriptionPlan implements SubscriptionPlan {
  const factory _SubscriptionPlan({
    required final String id,
    required final String name,
    required final int price,
    required final String currency,
    @SubscriptionIntervalConverter()
    required final SubscriptionInterval interval,
    required final double deskHours,
    required final double meetingRoomHours,
    required final List<String> features,
    required final bool isActive,
    final String? stripePriceId,
    final String? stripeProductId,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampConverter() required final DateTime updatedAt,
  }) = _$SubscriptionPlanImpl;

  factory _SubscriptionPlan.fromJson(Map<String, dynamic> json) =
      _$SubscriptionPlanImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get price; // Price in cents
  @override
  String get currency;
  @override
  @SubscriptionIntervalConverter()
  SubscriptionInterval get interval;
  @override
  double get deskHours; // 0 = unlimited
  @override
  double get meetingRoomHours; // 0 = unlimited
  @override
  List<String> get features;
  @override
  bool get isActive;
  @override
  String? get stripePriceId;
  @override
  String? get stripeProductId;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;

  /// Create a copy of SubscriptionPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionPlanImplCopyWith<_$SubscriptionPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
