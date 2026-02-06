import 'package:app_5roga/core/constants/app_images.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:flutter/material.dart';

class AppLoadingScreen extends StatefulWidget {
  const AppLoadingScreen({super.key});

  @override
  State<AppLoadingScreen> createState() => _AppLoadingScreenState();
}

class _AppLoadingScreenState extends State<AppLoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const SizedBox(width: 100, height: 100, child: CircularProgressIndicator(strokeWidth: 6, color: AppColors.primaryColor)),
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle),
            child: Center(child: Image.asset(AppImages.logo2Png, width: 50, height: 50, fit: BoxFit.contain)),
          ),
        ],
      ),
    );
  }
}
