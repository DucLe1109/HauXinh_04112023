// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      fromId: json['fromId'] as String?,
      toId: json['toId'] as String?,
      sent: json['sent'] as String?,
      read: json['read'] as String?,
      msg: json['msg'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'fromId': instance.fromId,
      'toId': instance.toId,
      'sent': instance.sent,
      'read': instance.read,
      'msg': instance.msg,
      'type': instance.type,
    };
