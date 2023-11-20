import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  MessageModel({
    this.updatedTime,
    this.timeStamp,
    this.fromId,
    this.toId,
    this.type,
    this.createdTime,
    this.msg,
    this.readAt,
  });

  String? fromId;
  String? toId;
  String? createdTime;
  String? updatedTime;
  String? readAt;
  String? msg;
  String? type;
  String? timeStamp;



  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}
