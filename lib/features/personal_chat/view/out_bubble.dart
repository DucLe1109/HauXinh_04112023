import 'dart:io';

import 'package:boilerplate/features/authentication/view/base_loading_dialog.dart';
import 'package:boilerplate/features/personal_chat/message_type.dart';
import 'package:boilerplate/features/personal_chat/model/message_model.dart';
import 'package:boilerplate/generated/assets.gen.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/utils/utils.dart';
import 'package:boilerplate/widgets/app_bar_leading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';

class OutBubble extends StatelessWidget {
  final MessageModel message;
  final bool isShowTail;

  const OutBubble({super.key, required this.message, this.isShowTail = false});

  @override
  Widget build(BuildContext context) {
    final circularValue = 12.w;

    Widget buildRemoteImage() {
      return ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(circularValue),
            topLeft: isShowTail
                ? Radius.circular(circularValue)
                : Radius.circular(0.w),
          ),
          child: CachedNetworkImage(imageUrl: message.msg ?? ''));
    }

    Widget buildLocalImage(BuildContext context) {
      return Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(circularValue),
                topLeft: isShowTail
                    ? Radius.circular(circularValue)
                    : Radius.circular(0.w),
              ),
              child: Image.file(
                File(message.msg ?? ''),
                fit: BoxFit.cover,
              )),
          Visibility(
            visible: message.type != MessageType.local.name,
            child: Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .inversePrimary
                        .withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(circularValue),
                      topLeft: isShowTail
                          ? Radius.circular(circularValue)
                          : Radius.circular(0.w),
                    )),
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
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints:
            BoxConstraints(minWidth: 70.w, maxWidth: 200.w, minHeight: 10.w),
        margin: EdgeInsets.only(bottom: 5.w),
        padding: message.type == MessageType.text.name
            ? EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.w)
            : EdgeInsets.fromLTRB(0.w, 0.w, 0.w, 8.w),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: !isShowTail
                ? BorderRadius.only(
                    topRight: Radius.circular(circularValue),
                    topLeft: Radius.circular(circularValue),
                    bottomLeft: Radius.circular(circularValue))
                : BorderRadius.circular(circularValue)),
        child: message.msg!.length >= 15
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (message.type == MessageType.text.name)
                    Text(
                      message.msg ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  else if (message.type == MessageType.image.name)
                    GestureDetector(
                      onTap: () {
                        showGeneralDialog(
                          context: context,
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  Container(),
                          transitionBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return _buildRemoteImageScreen(context, animation);
                          },
                        );
                      },
                      child: buildRemoteImage(),
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        if (message.type == MessageType.local.name) {
                          showGeneralDialog(
                            context: context,
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    Container(),
                            transitionBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return _buildLocalImageScreen(context, animation);
                            },
                          );
                        }
                      },
                      child: buildLocalImage(context),
                    ),
                  SizedBox(
                    height: 8.w,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right:
                            message.type == MessageType.text.name ? 0.w : 14.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          Utils.formatToLastMessageTime(message.createdTime),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  fontSize: 11),
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        Assets.icons.icDoubleCheck.image(
                            scale: 40,
                            color: (message.readAt?.isNotEmpty ?? false)
                                ? Theme.of(context).colorScheme.onPrimary
                                : Colors.grey[400])
                      ],
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    message.msg ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        Utils.formatToLastMessageTime(message.createdTime),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 11),
                      ),
                      SizedBox(
                        width: 6.w,
                      ),
                      Assets.icons.icDoubleCheck.image(
                          scale: 40,
                          color: (message.readAt?.isNotEmpty ?? false)
                              ? Theme.of(context).colorScheme.onPrimary
                              : Colors.grey[400])
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLocalImageScreen(
      BuildContext context, Animation<double> animation) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(S.current.image.replaceAll('[', '').replaceAll(']', '')),
        backgroundColor: Theme.of(context).primaryColor,
        leading: const AppBarLeading(),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Opacity(
        opacity: animation.value,
        child: Padding(
          padding: EdgeInsets.only(bottom: 80.w),
          child: ClipRRect(
            child: PhotoView(
                backgroundDecoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                minScale: PhotoViewComputedScale.contained * 1,
                maxScale: PhotoViewComputedScale.contained * 1.4,
                initialScale: PhotoViewComputedScale.contained,
                imageProvider: FileImage(File(message.imageCacheUri ?? ''))),
          ),
        ),
      ),
    );
  }

  Widget _buildRemoteImageScreen(
      BuildContext context, Animation<double> animation) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(S.current.image.replaceAll('[', '').replaceAll(']', '')),
        backgroundColor: Theme.of(context).primaryColor,
        leading: const AppBarLeading(),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Opacity(
        opacity: animation.value,
        child: Padding(
          padding: EdgeInsets.only(bottom: 80.w),
          child: ClipRRect(
            child: PhotoView(
                backgroundDecoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                minScale: PhotoViewComputedScale.contained * 1,
                maxScale: PhotoViewComputedScale.contained * 1.4,
                initialScale: PhotoViewComputedScale.contained,
                imageProvider: CachedNetworkImageProvider(message.msg ?? '')),
          ),
        ),
      ),
    );
  }
}
