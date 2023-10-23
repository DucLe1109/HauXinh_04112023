import 'package:boilerplate/core/global_variable.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:flutter/material.dart';
import 'package:rest_client/rest_client.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return FirebaseUtils.user.uid == message.fromId
        ? _buildGreenMessage(context)
        : _buildBlueMessage(context);
  }

  Widget _buildGreenMessage(BuildContext context) {
    return Row(
      children: [
        Container(
          constraints: BoxConstraints.loose(const Size(300, double.infinity)),
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  message.sent ?? '',
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
    );
  }

  Widget _buildBlueMessage(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          constraints: BoxConstraints.loose(const Size(300, 200)),
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.fromLTRB(18, 12, 12, 12),
          decoration: BoxDecoration(
              color: Theme.of(context).buttonTheme.getFocusColor(MaterialButton(
                    onPressed: () {},
                  )),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30))),
          child: Row(
            mainAxisSize: MainAxisSize.min,
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
                  message.sent ?? '',
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
    );
  }
}
