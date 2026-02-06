import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late SharedPreferences pref;

  static const String konBoarding = "onBoarding";
  static const String kDarkMode = "DarkMode";

  static init() async {
    pref = await SharedPreferences.getInstance();
  }

  static isonBoardigSeen() async {
    await pref.setBool(konBoarding, true);
  }

  static isdark(bool value) async {
    await pref.setBool(kDarkMode, value);
  }

  static bool getisBoardingSeen() {
    return pref.getBool(konBoarding) ?? false;
  }

  static bool getDarkMode() {
    return pref.getBool(kDarkMode) ?? false;
  }
}
