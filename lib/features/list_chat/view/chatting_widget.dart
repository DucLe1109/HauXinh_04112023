import 'package:boilerplate/features/personal_chat/message_type.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rest_client/rest_client.dart';

class Chatting extends StatelessWidget {
  const Chatting({super.key, this.onTap, required this.chatUser});

  final ChatUser chatUser;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final double imageWidth = 42.w;
    final double badgeLeftPosition = imageWidth + 8.w;
    final double badgeTopPosition = 10.w;
    final double badgeWidth = 14.w;
    final double badgeHeight = 14.w;
    final Stream<QuerySnapshot<Map<String, dynamic>>> latestMessageStream =
        FirebaseUtils.getLatestMessage(chatUser);

    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          StreamBuilder(
              stream: latestMessageStream,
              builder: (context, snapshot) {
                Message? message;
                if (snapshot.hasData) {
                  final result = snapshot.data?.docs.firstOrNull;
                  if (result != null) {
                    message = Message.fromJson(result.data());
                  }
                }
                return ListTile(
                  leading: chatUser.isHasStory
                      ? Container(
                          padding: EdgeInsets.all(1.w),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.blue, width: 1.w)),
                          child: CachedNetworkImage(
                            imageBuilder: (context, imageProvider) => Container(
                              width: imageWidth,
                              height: imageWidth,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            imageUrl: chatUser.avatar,
                            placeholder: (context, url) =>
                                const CircleAvatar(child: Icon(Icons.person)),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(child: Icon(Icons.person)),
                          ),
                        )
                      : CachedNetworkImage(
                          imageBuilder: (context, imageProvider) => Container(
                            width: imageWidth + 2.w,
                            height: imageWidth + 2.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          imageUrl: chatUser.avatar,
                          placeholder: (context, url) =>
                              const CircleAvatar(child: Icon(Icons.person)),
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(child: Icon(Icons.person)),
                        ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 4,
                        child: Text(
                          chatUser.fullName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Flexible(
                        flex: 2,
                        child: Text(
                          Utils.formatToLastMessageTime(message?.createdTime),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color
                                      ?.withOpacity(0.7)),
                        ),
                      )
                    ],
                  ),
                  subtitle: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            getMessage(message),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withOpacity(0.6)),
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        FutureBuilder(
                          future: FirebaseUtils.getAllUnreadMessage(chatUser),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return (snapshot.data?.docs.isNotEmpty ?? false)
                                  ? Container(
                                      constraints:
                                          BoxConstraints(maxHeight: 22.w),
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3.w, horizontal: 8.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16.w),
                                        color: const Color(0xFFD2D5F9),
                                      ),
                                      child: Text(
                                        snapshot.data?.docs.length.toString() ??
                                            '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(fontSize: 10),
                                      ),
                                    )
                                  : Container();
                            }
                            return Container();
                          },
                        )
                      ],
                    ),
                  ),
                  horizontalTitleGap: 12,
                );
              }),
          chatUser.isOnline
              ? Positioned(
                  top: badgeTopPosition,
                  left: badgeLeftPosition,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    width: badgeWidth,
                    height: badgeHeight,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ))
              : Container()
        ],
      ),
    );
  }

  String getMessage(Message? message) {
    if (message?.type == MessageType.text.name) {
      return message?.msg ?? '';
    } else if (message?.type == MessageType.image.name) {
      return S.current.image;
    }
    return '';
  }

  bool isNotReadMessageYet(Message? message) =>
      (message?.readAt?.isEmpty ?? false) &&
      message?.fromId != FirebaseUtils.user?.uid;
}
