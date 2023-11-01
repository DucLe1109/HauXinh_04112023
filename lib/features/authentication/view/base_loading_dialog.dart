import 'package:boilerplate/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

class BaseLoadingDialog extends StatelessWidget {
  const BaseLoadingDialog(
      {super.key,
      this.activeColor,
      this.inactiveColor,
      this.relativeWidth,
      this.iconWidth,
      this.iconHeight,
      this.radius,
      this.isShowIcon = true});

  final Color? activeColor;
  final Color? inactiveColor;
  final double? relativeWidth;
  final double? iconWidth;
  final double? iconHeight;
  final double? radius;
  final bool isShowIcon;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Stack(
        alignment: Alignment.center,
        children: [
          NutsActivityIndicator(
            endRatio: 0.85,
            animationDuration: const Duration(milliseconds: 500),
            activeColor: activeColor ?? Colors.blue,
            inactiveColor: inactiveColor ?? Colors.white,
            tickCount: 24,
            relativeWidth: relativeWidth ?? 0.1,
            radius: radius ?? 38,
            startRatio: 0.7,
          ),
          isShowIcon
              ? Assets.icons.iconMessage
                  .image(width: iconWidth ?? 35.w, height: iconHeight ?? 35.w)
              : Container(),
        ],
      ),
    );
  }
}
