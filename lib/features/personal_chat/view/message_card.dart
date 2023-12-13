import 'package:boilerplate/features/personal_chat/model/message_model.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:boilerplate/widgets/custom_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rest_client/rest_client.dart';

class MessageCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser?.uid != message.fromId) {
      return _buildInBubble(context);
    } else {
      return _buildOutBubble(context);
    }
  }

  Widget _buildInBubble(BuildContext context) {
    if (message.readAt?.isEmpty ?? false) {
      FirebaseUtils.readMessage(message);
    }
    return CustomBubble(
      imageUrl: chatUser.avatar,
      color: Theme.of(context).colorScheme.secondary,
      tail: isShowTail,
      constraints:
          BoxConstraints(maxWidth: 200.w, minHeight: 10.w, minWidth: 30.w),
      isSender: false,
      message: message,
    );
  }

  Widget _buildOutBubble(BuildContext context) {
    return CustomBubble(
      message: message,
      imageUrl: chatUser.avatar,
      color: Theme.of(context).colorScheme.primary,
      tail: isShowTail,
      constraints:
          BoxConstraints(maxWidth: 200.w, minHeight: 10.w, minWidth: 30.w),
    );
  }
}
