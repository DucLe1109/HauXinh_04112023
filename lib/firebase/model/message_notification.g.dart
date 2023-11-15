// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageNotificationImpl _$$MessageNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageNotificationImpl(
      android_channel_id: json['android_channel_id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      mutable_content: json['mutable_content'] as bool,
      sound: json['sound'] as String,
    );

Map<String, dynamic> _$$MessageNotificationImplToJson(
        _$MessageNotificationImpl instance) =>
    <String, dynamic>{
      'android_channel_id': instance.android_channel_id,
      'title': instance.title,
      'body': instance.body,
      'mutable_content': instance.mutable_content,
      'sound': instance.sound,
    };
