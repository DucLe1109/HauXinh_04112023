import 'package:flutter/material.dart';

class DTextField extends StatefulWidget {
  const DTextField({
    required this.controller,
    required this.focusNode,
    required this.isPassword,
    super.key,
    this.paddingHorizontal,
    this.paddingVertical,
    this.hintText,
    this.showPasswordIcon,
    this.enabledBorderColor,
    this.enabledBorderWidth,
    this.focusedBorderColor,
    this.focusedBorderWidth,
    this.onSubmitted,
    this.suffixIcon,
    this.hintStyle,
    this.label,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final String? hintText;
  final String? label;

  final Color? focusedBorderColor;
  final Color? enabledBorderColor;
  final double? focusedBorderWidth;
  final double? enabledBorderWidth;

  final Widget? suffixIcon;
  final Widget? showPasswordIcon;
  final TextStyle? hintStyle;

  final Function(String? value)? onSubmitted;

  final bool isPassword;

  @override
  State<DTextField> createState() => _DTextFieldState();
}

class _DTextFieldState extends State<DTextField> {
  late bool isObscureText;

  @override
  void initState() {
    super.initState();
    isObscureText = widget.isPassword;
    widget.controller.addListener(() {
      setState(() {});
    });

    widget.focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(() {});
    widget.focusNode.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return !widget.isPassword

        // TextField(
        //     controller: _emailController,
        //     style: Theme.of(context).textTheme.bodyMedium,
        //     decoration: InputDecoration(
        //       border: InputBorder.none,
        //       hintText: S.current.email,
        //       hintStyle: TextStyle(color: Colors.grey[400]),
        //     ),
        ? TextField(
            style: Theme.of(context).textTheme.bodyMedium,
            keyboardType: TextInputType.text,
            onSubmitted: widget.onSubmitted,
            controller: widget.controller,
            focusNode: widget.focusNode,
            decoration: InputDecoration(
              suffixIcon: isShowTrailing(),
              // contentPadding: EdgeInsets.symmetric(
              //   vertical: widget.paddingVertical ?? 0,
              //   horizontal: widget.paddingHorizontal ?? 0,
              // ),
              border: InputBorder.none,
              hintText: widget.hintText ?? '',
              hintStyle: widget.hintStyle ??
                  TextStyle(
                    color: Colors.grey[400],
                  ),
            ),
          )
        : TextField(
            keyboardType: TextInputType.text,
            obscureText: isObscureText,
            enableSuggestions: !isObscureText,
            autocorrect: !isObscureText,
            onSubmitted: widget.onSubmitted,
            controller: widget.controller,
            focusNode: widget.focusNode,
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: isShowTrailingForPassword(),
              contentPadding: EdgeInsets.symmetric(
                vertical: widget.paddingVertical ?? 0,
                horizontal: widget.paddingHorizontal ?? 0,
              ),
              hintText: widget.hintText ?? '',
              hintStyle: widget.hintStyle ??
                  TextStyle(
                    color: Colors.grey[400],
                  ),
            ),
          );
  }

  Widget? isShowTrailingForPassword() {
    if (widget.suffixIcon != null) {
      if (widget.controller.text.isEmpty && widget.focusNode.hasFocus) {
        return const Text('');
      } else {
        if (widget.focusNode.hasFocus) {
          if (isObscureText) {
            return InkWell(
              child: widget.suffixIcon,
              onTap: () {
                setState(() {
                  isObscureText = !isObscureText;
                });
              },
            );
          } else {
            return InkWell(
              child: widget.showPasswordIcon,
              onTap: () {
                setState(() {
                  isObscureText = !isObscureText;
                });
              },
            );
          }
        } else {
          return null;
        }
      }
    } else {
      return widget.suffixIcon;
    }
  }

  Widget? isShowTrailing() {
    if (widget.suffixIcon != null) {
      if (widget.controller.text.isEmpty) {
        return const Text('');
      } else {
        if (widget.focusNode.hasFocus) {
          return widget.suffixIcon;
        } else {
          return null;
        }
      }
    } else {
      return widget.suffixIcon;
    }
  }

  void showPassword() {}
}
