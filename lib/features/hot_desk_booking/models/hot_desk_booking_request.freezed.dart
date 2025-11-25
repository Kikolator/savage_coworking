// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hot_desk_booking_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HotDeskBookingRequest {
  String get workspaceId => throw _privateConstructorUsedError;
  String get deskId => throw _privateConstructorUsedError;
  DateTime get startAt => throw _privateConstructorUsedError;
  DateTime get endAt => throw _privateConstructorUsedError;
  String? get purpose => throw _privateConstructorUsedError;

  /// Create a copy of HotDeskBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HotDeskBookingRequestCopyWith<HotDeskBookingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HotDeskBookingRequestCopyWith<$Res> {
  factory $HotDeskBookingRequestCopyWith(
    HotDeskBookingRequest value,
    $Res Function(HotDeskBookingRequest) then,
  ) = _$HotDeskBookingRequestCopyWithImpl<$Res, HotDeskBookingRequest>;
  @useResult
  $Res call({
    String workspaceId,
    String deskId,
    DateTime startAt,
    DateTime endAt,
    String? purpose,
  });
}

/// @nodoc
class _$HotDeskBookingRequestCopyWithImpl<
  $Res,
  $Val extends HotDeskBookingRequest
>
    implements $HotDeskBookingRequestCopyWith<$Res> {
  _$HotDeskBookingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HotDeskBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workspaceId = null,
    Object? deskId = null,
    Object? startAt = null,
    Object? endAt = null,
    Object? purpose = freezed,
  }) {
    return _then(
      _value.copyWith(
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
            purpose: freezed == purpose
                ? _value.purpose
                : purpose // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HotDeskBookingRequestImplCopyWith<$Res>
    implements $HotDeskBookingRequestCopyWith<$Res> {
  factory _$$HotDeskBookingRequestImplCopyWith(
    _$HotDeskBookingRequestImpl value,
    $Res Function(_$HotDeskBookingRequestImpl) then,
  ) = __$$HotDeskBookingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String workspaceId,
    String deskId,
    DateTime startAt,
    DateTime endAt,
    String? purpose,
  });
}

/// @nodoc
class __$$HotDeskBookingRequestImplCopyWithImpl<$Res>
    extends
        _$HotDeskBookingRequestCopyWithImpl<$Res, _$HotDeskBookingRequestImpl>
    implements _$$HotDeskBookingRequestImplCopyWith<$Res> {
  __$$HotDeskBookingRequestImplCopyWithImpl(
    _$HotDeskBookingRequestImpl _value,
    $Res Function(_$HotDeskBookingRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HotDeskBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workspaceId = null,
    Object? deskId = null,
    Object? startAt = null,
    Object? endAt = null,
    Object? purpose = freezed,
  }) {
    return _then(
      _$HotDeskBookingRequestImpl(
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
        purpose: freezed == purpose
            ? _value.purpose
            : purpose // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$HotDeskBookingRequestImpl implements _HotDeskBookingRequest {
  const _$HotDeskBookingRequestImpl({
    required this.workspaceId,
    required this.deskId,
    required this.startAt,
    required this.endAt,
    this.purpose,
  });

  @override
  final String workspaceId;
  @override
  final String deskId;
  @override
  final DateTime startAt;
  @override
  final DateTime endAt;
  @override
  final String? purpose;

  @override
  String toString() {
    return 'HotDeskBookingRequest(workspaceId: $workspaceId, deskId: $deskId, startAt: $startAt, endAt: $endAt, purpose: $purpose)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HotDeskBookingRequestImpl &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.deskId, deskId) || other.deskId == deskId) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.purpose, purpose) || other.purpose == purpose));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, workspaceId, deskId, startAt, endAt, purpose);

  /// Create a copy of HotDeskBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HotDeskBookingRequestImplCopyWith<_$HotDeskBookingRequestImpl>
  get copyWith =>
      __$$HotDeskBookingRequestImplCopyWithImpl<_$HotDeskBookingRequestImpl>(
        this,
        _$identity,
      );
}

abstract class _HotDeskBookingRequest implements HotDeskBookingRequest {
  const factory _HotDeskBookingRequest({
    required final String workspaceId,
    required final String deskId,
    required final DateTime startAt,
    required final DateTime endAt,
    final String? purpose,
  }) = _$HotDeskBookingRequestImpl;

  @override
  String get workspaceId;
  @override
  String get deskId;
  @override
  DateTime get startAt;
  @override
  DateTime get endAt;
  @override
  String? get purpose;

  /// Create a copy of HotDeskBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HotDeskBookingRequestImplCopyWith<_$HotDeskBookingRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
