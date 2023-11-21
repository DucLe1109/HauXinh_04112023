// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      updatedTime: json['updatedTime'] as String?,
      timeStamp: json['timeStamp'] as String?,
      fromId: json['fromId'] as String?,
      toId: json['toId'] as String?,
      type: json['type'] as String?,
      createdTime: json['createdTime'] as String?,
      msg: json['msg'] as String?,
      readAt: json['readAt'] as String?,
      imageCacheUri: json['imageCacheUri'] as String?,
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
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
