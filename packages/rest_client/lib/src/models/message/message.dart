import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@Freezed(fromJson: true, toJson: true)
class Message with _$Message {

  const factory Message({
    String? fromId,
    String? toId,
    String? sent,
    String? read,
    String? msg,
    String? type,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

}
