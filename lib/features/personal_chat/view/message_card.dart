import 'package:boilerplate/features/personal_chat/view/in_bubble.dart';
import 'package:boilerplate/features/personal_chat/view/out_bubble.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rest_client/rest_client.dart';

class MessageCard extends StatefulWidget {
  const MessageCard(
      {super.key, required this.message, required this.animationController});

  final Message message;
  final AnimationController animationController;

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
      return _buildInBubble();
    } else {
      return _buildOutBubble();
    }
  }

  Widget _buildInBubble() {
    if (widget.message.readAt?.isEmpty ?? false) {
      FirebaseUtils.readMessage(widget.message);
    }
    return AnimatedBuilder(
      builder: (context, child) => Transform.translate(
        offset: Offset(
            0,
            Tween<double>(begin: translationDistance, end: 0)
                .evaluate(widget.animationController)),
        child: Opacity(
          opacity: Tween<double>(begin: 0, end: 1)
              .evaluate(widget.animationController),
          child: InBubble(message: widget.message),
        ),
      ),
      animation: CurvedAnimation(
          parent: widget.animationController, curve: Curves.easeOut),
    );
  }

  Widget _buildOutBubble() {
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
          child: OutBubble(message: widget.message),
        ),
      ),
    );
  }
}
