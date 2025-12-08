// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'access.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Access _$AccessFromJson(Map<String, dynamic> json) {
  return _Access.fromJson(json);
}

/// @nodoc
mixin _$Access {
  @AccessTypeConverter()
  AccessType get type => throw _privateConstructorUsedError;
  List<int> get allowedDaysOfWeek => throw _privateConstructorUsedError;
  String? get startTime => throw _privateConstructorUsedError;
  String? get endTime => throw _privateConstructorUsedError;

  /// Serializes this Access to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Access
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccessCopyWith<Access> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccessCopyWith<$Res> {
  factory $AccessCopyWith(Access value, $Res Function(Access) then) =
      _$AccessCopyWithImpl<$Res, Access>;
  @useResult
  $Res call({
    @AccessTypeConverter() AccessType type,
    List<int> allowedDaysOfWeek,
    String? startTime,
    String? endTime,
  });
}

/// @nodoc
class _$AccessCopyWithImpl<$Res, $Val extends Access>
    implements $AccessCopyWith<$Res> {
  _$AccessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Access
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? allowedDaysOfWeek = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as AccessType,
            allowedDaysOfWeek: null == allowedDaysOfWeek
                ? _value.allowedDaysOfWeek
                : allowedDaysOfWeek // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            startTime: freezed == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AccessImplCopyWith<$Res> implements $AccessCopyWith<$Res> {
  factory _$$AccessImplCopyWith(
    _$AccessImpl value,
    $Res Function(_$AccessImpl) then,
  ) = __$$AccessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @AccessTypeConverter() AccessType type,
    List<int> allowedDaysOfWeek,
    String? startTime,
    String? endTime,
  });
}

/// @nodoc
class __$$AccessImplCopyWithImpl<$Res>
    extends _$AccessCopyWithImpl<$Res, _$AccessImpl>
    implements _$$AccessImplCopyWith<$Res> {
  __$$AccessImplCopyWithImpl(
    _$AccessImpl _value,
    $Res Function(_$AccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Access
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? allowedDaysOfWeek = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
  }) {
    return _then(
      _$AccessImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as AccessType,
        allowedDaysOfWeek: null == allowedDaysOfWeek
            ? _value._allowedDaysOfWeek
            : allowedDaysOfWeek // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        startTime: freezed == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AccessImpl implements _Access {
  const _$AccessImpl({
    @AccessTypeConverter() required this.type,
    final List<int> allowedDaysOfWeek = const [],
    this.startTime,
    this.endTime,
  }) : _allowedDaysOfWeek = allowedDaysOfWeek;

  factory _$AccessImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccessImplFromJson(json);

  @override
  @AccessTypeConverter()
  final AccessType type;
  final List<int> _allowedDaysOfWeek;
  @override
  @JsonKey()
  List<int> get allowedDaysOfWeek {
    if (_allowedDaysOfWeek is EqualUnmodifiableListView)
      return _allowedDaysOfWeek;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allowedDaysOfWeek);
  }

  @override
  final String? startTime;
  @override
  final String? endTime;

  @override
  String toString() {
    return 'Access(type: $type, allowedDaysOfWeek: $allowedDaysOfWeek, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccessImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(
              other._allowedDaysOfWeek,
              _allowedDaysOfWeek,
            ) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    const DeepCollectionEquality().hash(_allowedDaysOfWeek),
    startTime,
    endTime,
  );

  /// Create a copy of Access
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccessImplCopyWith<_$AccessImpl> get copyWith =>
      __$$AccessImplCopyWithImpl<_$AccessImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccessImplToJson(this);
  }
}

abstract class _Access implements Access {
  const factory _Access({
    @AccessTypeConverter() required final AccessType type,
    final List<int> allowedDaysOfWeek,
    final String? startTime,
    final String? endTime,
  }) = _$AccessImpl;

  factory _Access.fromJson(Map<String, dynamic> json) = _$AccessImpl.fromJson;

  @override
  @AccessTypeConverter()
  AccessType get type;
  @override
  List<int> get allowedDaysOfWeek;
  @override
  String? get startTime;
  @override
  String? get endTime;

  /// Create a copy of Access
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccessImplCopyWith<_$AccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
