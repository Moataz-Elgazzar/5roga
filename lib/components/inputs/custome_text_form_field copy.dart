import 'package:app_5roga/core/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomeTextFormField extends StatefulWidget {
  const CustomeTextFormField({super.key, this.validator, this.controller, this.prefixIcon, this.hintText, this.suffixIcon, this.color, this.maxLines, this.fontSize, this.readOnly = false, this.keyboardType, this.textAlign = TextAlign.start, this.onTap, this.textInputAction, this.onFieldSubmitted, this.onChanged, this.fontWeight, this.enabledBorder, this.height, this.inputColor});

  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final String? hintText;
  final Widget? suffixIcon;
  final Color? color;
  final int? maxLines;
  final double? fontSize;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final Function()? onTap;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final FontWeight? fontWeight;
  final InputBorder? enabledBorder;
  final double? height;
  final Color? inputColor;
  @override
  State<CustomeTextFormField> createState() => _CustomeTextFormFieldState();
}

class _CustomeTextFormFieldState extends State<CustomeTextFormField> {
  String? errorMessage;

  String? validate(String? value) {
    final String? result = widget.validator?.call(value);
    setState(() {
      errorMessage = result;
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: TextFormField(
        style: TextStyle(color: widget.inputColor),
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        textInputAction: widget.textInputAction,
        onTap: widget.onTap,
        textAlign: widget.textAlign,
        keyboardType: widget.keyboardType,
        readOnly: widget.readOnly,
        validator: widget.validator,
        controller: widget.controller,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          enabledBorder: widget.enabledBorder,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: widget.color, fontSize: widget.fontSize, fontWeight: FontWeight.w400),
          fillColor: AppColors.wightColor,
          filled: true,
          prefixIcon: widget.prefixIcon,
          contentPadding: const EdgeInsets.all(20),
          suffixIcon: (errorMessage != null && (widget.hintText == "name".tr() || widget.hintText == 'example.com@'))
              ? Tooltip(
                  message: widget.hintText == "name".tr() ? "username_rules".tr() : "email_rules".tr(),
                  child: const Icon(Icons.info_outline, color: Colors.red),
                )
              : widget.suffixIcon,
        ),
      ),
    );
  }
}
