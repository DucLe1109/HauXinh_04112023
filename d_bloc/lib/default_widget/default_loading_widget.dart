import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class DefaultLoadingWidget extends StatelessWidget {
  const DefaultLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: GFLoader(type: GFLoaderType.ios, size: GFSize.LARGE),
    );
  }
}

void showLoadingDialog(BuildContext context) {
  showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.3),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child:
              Opacity(opacity: a1.value, child: const DefaultLoadingWidget()),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: false,
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      });
}
