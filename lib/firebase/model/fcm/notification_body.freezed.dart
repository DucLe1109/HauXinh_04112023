// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NotificationBody _$NotificationBodyFromJson(Map<String, dynamic> json) {
  return _NotificationBody.fromJson(json);
}

/// @nodoc
mixin _$NotificationBody {
  String get to => throw _privateConstructorUsedError;
  MessageNotification get notification => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationBodyCopyWith<NotificationBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationBodyCopyWith<$Res> {
  factory $NotificationBodyCopyWith(
          NotificationBody value, $Res Function(NotificationBody) then) =
      _$NotificationBodyCopyWithImpl<$Res, NotificationBody>;
  @useResult
  $Res call({String to, MessageNotification notification});

  $MessageNotificationCopyWith<$Res> get notification;
}

/// @nodoc
class _$NotificationBodyCopyWithImpl<$Res, $Val extends NotificationBody>
    implements $NotificationBodyCopyWith<$Res> {
  _$NotificationBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? to = null,
    Object? notification = null,
  }) {
    return _then(_value.copyWith(
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String,
      notification: null == notification
          ? _value.notification
          : notification // ignore: cast_nullable_to_non_nullable
              as MessageNotification,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MessageNotificationCopyWith<$Res> get notification {
    return $MessageNotificationCopyWith<$Res>(_value.notification, (value) {
      return _then(_value.copyWith(notification: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NotificationBodyImplCopyWith<$Res>
    implements $NotificationBodyCopyWith<$Res> {
  factory _$$NotificationBodyImplCopyWith(_$NotificationBodyImpl value,
          $Res Function(_$NotificationBodyImpl) then) =
      __$$NotificationBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String to, MessageNotification notification});

  @override
  $MessageNotificationCopyWith<$Res> get notification;
}

/// @nodoc
class __$$NotificationBodyImplCopyWithImpl<$Res>
    extends _$NotificationBodyCopyWithImpl<$Res, _$NotificationBodyImpl>
    implements _$$NotificationBodyImplCopyWith<$Res> {
  __$$NotificationBodyImplCopyWithImpl(_$NotificationBodyImpl _value,
      $Res Function(_$NotificationBodyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? to = null,
    Object? notification = null,
  }) {
    return _then(_$NotificationBodyImpl(
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String,
      notification: null == notification
          ? _value.notification
          : notification // ignore: cast_nullable_to_non_nullable
              as MessageNotification,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationBodyImpl implements _NotificationBody {
  const _$NotificationBodyImpl({required this.to, required this.notification});

  factory _$NotificationBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationBodyImplFromJson(json);

  @override
  final String to;
  @override
  final MessageNotification notification;

  @override
  String toString() {
    return 'NotificationBody(to: $to, notification: $notification)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationBodyImpl &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.notification, notification) ||
                other.notification == notification));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, to, notification);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationBodyImplCopyWith<_$NotificationBodyImpl> get copyWith =>
      __$$NotificationBodyImplCopyWithImpl<_$NotificationBodyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationBodyImplToJson(
      this,
    );
  }
}

abstract class _NotificationBody implements NotificationBody {
  const factory _NotificationBody(
          {required final String to,
          required final MessageNotification notification}) =
      _$NotificationBodyImpl;

  factory _NotificationBody.fromJson(Map<String, dynamic> json) =
      _$NotificationBodyImpl.fromJson;

  @override
  String get to;
  @override
  MessageNotification get notification;
  @override
  @JsonKey(ignore: true)
  _$$NotificationBodyImplCopyWith<_$NotificationBodyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
