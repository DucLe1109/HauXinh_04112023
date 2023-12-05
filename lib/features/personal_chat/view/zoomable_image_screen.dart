import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ZoomableImageScreen extends StatelessWidget {
  const ZoomableImageScreen({super.key, this.uri = '', this.url = ''});

  final String uri;
  final String url;

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      onDismissed: () => Navigator.of(context).pop(),
      minRadius: 10.w,
      maxRadius: 10.w,
      direction: DismissiblePageDismissDirection.multi,
      reverseDuration: const Duration(milliseconds: 250),
      child: InteractiveViewer(
        panEnabled: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.w),
                child: Hero(
                  tag: url.isNotEmpty ? url : uri,
                  child: url.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: url,
                        )
                      : FileImage(File(uri)) as Widget,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
