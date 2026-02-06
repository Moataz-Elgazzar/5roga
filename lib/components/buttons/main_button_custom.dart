import 'package:app_5roga/core/functions/extension.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MainButtonCustom extends StatelessWidget {
  const MainButtonCustom({super.key, this.height = 70, required this.title, required this.onPressed, this.backgroundColor, this.textColor, this.width = double.infinity, this.icon});

  final double height;
  final double width;
  final String title;
  final Function() onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyles.size20.copyWith(color: textColor, fontSize: context.isArabic ? 20 : 18),
            ),
            const Gap(20),
            icon != null ? Icon(icon, size: 30, color: AppColors.wightColor) : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
