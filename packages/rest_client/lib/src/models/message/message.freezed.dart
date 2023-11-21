// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Message _$MessageFromJson(Map<String, dynamic> json) {
  return _Message.fromJson(json);
}

/// @nodoc
mixin _$Message {
  String? get fromId => throw _privateConstructorUsedError;
  String? get toId => throw _privateConstructorUsedError;
  String? get createdTime => throw _privateConstructorUsedError;
  String? get updatedTime => throw _privateConstructorUsedError;
  String? get readAt => throw _privateConstructorUsedError;
  String? get msg => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get timeStamp => throw _privateConstructorUsedError;
  String? get imageCacheUri => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res, Message>;
  @useResult
  $Res call(
      {String? fromId,
      String? toId,
      String? createdTime,
      String? updatedTime,
      String? readAt,
      String? msg,
      String? type,
      String? timeStamp,
      String? imageCacheUri});
}

/// @nodoc
class _$MessageCopyWithImpl<$Res, $Val extends Message>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fromId = freezed,
    Object? toId = freezed,
    Object? createdTime = freezed,
    Object? updatedTime = freezed,
    Object? readAt = freezed,
    Object? msg = freezed,
    Object? type = freezed,
    Object? timeStamp = freezed,
    Object? imageCacheUri = freezed,
  }) {
    return _then(_value.copyWith(
      fromId: freezed == fromId
          ? _value.fromId
          : fromId // ignore: cast_nullable_to_non_nullable
              as String?,
      toId: freezed == toId
          ? _value.toId
          : toId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedTime: freezed == updatedTime
          ? _value.updatedTime
          : updatedTime // ignore: cast_nullable_to_non_nullable
              as String?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as String?,
      msg: freezed == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      timeStamp: freezed == timeStamp
          ? _value.timeStamp
          : timeStamp // ignore: cast_nullable_to_non_nullable
              as String?,
      imageCacheUri: freezed == imageCacheUri
          ? _value.imageCacheUri
          : imageCacheUri // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageImplCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$MessageImplCopyWith(
          _$MessageImpl value, $Res Function(_$MessageImpl) then) =
      __$$MessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? fromId,
      String? toId,
      String? createdTime,
      String? updatedTime,
      String? readAt,
      String? msg,
      String? type,
      String? timeStamp,
      String? imageCacheUri});
}

/// @nodoc
class __$$MessageImplCopyWithImpl<$Res>
    extends _$MessageCopyWithImpl<$Res, _$MessageImpl>
    implements _$$MessageImplCopyWith<$Res> {
  __$$MessageImplCopyWithImpl(
      _$MessageImpl _value, $Res Function(_$MessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fromId = freezed,
    Object? toId = freezed,
    Object? createdTime = freezed,
    Object? updatedTime = freezed,
    Object? readAt = freezed,
    Object? msg = freezed,
    Object? type = freezed,
    Object? timeStamp = freezed,
    Object? imageCacheUri = freezed,
  }) {
    return _then(_$MessageImpl(
      fromId: freezed == fromId
          ? _value.fromId
          : fromId // ignore: cast_nullable_to_non_nullable
              as String?,
      toId: freezed == toId
          ? _value.toId
          : toId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedTime: freezed == updatedTime
          ? _value.updatedTime
          : updatedTime // ignore: cast_nullable_to_non_nullable
              as String?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as String?,
      msg: freezed == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      timeStamp: freezed == timeStamp
          ? _value.timeStamp
          : timeStamp // ignore: cast_nullable_to_non_nullable
              as String?,
      imageCacheUri: freezed == imageCacheUri
          ? _value.imageCacheUri
          : imageCacheUri // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageImpl implements _Message {
  const _$MessageImpl(
      {this.fromId,
      this.toId,
      this.createdTime,
      this.updatedTime,
      this.readAt,
      this.msg,
      this.type,
      this.timeStamp,
      this.imageCacheUri});

  factory _$MessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageImplFromJson(json);

  @override
  final String? fromId;
  @override
  final String? toId;
  @override
  final String? createdTime;
  @override
  final String? updatedTime;
  @override
  final String? readAt;
  @override
  final String? msg;
  @override
  final String? type;
  @override
  final String? timeStamp;
  @override
  final String? imageCacheUri;

  @override
  String toString() {
    return 'Message(fromId: $fromId, toId: $toId, createdTime: $createdTime, updatedTime: $updatedTime, readAt: $readAt, msg: $msg, type: $type, timeStamp: $timeStamp, imageCacheUri: $imageCacheUri)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImpl &&
            (identical(other.fromId, fromId) || other.fromId == fromId) &&
            (identical(other.toId, toId) || other.toId == toId) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.msg, msg) || other.msg == msg) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.timeStamp, timeStamp) ||
                other.timeStamp == timeStamp) &&
            (identical(other.imageCacheUri, imageCacheUri) ||
                other.imageCacheUri == imageCacheUri));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, fromId, toId, createdTime,
      updatedTime, readAt, msg, type, timeStamp, imageCacheUri);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      __$$MessageImplCopyWithImpl<_$MessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageImplToJson(
      this,
    );
  }
}

abstract class _Message implements Message {
  const factory _Message(
      {final String? fromId,
      final String? toId,
      final String? createdTime,
      final String? updatedTime,
      final String? readAt,
      final String? msg,
      final String? type,
      final String? timeStamp,
      final String? imageCacheUri}) = _$MessageImpl;

  factory _Message.fromJson(Map<String, dynamic> json) = _$MessageImpl.fromJson;

  @override
  String? get fromId;
  @override
  String? get toId;
  @override
  String? get createdTime;
  @override
  String? get updatedTime;
  @override
  String? get readAt;
  @override
  String? get msg;
  @override
  String? get type;
  @override
  String? get timeStamp;
  @override
  String? get imageCacheUri;
  @override
  @JsonKey(ignore: true)
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
