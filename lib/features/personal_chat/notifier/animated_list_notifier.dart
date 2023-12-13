import 'package:boilerplate/features/personal_chat/model/message_model.dart';
import 'package:flutter/cupertino.dart';

class AnimatedListNotifier extends ChangeNotifier {

  AnimatedListNotifier();

  void reloadList() {
    notifyListeners();
  }
}
