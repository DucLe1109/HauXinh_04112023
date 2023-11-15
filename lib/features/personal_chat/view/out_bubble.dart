import 'dart:io';

import 'package:boilerplate/features/authentication/view/base_loading_dialog.dart';
import 'package:boilerplate/features/personal_chat/message_type.dart';
import 'package:boilerplate/generated/assets.gen.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/utils/utils.dart';
import 'package:boilerplate/widgets/app_bar_leading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rest_client/rest_client.dart';

class OutBubble extends StatelessWidget {
  final Message message;
  final bool isRounded;

  const OutBubble({super.key, required this.message, this.isRounded = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints:
            BoxConstraints(minWidth: 70.w, maxWidth: 300.w, minHeight: 10.w),
        margin: EdgeInsets.symmetric(vertical: 6.w),
        padding: message.type == MessageType.text.name
            ? EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.w)
            : EdgeInsets.fromLTRB(0.w, 0.w, 0.w, 8.w),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: !isRounded ? BorderRadius.only(
                topRight: Radius.circular(16.w),
                topLeft: Radius.circular(16.w),
                bottomLeft: Radius.circular(16.w)) : BorderRadius.circular(16.w)),
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
                            return _buildImageScreen(context, animation);
                          },
                        );
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16.w),
                            topLeft: Radius.circular(16.w),
                          ),
                          child:
                              CachedNetworkImage(imageUrl: message.msg ?? '')),
                    )
                  else
                    _buildTempImage(context),
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

  Stack _buildTempImage(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16.w),
              topLeft: Radius.circular(16.w),
            ),
            child: Image.file(
              File(message.msg ?? ''),
              fit: BoxFit.cover,
            )),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16.w),
                  topLeft: Radius.circular(16.w),
                )),
          ),
        ),
        BaseLoadingDialog(
          activeColor: Colors.blueAccent,
          inactiveColor: Colors.redAccent,
          radius: 23.w,
          isShowIcon: false,
          relativeWidth: 1,
        )
      ],
    );
  }

  Scaffold _buildImageScreen(
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
