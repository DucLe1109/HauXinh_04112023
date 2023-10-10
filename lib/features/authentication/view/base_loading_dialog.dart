import 'package:boilerplate/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

class BaseLoadingDialog extends StatelessWidget {
  const BaseLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const NutsActivityIndicator(
            endRatio: 0.85,
            animationDuration: Duration(milliseconds: 500),
            activeColor: Colors.blue,
            inactiveColor: Colors.white,
            tickCount: 24,
            relativeWidth: 0.1,
            radius: 38,
            startRatio: 0.7,
          ),
          Assets.icons.iconMessage.image(width: 40, height: 40),
        ],
      ),
    );
  }
}
