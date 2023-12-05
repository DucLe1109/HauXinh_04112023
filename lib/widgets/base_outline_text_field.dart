// ignore_for_file: must_be_immutable

import 'package:boilerplate/core/global_variable.dart';
import 'package:boilerplate/generated/l10n.dart';
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
      this.textStyle,
      this.isRequired = false,
      this.textInputType});

  final TextEditingController controller;
  final FocusNode focusNode;
  final Icon? prefixIcon;
  final String? label;
  final Widget? suffixIcon;
  final TextStyle? textStyle;
  final bool isRequired;
  final TextInputType? textInputType;

  @override
  State<BaseTextField> createState() => _BaseTextFieldState();
}

class _BaseTextFieldState extends State<BaseTextField> {
  String? errorText;

  @override
  void initState() {
    super.initState();

    if (widget.controller.text.isEmpty && widget.isRequired) {
      errorText = S.current.must_be_not_empty;
    }

    widget.controller.addListener(() {
      if (mounted) {
        setState(() {
          if (widget.isRequired && widget.controller.text.trim().isNotEmpty) {
            errorText = null;
          } else if (widget.isRequired &&
              widget.controller.text.trim().isEmpty) {
            errorText = S.current.must_be_not_empty;
          }
        });
      }
    });

    widget.focusNode.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: widget.textInputType,
      cursorColor: Theme.of(context).iconTheme.color?.withOpacity(0.5),
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: widget.textStyle ?? Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
          errorText: errorText,
          errorStyle: const TextStyle(color: Colors.redAccent),
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
