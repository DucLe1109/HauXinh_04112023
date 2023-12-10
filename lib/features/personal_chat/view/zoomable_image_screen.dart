// ignore_for_file: use_late_for_private_fields_and_variables

import 'dart:io';

import 'package:boilerplate/core/global_variable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ZoomableImageScreen extends StatefulWidget {
  const ZoomableImageScreen({super.key, this.uri = '', this.url = ''});

  final String uri;
  final String url;

  @override
  State<ZoomableImageScreen> createState() => _ZoomableImageScreenState();
}

class _ZoomableImageScreenState extends State<ZoomableImageScreen>
    with SingleTickerProviderStateMixin {
  late bool _canPop;
  late double _scaleValue;
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();

    _canPop = true;
    _scaleValue = 1;
    _transformationController = TransformationController();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: fastDuration))
      ..addListener(() {
        _transformationController.value = _animation!.value;
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onDoubleTapDown: (details) => _doubleTapDetails = details,
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        maxScale: 3,
        transformationController: _transformationController,
        onInteractionUpdate: onScaleImage,
        child: DismissiblePage(
          disabled: !_canPop,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          onDismissed: () => Navigator.of(context).pop(),
          minRadius: 10.w,
          maxRadius: 10.w,
          direction: DismissiblePageDismissDirection.multi,
          reverseDuration: const Duration(milliseconds: 250),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.w),
                child: Hero(
                  tag: widget.url.isNotEmpty ? widget.url : widget.uri,
                  child: widget.url.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: widget.url,
                        )
                      : FileImage(File(widget.uri)) as Widget,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onScaleImage(ScaleUpdateDetails details) {
    if (details.scale != 1) {
      _scaleValue = details.scale;
    }
    if (details.pointerCount == 1) {
      if (_scaleValue > 1) {
        setState(() {
          _canPop = false;
        });
      } else if (_scaleValue < 1) {
        setState(() {
          _canPop = true;
        });
      }
    }
  }

  void _handleDoubleTap() {
    final position = _doubleTapDetails?.localPosition;
    const double scale = 2;
    final zoomed = Matrix4.identity()
      ..translate(-position!.dx * (scale - 1), -position.dy * (scale - 1))
      ..scale(scale);

    Matrix4 end;

    if (_transformationController.value.isIdentity()) {
      end = zoomed;
      setState(() {
        _canPop = false;
      });
    } else {
      end = Matrix4.identity();
      setState(() {
        _canPop = true;
      });
    }

    _animation = Matrix4Tween(begin: _transformationController.value, end: end)
        .animate(
            CurveTween(curve: Curves.easeOut).animate(_animationController));

    _animationController.forward(from: 0);
  }
}
