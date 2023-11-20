import 'package:boilerplate/features/personal_chat/model/message_model.dart';
import 'package:flutter/cupertino.dart';

class AnimatedListNotifier extends ChangeNotifier {
  List<MessageModel> messages;

  AnimatedListNotifier({required this.messages});

  void reloadList({required List<MessageModel> newData}) {
    messages = newData;
    notifyListeners();
  }
}
