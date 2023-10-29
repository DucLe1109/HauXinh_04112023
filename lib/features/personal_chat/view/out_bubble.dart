import 'package:boilerplate/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rest_client/rest_client.dart';

class OutBubble extends StatelessWidget {
  final Message message;

  const OutBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.msg ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white),
                  ),
                  SizedBox(
                    height: 6.w,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        getCreatedTime(message.createdTime),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey[500], fontSize: 11),
                      ),
                      SizedBox(
                        width: 6.w,
                      ),
                      Assets.icons.icDoubleCheck.image(
                          scale: 40,
                          color: (message.readAt?.isNotEmpty ?? false)
                              ? Colors.white
                              : Colors.grey[500])
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String getCreatedTime(String? value) {
    final datetime = DateFormat('dd/MM/yyyy HH:mm:ss').parse(value ?? '');
    return DateFormat('HH:mm').format(datetime);
  }
}
