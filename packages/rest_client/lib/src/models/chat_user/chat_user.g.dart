// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatUserImpl _$$ChatUserImplFromJson(Map<String, dynamic> json) =>
    _$ChatUserImpl(
      about: json['about'] as String,
      createdAt: json['createdAt'] as String,
      email: json['email'] as String,
      id: json['id'] as String,
      isOnline: json['isOnline'] as bool,
      isHasStory: json['isHasStory'] as bool,
      lastActive: json['lastActive'] as String,
      fullName: json['fullName'] as String,
      pushToken: json['pushToken'] as String,
      avatar: json['avatar'] as String,
      birthday: json['birthday'] as String,
    );

Map<String, dynamic> _$$ChatUserImplToJson(_$ChatUserImpl instance) =>
    <String, dynamic>{
      'about': instance.about,
      'createdAt': instance.createdAt,
      'email': instance.email,
      'id': instance.id,
      'isOnline': instance.isOnline,
      'isHasStory': instance.isHasStory,
      'lastActive': instance.lastActive,
      'fullName': instance.fullName,
      'pushToken': instance.pushToken,
      'avatar': instance.avatar,
      'birthday': instance.birthday,
    };
