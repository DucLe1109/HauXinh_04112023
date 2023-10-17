import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_user.freezed.dart';

part 'chat_user.g.dart';

@Freezed(fromJson: true, toJson: true)
class ChatUser with _$ChatUser {
  const factory ChatUser({
    required String about,
    required String createdAt,
    required String email,
    required String id,
    required bool isOnline,
    required bool isHasStory,
    required String lastActive,
    required String fullName,
    required String pushToken,
  }) = _ChatUser;

  factory ChatUser.fromJson(Map<String, dynamic> json) =>
      _$ChatUserFromJson(json);
}
