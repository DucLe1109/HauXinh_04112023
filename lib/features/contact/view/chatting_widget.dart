import 'package:boilerplate/generated/assets.gen.dart';
import 'package:flutter/material.dart';

class Chatting extends StatelessWidget {
  const Chatting({
    super.key,
    required this.hasNewMessage,
    required this.userName,
    required this.message,
    this.imageProvider,
    required this.time,
    required this.messageCount,
  });

  final ImageProvider? imageProvider;
  final bool hasNewMessage;
  final String userName;
  final String message;
  final String time;
  final int messageCount;

  @override
  Widget build(BuildContext context) {
    const double imageWidth = 55;
    const double badgeLeftPosition = imageWidth + 5;
    const double badgeWidth = 18;
    const double badgeHeight = 18;

    return Stack(
      children: [
        ListTile(
          leading: Container(
            width: imageWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image:
                    imageProvider ?? AssetImage(Assets.images.page5.path),
                    fit: BoxFit.cover)),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                time,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.7)),
              )
            ],
          ),
          subtitle: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.5)),
                    maxLines: 2,
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color(0xFFD2D5F9),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      messageCount.toString(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xff000000)),
                    ),
                  )
                ],
              ),
            ),
          ),
          horizontalTitleGap: 20,
        ),
        hasNewMessage
            ? Positioned(
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
