// ignore_for_file: avoid_positional_boolean_parameters

import 'package:boilerplate/features/personal_chat/view/message_card.dart';
import 'package:flutter/cupertino.dart';

class ListViewNotifier extends ChangeNotifier {
  List<MessageCard> listMessageView;

  ListViewNotifier({required this.listMessageView});

  void changeListMessageView(MessageCard newItem) {
    listMessageView.insert(0, newItem);
    // notifyListeners();
  }

  void reloadList() {
    notifyListeners();
  }

  void setAnimation(bool value) {
    listMessageView = listMessageView
        .map((e) => MessageCard(
              message: e.message,
              animationController: e.animationController,
            ))
        .toList();
  }
}
