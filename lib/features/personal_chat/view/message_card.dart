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
      {super.key, required this.message,});

  final Message message;
  // final AnimationController animationController;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final translationDistance = 90.0;

  @override
  void initState() {
    super.initState();
    // widget.animationController.forward();
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
    return InBubble(message: widget.message);
  }

  Widget _buildOutBubble() {
    return OutBubble(message: widget.message);
  }
}
