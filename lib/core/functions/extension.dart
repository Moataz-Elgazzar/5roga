import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

bool isArabic(BuildContext context) {
  return context.locale.languageCode == "ar";

}

extension EasyLocalization on BuildContext {
  bool get isArabic => locale.languageCode == "ar";
}
