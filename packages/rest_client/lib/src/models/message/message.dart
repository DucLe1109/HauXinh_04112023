import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

part 'message.g.dart';

@Freezed(fromJson: true, toJson: true)
class Message with _$Message {
  const factory Message({
    String? fromId,
    String? toId,
    String? createdTime,
    String? updatedTime,
    String? readAt,
    String? msg,
    String? type,
    String? timeStamp,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
