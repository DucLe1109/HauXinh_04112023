// ignore_for_file: cascade_invocations

import 'dart:io';

import 'package:boilerplate/features/authentication/view/base_loading_dialog.dart';
import 'package:boilerplate/features/personal_chat/message_type.dart';
import 'package:boilerplate/features/personal_chat/model/image_source.dart';
import 'package:boilerplate/features/personal_chat/model/message_model.dart';
import 'package:boilerplate/features/personal_chat/view/zoomable_image_screen.dart';
import 'package:boilerplate/router/app_router.dart';
import 'package:boilerplate/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
  late bool sent = true;
  late bool delivered;
  late bool seen;

  final smallAvatarSize = 22.w;
  bool stateTick = false;
  Icon? stateIcon;

  @override
  void initState() {
    super.initState();
    sent = true;
    delivered = widget.message.createdTime?.isNotEmpty ?? false;
    seen = widget.message.readAt?.isNotEmpty ?? false;
  }

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          !widget.isSender ? _buildSmallAvatar() : Container(),
          _buildMainBubble(),
        ],
      ),
    );
  }

  Container _buildMainBubble() {
    return Container(
      margin: EdgeInsets.only(
          top: 3.w, bottom: 3.w, left: !widget.tail ? smallAvatarSize : 0.w),
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

  Visibility _buildSmallAvatar() {
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

  GestureDetector _buildRemoteImage() {
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
          url: widget.message.msg ?? '',
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

  Row _buildOneLineMessage() {
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

  @override
  // TODO: implement wantKeepAlive
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
