import 'package:app_5roga/core/functions/extension.dart';
import 'package:app_5roga/core/routes/routes.dart';
import 'package:flutter/widgets.dart';

class TextStyles {
  static const TextStyle size14 = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);

  static final TextStyle size16 = TextStyle(fontSize: 16, fontWeight: navigatorKey.currentContext?.isArabic == true ? FontWeight.w400 : FontWeight.w500);

  static const TextStyle size18 = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);

  static const TextStyle size20 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);

  static const TextStyle size24 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
}
