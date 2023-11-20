import 'package:boilerplate/features/personal_chat/model/message_model.dart';
import 'package:boilerplate/features/personal_chat/view/in_bubble.dart';
import 'package:boilerplate/features/personal_chat/view/out_bubble.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({
    super.key,
    required this.message,
    this.isRounded = false,
  });

  final MessageModel message;
  final bool isRounded;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard>
    with AutomaticKeepAliveClientMixin {
  final translationDistance = 90.0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
    return InBubble(
      message: widget.message,
      isRounded: widget.isRounded,
    );
  }

  Widget _buildOutBubble() {
    return OutBubble(
      message: widget.message,
      isRounded: widget.isRounded,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
