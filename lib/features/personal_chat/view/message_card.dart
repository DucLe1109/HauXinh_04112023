import 'package:boilerplate/features/personal_chat/message_type.dart';
import 'package:boilerplate/features/personal_chat/model/message_model.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:boilerplate/widgets/custom_image_bubble.dart';
import 'package:boilerplate/widgets/custom_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rest_client/rest_client.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({
    super.key,
    required this.message,
    required this.chatUser,
    this.isShowTail = false,
  });

  final MessageModel message;
  final ChatUser chatUser;
  final bool isShowTail;

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
    if (FirebaseAuth.instance.currentUser?.uid != widget.message.fromId) {
      return _buildInBubble();
    } else {
      return _buildOutBubble();
    }
  }

  Widget _buildInBubble() {
    if (widget.message.readAt?.isEmpty ?? false) {
      FirebaseUtils.readMessage(widget.message);
    }
    return CustomBubble(
      imageUrl: widget.chatUser.avatar,
      color: Theme.of(context).colorScheme.secondary,
      tail: widget.isShowTail,
      constraints:
          BoxConstraints(maxWidth: 200.w, minHeight: 10.w, minWidth: 30.w),
      isSender: false,
      message: widget.message,
    );
  }

  Widget _buildOutBubble() {
    return CustomBubble(
      message: widget.message,
      imageUrl: widget.chatUser.avatar,
      color: Theme.of(context).colorScheme.primary,
      tail: widget.isShowTail,
      constraints:
          BoxConstraints(maxWidth: 200.w, minHeight: 10.w, minWidth: 30.w),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
