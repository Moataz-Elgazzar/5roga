import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/features/adminHome/presentation/pages/adminhome_screen.dart';
import 'package:app_5roga/features/userProfile/presentation/pages/userProfile_screen.dart';
import 'package:app_5roga/main.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  List<Widget> screens = [const AdminHomeScreen(), const UserProfileScreen()];
  int currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final extra = GoRouterState.of(context).extra;
    if (extra is int) {
      setState(() {
        currentIndex = extra;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _ = context.locale;
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        return Scaffold(
          body: IndexedStack(index: currentIndex, children: screens),
          bottomNavigationBar: ConvexAppBar(
            shadowColor: AppColors.primaryColor,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            initialActiveIndex: currentIndex,
            activeColor: AppColors.primaryColor,
            backgroundColor: AppColors.backGroundColor,
            color: AppColors.inputColor,
            style: TabStyle.react,
            items: [
              TabItem(icon: Icons.home, title: "home".tr()),
              TabItem(icon: Icons.person, title: "profile".tr()),
            ],
          ),
        );
      },
    );
  }
}
