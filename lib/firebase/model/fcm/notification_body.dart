import 'package:boilerplate/firebase/model/fcm/message_notification.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_body.freezed.dart';

part 'notification_body.g.dart';

@Freezed(fromJson: true, toJson: true)
class NotificationBody with _$NotificationBody {
  const factory NotificationBody({
    required String to,
    required MessageNotification notification,
  }) = _NotificationBody;

  factory NotificationBody.fromJson(Map<String, dynamic> json) =>
      _$NotificationBodyFromJson(json);
}
