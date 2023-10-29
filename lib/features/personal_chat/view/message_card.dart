import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rest_client/rest_client.dart';

class MessageCard extends StatefulWidget {
  const MessageCard(
      {super.key,
      required this.message,
      required this.animationController,
      this.isAnimated = true});

  final Message message;
  final AnimationController animationController;
  final bool isAnimated;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final translationDistance = 90.0;

  @override
  void initState() {
    super.initState();
    widget.animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseUtils.user?.uid != widget.message.fromId) {
      if (widget.isAnimated) {
        return _buildComingMessageWithAnimation();
      } else {
        return _buildComingMessage(context);
      }
    } else {
      if (widget.isAnimated) {
        return _buildSendingMessageWithAnimation();
      } else {
        return _buildSendingMessage(context);
      }
    }
  }

  Widget _buildComingMessage(BuildContext context) {
    return Row(
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
                  widget.message.msg ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  getCreatedTime(widget.message.createdTime),
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

  Widget _buildComingMessageWithAnimation() {
    return AnimatedBuilder(
      builder: (context, child) => Transform.translate(
        offset: Offset(
            0,
            Tween<double>(begin: translationDistance, end: 0)
                .evaluate(widget.animationController)),
        child: Opacity(
          opacity: Tween<double>(begin: 0, end: 1)
              .evaluate(widget.animationController),
          child: _buildComingMessage(context),
        ),
      ),
      animation: CurvedAnimation(
          parent: widget.animationController, curve: Curves.easeOut),
    );
  }

  Widget _buildSendingMessage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          constraints: BoxConstraints.loose(const Size(300, double.infinity)),
          margin: const EdgeInsets.symmetric(vertical: 6),
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
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  widget.message.msg ?? '',
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
                  getCreatedTime(widget.message.createdTime),
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

  Widget _buildSendingMessageWithAnimation() {
    return AnimatedBuilder(
      animation: CurvedAnimation(
          parent: widget.animationController, curve: Curves.easeOut),
      builder: (context, child) => Transform.translate(
        offset: Offset(
            0,
            Tween<double>(begin: translationDistance, end: 0)
                .evaluate(widget.animationController)),
        child: Opacity(
          opacity: Tween<double>(begin: 0, end: 1)
              .evaluate(widget.animationController),
          child: _buildSendingMessage(context),
        ),
      ),
    );
  }

  String getCreatedTime(String? value) {
    final datetime = DateFormat('dd/MM/yyyy HH:mm:ss').parse(value ?? '');
    return DateFormat('HH:mm').format(datetime);
  }
}
