import 'package:boilerplate/core/global_variable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rest_client/rest_client.dart';

class Chatting extends StatelessWidget {
  const Chatting(this.chatUser, {super.key});

  final ChatUser chatUser;

  @override
  Widget build(BuildContext context) {
    const double imageWidth = 45;
    const double badgeLeftPosition = imageWidth + 12;
    const double badgeTopPosition = 6;
    const double badgeWidth = 14;
    const double badgeHeight = 14;
    const double borderRadiusContainer = 16;

    return Stack(
      children: [
        ListTile(
          leading: chatUser.isHasStory
              ? Container(
                  padding: const EdgeInsets.all(1.3),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius:
                          BorderRadius.circular(borderRadiusContainer)),
                  child: SizedBox(
                    width: imageWidth,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(borderRadiusContainer - 2),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: chatUser.avatar,
                        placeholder: (context, url) =>
                            const CircleAvatar(child: Icon(Icons.person)),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                )
              : DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadiusContainer),
                  ),
                  child: SizedBox(
                    width: imageWidth + 4,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(borderRadiusContainer - 2),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: chatUser.avatar,
                        placeholder: (context, url) =>
                            const CircleAvatar(child: Icon(Icons.person)),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
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
                  chatUser.createdAt,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                Text(
                  chatUser.about,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withOpacity(0.5)),
                  maxLines: 2,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: const Color(0xFFD2D5F9),
                      borderRadius:
                          BorderRadius.circular(borderRadiusContainer)),
                  child: Text(
                    '20',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: const Color(0xff000000)),
                  ),
                )
              ],
            ),
          ),
          horizontalTitleGap: 12,
        ),
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
    );
  }
}
