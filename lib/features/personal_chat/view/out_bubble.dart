import 'package:boilerplate/generated/assets.gen.dart';
import 'package:boilerplate/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.w),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.w),
                topLeft: Radius.circular(16.w),
                bottomLeft: Radius.circular(16.w))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.msg ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              height: 6.w,
            ),
            Row(
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
          ],
        ),
      ),
    );
  }
}
