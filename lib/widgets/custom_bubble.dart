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

class CustomBubble extends StatelessWidget {
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

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {
    final smallAvatarSize = 22.w;
    bool stateTick = false;
    Icon? stateIcon;
    const bool sent = true;
    final bool delivered = message.createdTime?.isNotEmpty ?? false;
    final bool seen = message.readAt?.isNotEmpty ?? false;

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
        alignment: isSender ? Alignment.topRight : Alignment.topLeft,
        child: !isSender
            ? getBubbleForReceiver(
                context, smallAvatarSize, stateIcon, stateTick)
            : getBubbleForSender(
                context, smallAvatarSize, stateIcon, stateTick));
  }

  Widget getBubbleForReceiver(BuildContext context, double smallAvatarSize,
      Icon? stateIcon, bool stateTick) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            !isSender
                ? _buildSmallAvatar(context, smallAvatarSize)
                : Container(),
            _buildMainBubble(context, smallAvatarSize, stateIcon, stateTick),
          ],
        ),
        SizedBox(
          width: 6.w,
        ),
        _buildInteractionWidget(context)
      ],
    );
  }

  Widget getBubbleForSender(BuildContext context, double smallAvatarSize,
      Icon? stateIcon, bool stateTick) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildInteractionWidget(context),
        SizedBox(
          width: 6.w,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            !isSender
                ? _buildSmallAvatar(context, smallAvatarSize)
                : Container(),
            _buildMainBubble(context, smallAvatarSize, stateIcon, stateTick),
          ],
        ),
      ],
    );
  }

  Widget _buildMainBubble(BuildContext context, double smallAvatarSize,
      Icon? stateIcon, bool stateTick) {
    return Container(
      margin: EdgeInsets.only(
          top: 3.w,
          bottom: 3.w,
          left: !tail ? (!isSender ? smallAvatarSize : 0.w) : 0.w),
      child: CustomPaint(
        painter: SpecialChatBubbleThree(
            color: color,
            alignment: isSender ? Alignment.topRight : Alignment.topLeft,
            tail: tail),
        child: Container(
          padding: message.type == MessageType.text.name
              ? EdgeInsets.only(
                  left: isSender ? 14.w : 22.w,
                  right: isSender ? 22.w : 14.w,
                  top: 8.w,
                  bottom: 8.w)
              : EdgeInsets.fromLTRB(
                  isSender ? 4.w : 12.w, 4.w, isSender ? 12.w : 4.w, 8.w),
          constraints: constraints ??
              BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .7,
              ),
          child: message.msg!.length < 15
              ? _buildOneLineMessage(context, stateIcon, stateTick)
              : _buildMultipleLineMessage(context, stateIcon, stateTick),
        ),
      ),
    );
  }

  Widget _buildSmallAvatar(BuildContext context, double smallAvatarSize) {
    return Visibility(
      visible: tail,
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
          imageUrl: imageUrl,
        ),
      ),
    );
  }

  Widget _buildMultipleLineMessage(
      BuildContext context, Icon? stateIcon, bool stateTick) {
    return Column(
      children: [
        _getDetailBubble(context),
        SizedBox(
          height: 8.w,
        ),
        Padding(
          padding: EdgeInsets.only(
              right: isSender ? 8.w : 0.w, left: isSender ? 8.w : 0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 1.5.w,
                ),
                child: Text(
                  Utils.formatToLastMessageTime(message.createdTime ?? ''),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 11),
                ),
              ),
              SizedBox(
                width: 6.w,
              ),
              if (stateIcon != null && stateTick && isSender)
                Container(margin: EdgeInsets.only(top: 1.5.w), child: stateIcon)
              else
                Container()
            ],
          ),
        )
      ],
    );
  }

  Widget _getDetailBubble(BuildContext context) {
    if (message.type == MessageType.text.name) {
      return Text(
        message.msg ?? '',
        style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.left,
      );
    } else if (message.type == MessageType.image.name) {
      return _buildRemoteImage(context);
    } else if (message.type == MessageType.temp.name ||
        message.type == MessageType.local.name) {
      return _buildLocalImage(context);
    }
    return Container();
  }

  Widget _buildRemoteImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushTransparentRoute(ZoomableImageScreen(
          url: message.msg ?? '',
        ));
      },
      child: Hero(
        tag: message.msg ?? '',
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12.w),
            child: CachedNetworkImage(imageUrl: message.msg ?? '')),
      ),
    );
  }

  Widget _buildLocalImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushTransparentRoute(ZoomableImageScreen(
          uri: message.msg ?? '',
        ));
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: message.msg ?? '',
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12.w),
                child: Image.file(
                  File(message.msg ?? ''),
                  fit: BoxFit.cover,
                )),
          ),
          Visibility(
            visible: message.type != MessageType.local.name,
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
            visible: message.type != MessageType.local.name,
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

  Widget _buildOneLineMessage(
      BuildContext context, Icon? stateIcon, bool stateTick) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          message.msg ?? '',
          style: textStyle,
          textAlign: TextAlign.left,
        ),
        SizedBox(
          width: 12.w,
        ),
        Container(
          margin: EdgeInsets.only(top: 1.5.w),
          child: Text(
            Utils.formatToLastMessageTime(message.createdTime ?? ''),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 11),
          ),
        ),
        SizedBox(
          width: 6.w,
        ),
        if (stateIcon != null && stateTick && isSender)
          Container(margin: EdgeInsets.only(top: 1.5.w), child: stateIcon)
        else
          Container()
      ],
    );
  }

  Widget _buildInteractionWidget(BuildContext context) {
    return StreamBuilder(
      builder: (context, snapshot) {
        MessageModel? messageModel;

        if (snapshot.hasData && snapshot.data?.data() != null) {
          messageModel = MessageModel.fromJson(snapshot.data!.data()!);
        }
        return GestureDetector(
          onTap: () {
            onInteraction(messageModel);
          },
          child: Material(
            shape: const CircleBorder(),
            elevation: 1,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(3.w, 4.w, 3.w, 3.w),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSender
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.7)
                      : Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.7)),
              height: 20.w,
              width: 20.w,
              child: !isHasInteraction(messageModel)
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
      },
      stream: FirebaseUtils.listenMessage(
          isSender: isSender, messageModel: message),
    );
  }

  bool isHasInteraction(MessageModel? messageModel) {
    if (message.type == MessageType.temp.name) {
      return false;
    }
    if (messageModel?.interaction?.isNotEmpty ?? false) {
      return true;
    }
    return false;
  }

  void onInteraction(MessageModel? messageModel) {
    HapticFeedback.mediumImpact();
    FirebaseUtils.updateMessageInteraction(
      interactionType: (messageModel?.interaction?.isEmpty ?? false)
          ? InteractionType.heart.name
          : '',
      isSender: isSender,
      messageModel: message,
    );
  }
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
