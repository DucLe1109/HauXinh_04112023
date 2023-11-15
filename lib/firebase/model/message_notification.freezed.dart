// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MessageNotification _$MessageNotificationFromJson(Map<String, dynamic> json) {
  return _MessageNotification.fromJson(json);
}

/// @nodoc
mixin _$MessageNotification {
  String get android_channel_id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  bool get mutable_content => throw _privateConstructorUsedError;
  String get sound => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageNotificationCopyWith<MessageNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageNotificationCopyWith<$Res> {
  factory $MessageNotificationCopyWith(
          MessageNotification value, $Res Function(MessageNotification) then) =
      _$MessageNotificationCopyWithImpl<$Res, MessageNotification>;
  @useResult
  $Res call(
      {String android_channel_id,
      String title,
      String body,
      bool mutable_content,
      String sound});
}

/// @nodoc
class _$MessageNotificationCopyWithImpl<$Res, $Val extends MessageNotification>
    implements $MessageNotificationCopyWith<$Res> {
  _$MessageNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? android_channel_id = null,
    Object? title = null,
    Object? body = null,
    Object? mutable_content = null,
    Object? sound = null,
  }) {
    return _then(_value.copyWith(
      android_channel_id: null == android_channel_id
          ? _value.android_channel_id
          : android_channel_id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      mutable_content: null == mutable_content
          ? _value.mutable_content
          : mutable_content // ignore: cast_nullable_to_non_nullable
              as bool,
      sound: null == sound
          ? _value.sound
          : sound // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageNotificationImplCopyWith<$Res>
    implements $MessageNotificationCopyWith<$Res> {
  factory _$$MessageNotificationImplCopyWith(_$MessageNotificationImpl value,
          $Res Function(_$MessageNotificationImpl) then) =
      __$$MessageNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String android_channel_id,
      String title,
      String body,
      bool mutable_content,
      String sound});
}

/// @nodoc
class __$$MessageNotificationImplCopyWithImpl<$Res>
    extends _$MessageNotificationCopyWithImpl<$Res, _$MessageNotificationImpl>
    implements _$$MessageNotificationImplCopyWith<$Res> {
  __$$MessageNotificationImplCopyWithImpl(_$MessageNotificationImpl _value,
      $Res Function(_$MessageNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? android_channel_id = null,
    Object? title = null,
    Object? body = null,
    Object? mutable_content = null,
    Object? sound = null,
  }) {
    return _then(_$MessageNotificationImpl(
      android_channel_id: null == android_channel_id
          ? _value.android_channel_id
          : android_channel_id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      mutable_content: null == mutable_content
          ? _value.mutable_content
          : mutable_content // ignore: cast_nullable_to_non_nullable
              as bool,
      sound: null == sound
          ? _value.sound
          : sound // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageNotificationImpl implements _MessageNotification {
  const _$MessageNotificationImpl(
      {required this.android_channel_id,
      required this.title,
      required this.body,
      required this.mutable_content,
      required this.sound});

  factory _$MessageNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageNotificationImplFromJson(json);

  @override
  final String android_channel_id;
  @override
  final String title;
  @override
  final String body;
  @override
  final bool mutable_content;
  @override
  final String sound;

  @override
  String toString() {
    return 'MessageNotification(android_channel_id: $android_channel_id, title: $title, body: $body, mutable_content: $mutable_content, sound: $sound)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageNotificationImpl &&
            (identical(other.android_channel_id, android_channel_id) ||
                other.android_channel_id == android_channel_id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.mutable_content, mutable_content) ||
                other.mutable_content == mutable_content) &&
            (identical(other.sound, sound) || other.sound == sound));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, android_channel_id, title, body, mutable_content, sound);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageNotificationImplCopyWith<_$MessageNotificationImpl> get copyWith =>
      __$$MessageNotificationImplCopyWithImpl<_$MessageNotificationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageNotificationImplToJson(
      this,
    );
  }
}

abstract class _MessageNotification implements MessageNotification {
  const factory _MessageNotification(
      {required final String android_channel_id,
      required final String title,
      required final String body,
      required final bool mutable_content,
      required final String sound}) = _$MessageNotificationImpl;

  factory _MessageNotification.fromJson(Map<String, dynamic> json) =
      _$MessageNotificationImpl.fromJson;

  @override
  String get android_channel_id;
  @override
  String get title;
  @override
  String get body;
  @override
  bool get mutable_content;
  @override
  String get sound;
  @override
  @JsonKey(ignore: true)
  _$$MessageNotificationImplCopyWith<_$MessageNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
