import 'package:app_5roga/core/constants/app_fonts.dart';
import 'package:app_5roga/core/functions/extension.dart';
import 'package:app_5roga/core/routes/routes.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static get lightTheme => ThemeData(
    scaffoldBackgroundColor: AppColors.backGroundColor,
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.backGroundColor, centerTitle: true, surfaceTintColor: Colors.transparent, elevation: 0),
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor, onSurface: AppColors.darkColor),
    fontFamily: navigatorKey.currentContext?.isArabic == true ? AppFonts.cairo : AppFonts.poppins,
    dividerColor: AppColors.inputColor,

    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: AppColors.inputColor.withValues(alpha: 2.0)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
    ),
  );

  static get darkTheme => ThemeData(
    scaffoldBackgroundColor: AppColors.darkColor,
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.darkColor, centerTitle: true, surfaceTintColor: Colors.transparent, elevation: 0),
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor, onSurface: AppColors.wightColor),
    fontFamily: navigatorKey.currentContext?.isArabic == true ? AppFonts.cairo : AppFonts.poppins,
    dividerColor: AppColors.inputColor,
    datePickerTheme: const DatePickerThemeData(backgroundColor: AppColors.primaryColor, headerBackgroundColor: AppColors.primaryColor, headerForegroundColor: AppColors.wightColor),
    timePickerTheme: const TimePickerThemeData(backgroundColor: AppColors.primaryColor, hourMinuteTextColor: AppColors.darkColor, dayPeriodTextColor: AppColors.darkColor, dialHandColor: AppColors.inputColor, dialBackgroundColor: AppColors.darkColor, entryModeIconColor: AppColors.wightColor),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkColor,
      hintStyle: TextStyle(color: AppColors.inputColor.withValues(alpha: 2.0)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
