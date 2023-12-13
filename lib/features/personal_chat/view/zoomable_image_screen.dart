// ignore_for_file: use_late_for_private_fields_and_variables

import 'dart:io';

import 'package:boilerplate/core/global_variable.dart';
import 'package:boilerplate/widgets/custom_interact_viewer.dart';
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
  final GlobalKey _interactiveViewerKey = GlobalKey();

  late bool _canPop;
  late CustomTransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();

    _canPop = true;
    _transformationController = CustomTransformationController();
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
    return DismissiblePage(
      dragSensitivity: 1,
      disabled: !_canPop,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      onDismissed: () => Navigator.of(context).pop(),
      minRadius: 10.w,
      maxRadius: 10.w,
      direction: DismissiblePageDismissDirection.multi,
      reverseDuration: const Duration(milliseconds: 250),
      child: _buildImage(),
    );
  }

  Center _buildImage() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.w),
          child: Hero(
            tag: widget.url.isNotEmpty ? widget.url : widget.uri,
            child: widget.url.isNotEmpty
                ? CustomInteractiveViewer(
                    // onDoubleTap: _handleDoubleTap,
                    // onDoubleTapDown: (details) => _doubleTapDetails = details,
                    transformationController: _transformationController,
                    minScale: 1,
                    maxScale: 3,
                    key: _interactiveViewerKey,
                    onInteractionEnd: onScaleImageDone,
                    child: CachedNetworkImage(
                      imageUrl: widget.url,
                    ),
                  )
                : CustomInteractiveViewer(
                    // onDoubleTap: _handleDoubleTap,
                    // onDoubleTapDown: (details) => _doubleTapDetails = details,
                    onInteractionEnd: onScaleImageDone,
                    transformationController: _transformationController,
                    minScale: 1,
                    maxScale: 3,
                    key: _interactiveViewerKey,
                    child: Image.file(
                      File(widget.uri),
                    )),
          ),
        ),
      ),
    );
  }

  void onScaleImageDone(ScaleEndDetails details) {
    setState(() {
      _canPop = _transformationController.value.row0.x == 1;
    });
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
    } else {
      end = Matrix4.identity();
    }

    _animation = Matrix4Tween(begin: _transformationController.value, end: end)
        .animate(
            CurveTween(curve: Curves.easeOut).animate(_animationController));

    _animationController.forward(from: 0);

    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        setState(() {
          _canPop = _transformationController.value.row0.x == 1;
        });
      },
    );
  }
}
