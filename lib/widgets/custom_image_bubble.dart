import 'package:boilerplate/features/personal_chat/model/message_model.dart';
import 'package:boilerplate/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomImageBubble extends StatefulWidget {
  const CustomImageBubble({
    super.key,
    this.isSender = true,
    required this.message,
  });

  final bool isSender;
  final MessageModel message;

  @override
  State<CustomImageBubble> createState() => _CustomImageBubbleState();
}

class _CustomImageBubbleState extends State<CustomImageBubble> {
  @override
  Widget build(BuildContext context) {
    const bool sent = true;
    final bool delivered = widget.message.createdTime?.isNotEmpty ?? false;
    final bool seen = widget.message.readAt?.isNotEmpty ?? false;

    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done,
        size: 10.w,
        color: Colors.grey[400],
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done_all,
        size: 10.w,
        color: Colors.grey[400],
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = Icon(
        Icons.done_all,
        size: 10.w,
        color: Theme.of(context).colorScheme.onPrimary,
      );
    }

    return Align(
      alignment: widget.isSender ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.fromLTRB(4.w, 4.w, 4.w, 8.w),
        width: 200.w,
        margin: EdgeInsets.only(
            top: 3.w,
            bottom: 3.w,
            right: widget.isSender ? 8.w : 0.w,
            left: !widget.isSender ? 30.w : 0.w),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12.w)),
        child: Column(
          children: [
            _buildNetworkImage(),
            SizedBox(
              height: 8.w,
            ),
            _buildSentTime(context, stateIcon, stateTick)
          ],
        ),
      ),
    );
  }

  Container _buildSentTime(
      BuildContext context, Icon? stateIcon, bool stateTick) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(top: 1.5.w),
            child: Text(
              Utils.formatToLastMessageTime(widget.message.createdTime),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 11),
            ),
          ),
          SizedBox(
            width: 6.w,
          ),
          if (stateIcon != null && stateTick && widget.isSender)
            Container(margin: EdgeInsets.only(top: 1.5.w), child: stateIcon)
          else
            Container()
        ],
      ),
    );
  }

  ClipRRect _buildNetworkImage() {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
        child: CachedNetworkImage(imageUrl: widget.message.msg ?? ''));
  }
}
