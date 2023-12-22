// ignore_for_file: cascade_invocations, avoid_positional_boolean_parameters

import 'dart:io';

import 'package:boilerplate/features/authentication/view/base_loading_dialog.dart';
import 'package:boilerplate/features/personal_chat/message_type.dart';
import 'package:boilerplate/features/personal_chat/model/message_model.dart';
import 'package:boilerplate/features/personal_chat/view/zoomable_image_screen.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:boilerplate/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swipe_to/swipe_to.dart';

class CustomBubble extends StatefulWidget {
  final bool isSender;
  final bool tail;
  final Color color;
  final TextStyle? textStyle;
  final BoxConstraints? constraints;
  final String imageUrl;

  final MessageModel message;

  const CustomBubble({
    super.key,
    this.isSender = true,
    this.constraints,
    this.color = Colors.white70,
    this.tail = true,
    this.textStyle,
    required this.imageUrl,
    required this.message,
  });

  @override
  State<CustomBubble> createState() => _CustomBubbleState();
}

class _CustomBubbleState extends State<CustomBubble>
    with AutomaticKeepAliveClientMixin {
  final smallAvatarSize = 22.w;
  late bool stateTick;
  Icon? stateIcon;
  bool sent = true;
  late bool delivered;
  late bool seen;

  @override
  void initState() {
    super.initState();
    stateTick = false;
    delivered = widget.message.createdTime?.isNotEmpty ?? false;
    seen = widget.message.readAt?.isNotEmpty ?? false;
  }

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {
    super.build(context);

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
        child:
            !widget.isSender ? getBubbleForReceiver() : getBubbleForSender());
  }

  Widget getBubbleForReceiver() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            !widget.isSender ? _buildSmallAvatar() : Container(),
            _buildMainBubble(),
          ],
        ),
        SizedBox(
          width: 6.w,
        ),
        _buildInteractionWidget()
      ],
    );
  }

  Widget getBubbleForSender() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildInteractionWidget(),
        SizedBox(
          width: 6.w,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            !widget.isSender ? _buildSmallAvatar() : Container(),
            _buildMainBubble(),
          ],
        ),
      ],
    );
  }

  Widget _buildMainBubble() {
    return Container(
      margin: EdgeInsets.only(
          top: 3.w,
          bottom: 3.w,
          left:
              !widget.tail ? (!widget.isSender ? smallAvatarSize : 0.w) : 0.w),
      child: CustomPaint(
        painter: SpecialChatBubbleThree(
            color: widget.color,
            alignment: widget.isSender ? Alignment.topRight : Alignment.topLeft,
            tail: widget.tail),
        child: Container(
          padding: widget.message.type == MessageType.text.name
              ? EdgeInsets.only(
                  left: widget.isSender ? 14.w : 22.w,
                  right: widget.isSender ? 22.w : 14.w,
                  top: 8.w,
                  bottom: 8.w)
              : EdgeInsets.fromLTRB(widget.isSender ? 4.w : 12.w, 4.w,
                  widget.isSender ? 12.w : 4.w, 8.w),
          constraints: widget.constraints ??
              BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .7,
              ),
          child: widget.message.msg!.length < 15
              ? _buildOneLineMessage()
              : _buildMultipleLineMessage(),
        ),
      ),
    );
  }

  Widget _buildSmallAvatar() {
    return Visibility(
      visible: widget.tail,
      child: Container(
        margin: EdgeInsets.only(bottom: 3.w),
        child: CachedNetworkImage(
          imageBuilder: (context, imageProvider) => Container(
            width: smallAvatarSize,
            height: smallAvatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          imageUrl: widget.imageUrl,
        ),
      ),
    );
  }

  Widget _buildMultipleLineMessage() {
    return Column(
      children: [
        _getDetailBubble(),
        SizedBox(
          height: 8.w,
        ),
        Padding(
          padding: EdgeInsets.only(
              right: widget.isSender ? 8.w : 0.w,
              left: widget.isSender ? 8.w : 0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 1.5.w,
                ),
                child: Text(
                  Utils.formatToLastMessageTime(
                      widget.message.createdTime ?? ''),
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
        )
      ],
    );
  }

  Widget _getDetailBubble() {
    if (widget.message.type == MessageType.text.name) {
      return Text(
        widget.message.msg ?? '',
        style: widget.textStyle ?? Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.left,
      );
    } else if (widget.message.type == MessageType.image.name) {
      return _buildRemoteImage();
    } else if (widget.message.type == MessageType.temp.name ||
        widget.message.type == MessageType.local.name) {
      return _buildLocalImage();
    }
    return Container();
  }

  Widget _buildRemoteImage() {
    return GestureDetector(
      onTap: () {
        context.pushTransparentRoute(ZoomableImageScreen(
          url: widget.message.msg ?? '',
        ));
      },
      child: Hero(
        tag: widget.message.msg ?? '',
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12.w),
            child: CachedNetworkImage(imageUrl: widget.message.msg ?? '')),
      ),
    );
  }

  Widget _buildLocalImage() {
    return GestureDetector(
      onTap: () {
        context.pushTransparentRoute(ZoomableImageScreen(
          uri: widget.message.msg ?? '',
        ));
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: widget.message.msg ?? '',
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12.w),
                child: Image.file(
                  File(widget.message.msg ?? ''),
                  fit: BoxFit.cover,
                )),
          ),
          Visibility(
            visible: widget.message.type != MessageType.local.name,
            child: Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .inversePrimary
                      .withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.w),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.message.type != MessageType.local.name,
            child: BaseLoadingDialog(
              startRatio: 0.8,
              willPopScope: true,
              activeColor: Colors.lightGreen,
              inactiveColor: Colors.white60,
              radius: 20.w,
              isShowIcon: false,
              relativeWidth: 1.5,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOneLineMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          widget.message.msg ?? '',
          style: widget.textStyle,
          textAlign: TextAlign.left,
        ),
        SizedBox(
          width: 12.w,
        ),
        Container(
          margin: EdgeInsets.only(top: 1.5.w),
          child: Text(
            Utils.formatToLastMessageTime(widget.message.createdTime ?? ''),
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
    );
  }

  Widget _buildInteractionWidget() {
    return GestureDetector(
      onTap: onInteraction,
      child: Material(
        shape: const CircleBorder(),
        elevation: 1,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(3.w, 4.w, 3.w, 3.w),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isSender
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.7)
                  : Theme.of(context).colorScheme.secondary.withOpacity(0.7)),
          height: 20.w,
          width: 20.w,
          child: !isHasInteraction()
              ? Icon(
                  CupertinoIcons.suit_heart,
                  size: 13.w,
                  color: Theme.of(context).colorScheme.inversePrimary,
                )
              : Icon(
                  CupertinoIcons.suit_heart_fill,
                  size: 13.w,
                  color: Colors.purpleAccent,
                ),
        ),
      ),
    );
  }

  bool isHasInteraction() {
    if (widget.message.type == MessageType.temp.name) {
      return false;
    }
    return widget.message.interaction?.isNotEmpty ?? false;
  }

  void onInteraction() {
    HapticFeedback.mediumImpact();
    FirebaseUtils.updateMessageInteraction(
      interactionType: (widget.message.interaction?.isEmpty ?? false)
          ? InteractionType.heart.name
          : '',
      isSender: widget.isSender,
      messageModel: widget.message,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

///custom painter use to create the shape of the chat bubble
///
/// [color],[alignment] and [tail] can be changed

class SpecialChatBubbleThree extends CustomPainter {
  final Color color;
  final Alignment alignment;
  final bool tail;

  SpecialChatBubbleThree({
    required this.color,
    required this.alignment,
    required this.tail,
  });

  final double _radius = 10;

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final w = size.width;
    if (alignment == Alignment.topRight) {
      if (tail) {
        final path = Path();

        /// starting point
        path.moveTo(_radius * 2, 0);

        /// top-left corner
        path.quadraticBezierTo(0, 0, 0, _radius * 1.5);

        /// left line
        path.lineTo(0, h - _radius * 1.5);

        /// bottom-left corner
        path.quadraticBezierTo(0, h, _radius * 2, h);

        /// bottom line
        path.lineTo(w - _radius * 3, h);

        /// bottom-right bubble curve
        path.quadraticBezierTo(
            w - _radius * 1.5, h, w - _radius * 1.5, h - _radius * 0.6);

        /// bottom-right tail curve 1
        path.quadraticBezierTo(w - _radius * 1, h, w, h);

        /// bottom-right tail curve 2
        path.quadraticBezierTo(
            w - _radius * 0.8, h, w - _radius, h - _radius * 1.5);

        /// right line
        path.lineTo(w - _radius, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w - _radius, 0, w - _radius * 3, 0);

        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      } else {
        final path = Path();

        /// starting point
        path.moveTo(_radius * 2, 0);

        /// top-left corner
        path.quadraticBezierTo(0, 0, 0, _radius * 1.5);

        /// left line
        path.lineTo(0, h - _radius * 1.5);

        /// bottom-left corner
        path.quadraticBezierTo(0, h, _radius * 2, h);

        /// bottom line
        path.lineTo(w - _radius * 3, h);

        /// bottom-right curve
        path.quadraticBezierTo(w - _radius, h, w - _radius, h - _radius * 1.5);

        /// right line
        path.lineTo(w - _radius, _radius * 1.5);

        /// top-right curve
        path.quadraticBezierTo(w - _radius, 0, w - _radius * 3, 0);

        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      }
    } else {
      if (tail) {
        final path = Path();

        /// starting point
        path
          ..moveTo(_radius * 3, 0)

          /// top-left corner
          ..quadraticBezierTo(_radius, 0, _radius, _radius * 1.5)

          /// left line
          ..lineTo(_radius, h - _radius * 1.5)
          // bottom-right tail curve 1
          ..quadraticBezierTo(_radius * .8, h, 0, h)

          /// bottom-right tail curve 2
          ..quadraticBezierTo(_radius * 1, h, _radius * 1.5, h - _radius * 0.6)

          /// bottom-left bubble curve
          ..quadraticBezierTo(_radius * 1.5, h, _radius * 3, h)

          /// bottom line
          ..lineTo(w - _radius * 2, h)

          /// bottom-right curve
          ..quadraticBezierTo(w, h, w, h - _radius * 1.5)

          /// right line
          ..lineTo(w, _radius * 1.5)

          /// top-right curve
          ..quadraticBezierTo(w, 0, w - _radius * 2, 0);
        canvas.clipPath(path);
        canvas.drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill);
      } else {
        final path = Path();

        /// starting point
        path
          ..moveTo(_radius * 3, 0)

          /// top-left corner
          ..quadraticBezierTo(_radius, 0, _radius, _radius * 1.5)

          /// left line
          ..lineTo(_radius, h - _radius * 1.5)

          /// bottom-left curve
          ..quadraticBezierTo(_radius, h, _radius * 3, h)

          /// bottom line
          ..lineTo(w - _radius * 2, h)

          /// bottom-right curve
          ..quadraticBezierTo(w, h, w, h - _radius * 1.5);

        /// right line
        path
          ..lineTo(w, _radius * 1.5)

          /// top-right curve
          ..quadraticBezierTo(w, 0, w - _radius * 2, 0);
        canvas
          ..clipPath(path)
          ..drawRRect(
              RRect.fromLTRBR(0, 0, w, h, Radius.zero),
              Paint()
                ..color = color
                ..style = PaintingStyle.fill);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
