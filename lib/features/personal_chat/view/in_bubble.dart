import 'package:boilerplate/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rest_client/rest_client.dart';

class InBubble extends StatelessWidget {
  final Message message;

  const InBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(minWidth: 70.w, maxWidth: 300.w, minHeight: 10.w),
        margin: EdgeInsets.symmetric(vertical: 6.w),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.w),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.w),
                bottomLeft: Radius.circular(16.w),
                bottomRight: Radius.circular(16.w))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.msg ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              height: 6.w,
            ),
            Text(
              Utils.formatToTime(message.createdTime),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
