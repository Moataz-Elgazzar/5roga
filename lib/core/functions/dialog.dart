import 'package:app_5roga/core/functions/loading.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:flutter/material.dart';

showErrorDialog(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.primaryColor,
      margin: const EdgeInsets.all(20),
      elevation: 0,
      content: Text(message, style: TextStyles.size16.copyWith(color: AppColors.wightColor, fontSize: 16)),
    ),
  );
}

showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Dialog(backgroundColor: Colors.transparent, elevation: 0, child: AppLoadingScreen()),
  );
}
