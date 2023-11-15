// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationBodyImpl _$$NotificationBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationBodyImpl(
      to: json['to'] as String,
      notification: MessageNotification.fromJson(
          json['notification'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$NotificationBodyImplToJson(
        _$NotificationBodyImpl instance) =>
    <String, dynamic>{
      'to': instance.to,
      'notification': instance.notification,
    };
