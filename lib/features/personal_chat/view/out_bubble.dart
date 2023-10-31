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

  const OutBubble({super.key, required this.message});

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
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.w),
                topLeft: Radius.circular(16.w),
                bottomLeft: Radius.circular(16.w))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (message.type == MessageType.text.name)
              Text(
                message.msg ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else
              GestureDetector(
                onTap: () {
                  showGeneralDialog(
                    context: context,
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Container(),
                    transitionBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return Scaffold(
                        appBar: AppBar(
                          elevation: 0,
                          centerTitle: true,
                          title: Text(S.current.image
                              .replaceAll('[', '')
                              .replaceAll(']', '')),
                          backgroundColor: Theme.of(context).primaryColor,
                          leading: const AppBarLeading(),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        body: Padding(
                          padding: EdgeInsets.only(bottom: 80.w),
                          child: ClipRRect(
                            child: PhotoView(
                                backgroundDecoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor),
                                minScale: PhotoViewComputedScale.contained * 1,
                                maxScale: PhotoViewComputedScale.contained * 1.4,
                                initialScale: PhotoViewComputedScale.contained,
                                imageProvider:
                                    CachedNetworkImageProvider(message.msg ?? '')),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.w),
                      topLeft: Radius.circular(16.w),
                    ),
                    child: CachedNetworkImage(imageUrl: message.msg ?? '')),
              ),
            SizedBox(
              height: 8.w,
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: message.type == MessageType.text.name ? 0.w : 14.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    Utils.formatToTime(message.createdTime),
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
            ),
          ],
        ),
      ),
    );
  }
}
