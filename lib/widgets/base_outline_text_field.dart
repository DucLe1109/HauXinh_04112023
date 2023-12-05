import 'package:boilerplate/core/global_variable.dart';
import 'package:boilerplate/injector/injector.dart';
import 'package:boilerplate/services/app_service/app_service.dart';
import 'package:flutter/material.dart';

class BaseTextField extends StatefulWidget {
  const BaseTextField(
      {super.key,
      required this.controller,
      required this.focusNode,
      this.prefixIcon,
      this.label,
      this.suffixIcon,
      this.textStyle});

  final TextEditingController controller;
  final FocusNode focusNode;
  final Icon? prefixIcon;
  final String? label;
  final Widget? suffixIcon;
  final TextStyle? textStyle;

  @override
  State<BaseTextField> createState() => _BaseTextFieldState();
}

class _BaseTextFieldState extends State<BaseTextField> {
  @override
  void initState() {
    super.initState();


    widget.controller.addListener(() {
      setState(() {});
    });

    widget.focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: widget.textStyle ?? Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
          labelStyle:
              TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
          prefixIconColor: Theme.of(context).iconTheme.color,
          suffixIconColor: Theme.of(context).iconTheme.color,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide:
                  BorderSide(color: Theme.of(context).iconTheme.color!)),
          prefixIcon: widget.prefixIcon,
          suffixIcon: isShowTrailing(),
          label: Text(widget.label ?? ''),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          )),
    );
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
    }
    return null;
  }
}
