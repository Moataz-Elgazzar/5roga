import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomePassword extends StatefulWidget {
  const CustomePassword({super.key, this.validator, this.controller, this.keyboardType});
  
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  @override
  State<CustomePassword> createState() => _CustomePasswordState();
}

class _CustomePasswordState extends State<CustomePassword> {
  bool get isDark => themeNotifier.value == ThemeMode.dark;
  bool obscureText = true;
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
    return TextFormField(
      style: TextStyle(color: isDark ? AppColors.inputColor : AppColors.wightColor),
      keyboardType: widget.keyboardType,
      obscureText: obscureText,
      validator: validate,
      controller: widget.controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: '***********',
        filled: true,
        fillColor: AppColors.wightColor,

        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: AppColors.primaryColor),
            ),
            if (errorMessage != null)
              Tooltip(
                message: "password_rules".tr(),
                child: const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Icon(Icons.info_outline, color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
