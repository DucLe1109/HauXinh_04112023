import 'package:boilerplate/generated/assets.gen.dart';
import 'package:flutter/material.dart';

class Chatting extends StatelessWidget {
  const Chatting({
    super.key,
    required this.isOnline,
    required this.userName,
    required this.message,
    this.imageProvider,
    required this.time,
    required this.messageCount,
    this.isHasStory = false,
  });

  final ImageProvider? imageProvider;
  final bool isOnline;
  final String userName;
  final String message;
  final String time;
  final int messageCount;
  final bool isHasStory;

  @override
  Widget build(BuildContext context) {
    const double imageWidth = 55;
    const double badgeLeftPosition = imageWidth + 8;
    const double badgeTopPosition = 4;
    const double badgeWidth = 14;
    const double badgeHeight = 14;
    const double borderRadiusContainer = 15;

    return Stack(
      children: [
        ListTile(
          leading: isHasStory
              ? Container(
                  padding: const EdgeInsets.all(1.3),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius:
                          BorderRadius.circular(borderRadiusContainer)),
                  child: Container(
                    width: imageWidth,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius:
                            BorderRadius.circular(borderRadiusContainer),
                        image: DecorationImage(
                            image: imageProvider ??
                                AssetImage(Assets.images.page5.path),
                            fit: BoxFit.cover)),
                  ),
                )
              : Container(
                  width: imageWidth,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius:
                          BorderRadius.circular(borderRadiusContainer),
                      image: DecorationImage(
                          image: imageProvider ??
                              AssetImage(Assets.images.page5.path),
                          fit: BoxFit.cover)),
                ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userName,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                time,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.7)),
              )
            ],
          ),
          subtitle: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                    messageCount.toString(),
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
        isOnline
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
