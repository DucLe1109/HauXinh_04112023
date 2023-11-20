import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

abstract class BaseStateFulWidget extends StatefulWidget {
  const BaseStateFulWidget({super.key});
}

abstract class BaseStateFulWidgetState<T extends BaseStateFulWidget>
    extends State<T> {
  int toastDuration = 3000;
  int toastAnimationDuration = 600;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showLoading({
    required BuildContext context,
    required Widget loadingWidget,
  }) {
    showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: false,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(opacity: a1.value, child: loadingWidget),
        );
      },
    );
  }

  void hideLoading(BuildContext context) {
    context.pop();
  }

  void showToast({
    required ToastType toastType,
    required BuildContext context,
    required String title,
    required String description,
  }) {
    switch (toastType) {
      case ToastType.warning:
        MotionToast.warning(
          animationDuration: Duration(milliseconds: toastAnimationDuration),
          toastDuration: Duration(milliseconds: toastDuration),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          iconType: IconType.cupertino,
          animationCurve: Curves.easeOut,
          description: Text(
            description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ).show(context);
        break;
      case ToastType.error:
        MotionToast.error(
          animationDuration: Duration(milliseconds: toastAnimationDuration),
          toastDuration: Duration(milliseconds: toastDuration),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          iconType: IconType.cupertino,
          animationCurve: Curves.easeOut,
          description: Text(
            description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ).show(context);
        break;
      case ToastType.info:
        MotionToast.info(
          animationDuration: Duration(milliseconds: toastAnimationDuration),
          toastDuration: Duration(milliseconds: toastDuration),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          iconType: IconType.cupertino,
          animationCurve: Curves.easeOut,
          description: Text(
            description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ).show(context);
        break;
      case ToastType.success:
        MotionToast.success(
          width: 320.w,
          height: 60.w,
          animationDuration: Duration(milliseconds: toastAnimationDuration),
          toastDuration: Duration(milliseconds: toastDuration),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          iconType: IconType.cupertino,
          animationCurve: Curves.easeOut,
          description: Text(
            description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ).show(context);
        break;
      case ToastType.delete:
        MotionToast.delete(
          animationDuration: Duration(milliseconds: toastAnimationDuration),
          toastDuration: Duration(milliseconds: toastDuration),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          iconType: IconType.cupertino,
          animationCurve: Curves.easeOut,
          description: Text(
            description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ).show(context);
        break;
    }
  }
}

enum ToastType { warning, error, info, success, delete }
