import 'package:boilerplate/core/global_variable.dart';
import 'package:boilerplate/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class StoryWidget extends StatelessWidget {
  const StoryWidget({
    super.key,
    required this.child,
    this.borderColor,
    this.width,
    this.height,
    required this.description,
  });

  final Widget child;
  final Color? borderColor;
  final double? width;
  final double? height;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(1.2),
            width: width ?? 60,
            height: height ?? 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadiusAvatar),
                border: Border.all(
                    color: borderColor ?? AppColors.greyLight, width: 2)),
            child: child),
        const SizedBox(
          height: 8,
        ),
        Text(
          description.length <= 10
              ? description
              : '${description.substring(0, 10)}...',
          style: Theme.of(context).textTheme.bodySmall,
        )
      ],
    );
  }
}
