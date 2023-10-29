import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class DefaultErrorToast extends StatelessWidget {
  final String errorMessage;

  const DefaultErrorToast(Key? key, this.errorMessage) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          color: GFColors.DARK,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.40), blurRadius: 5)
          ]),
      child: GFListTile(
          color: GFColors.DARK,
          title: Text(
            errorMessage,
            style: const TextStyle(color: GFColors.WHITE),
          ),
          icon: const Icon(
            CupertinoIcons.forward,
            color: GFColors.DANGER,
          )),
    );
  }
}
