// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      fromId: json['fromId'] as String?,
      toId: json['toId'] as String?,
      createdTime: json['createdTime'] as String?,
      updatedTime: json['updatedTime'] as String?,
      readAt: json['readAt'] as String?,
      msg: json['msg'] as String?,
      type: json['type'] as String?,
      timeStamp: json['timeStamp'] as String?,
      imageCacheUri: json['imageCacheUri'] as String?,
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'fromId': instance.fromId,
      'toId': instance.toId,
      'createdTime': instance.createdTime,
      'updatedTime': instance.updatedTime,
      'readAt': instance.readAt,
      'msg': instance.msg,
      'type': instance.type,
      'timeStamp': instance.timeStamp,
      'imageCacheUri': instance.imageCacheUri,
    };
