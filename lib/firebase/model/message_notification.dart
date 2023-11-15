// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_notification.freezed.dart';

part 'message_notification.g.dart';

@Freezed(fromJson: true, toJson: true)
class MessageNotification with _$MessageNotification {
  const factory MessageNotification({
    required String android_channel_id,
    required String title,
    required String body,
    required bool mutable_content,
    required String sound,
  }) = _MessageNotification;

  factory MessageNotification.fromJson(Map<String, dynamic> json) =>
      _$MessageNotificationFromJson(json);
}
