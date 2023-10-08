import 'package:flutter/material.dart';

enum TranslateDirection { left, right, down, up }

class TranslationFadeIn extends StatefulWidget {
  const TranslationFadeIn({
    required this.mChild,
    required this.translateDirection,
    super.key,
    this.delay = Duration.zero,
  });

  final Widget? mChild;
  final Duration delay;
  final TranslateDirection translateDirection;

  @override
  State<TranslationFadeIn> createState() => _TranslationFadeInState();
}

class _TranslationFadeInState extends State<TranslationFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _animation;
  late Tween<double> _opacityTween;
  late Tween<double> _translateYTween;
  late Tween<double> _translateXTween;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
    _opacityTween = Tween(begin: 0, end: 1);

    switch (widget.translateDirection) {
      case TranslateDirection.left:
        _translateXTween = Tween(begin: 120, end: 0);
        break;
      case TranslateDirection.right:
        _translateXTween = Tween(begin: -120, end: 0);
        break;
      case TranslateDirection.down:
        _translateYTween = Tween(begin: -120, end: 0);
        break;
      case TranslateDirection.up:
        _translateYTween = Tween(begin: 120, end: 0);
        break;
    }
    Future.delayed(
      widget.delay,
      () {
        _animation.forward();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _animation, curve: Curves.decelerate),
      builder: (context, child) => Opacity(
        opacity: _opacityTween.evaluate(_animation),
        child: Transform.translate(
          offset: getOffsetByTranslateDirection(),
          child: widget.mChild,
        ),
      ),
    );
  }

  Offset getOffsetByTranslateDirection() {
    if (widget.translateDirection == TranslateDirection.up ||
        widget.translateDirection == TranslateDirection.down) {
      return Offset(
        0,
        _translateYTween.evaluate(_animation),
      );
    } else {
      return Offset(
        _translateXTween.evaluate(_animation),
        0,
      );
    }
  }
}
