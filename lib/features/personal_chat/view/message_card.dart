import 'package:boilerplate/animation/translation_fade_in.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rest_client/rest_client.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({super.key, required this.message, required this.index});

  final Message message;
  final int index;

  @override
  Widget build(BuildContext context) {
    return FirebaseUtils.user?.uid == message.fromId
        ? _buildBlueMessage(context)
        : _buildGreenMessage(context);
  }

  Widget _buildGreenMessage(BuildContext context) {
    return TranslationFadeIn(
      translationDistanceY: 90,
      duration: const Duration(milliseconds: 200),
      translateDirection: TranslateDirection.up,
      mChild: Row(
        children: [
          Container(
            constraints: BoxConstraints.loose(const Size(300, double.infinity)),
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.fromLTRB(18, 12, 12, 12),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.lightBlue),
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    message.msg ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    getCreatedTime(message.createdTime),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[500], fontSize: 11),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlueMessage(BuildContext context) {
    return TranslationFadeIn(
      translationDistanceY: 90,
      duration: const Duration(milliseconds: 200),
      translateDirection: TranslateDirection.up,
      mChild: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints.loose(const Size(300, double.infinity)),
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.fromLTRB(18, 12, 12, 12),
            decoration: BoxDecoration(
                color:
                    Theme.of(context).buttonTheme.getFocusColor(MaterialButton(
                          onPressed: () {},
                        )),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    message.msg ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    getCreatedTime(message.createdTime),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[500], fontSize: 11),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getCreatedTime(String? value) {
    final datetime = DateFormat('dd/MM/yyyy HH:mm:ss').parse(value ?? '');
    return DateFormat('HH:mm').format(datetime);
  }
}
