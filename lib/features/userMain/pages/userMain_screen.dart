import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/features/user5rogty/presentation/pages/user5rogty_screen.dart';
import 'package:app_5roga/features/userFavorite/presentation/pages/userFavorite_screen.dart';
import 'package:app_5roga/features/userHome/presentation/pages/userhome_screen.dart';
import 'package:app_5roga/features/userProfile/presentation/pages/userProfile_screen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UsermainScreenState();
}

class _UsermainScreenState extends State<UserMainScreen> {
  List<Widget> screens = [const UserHomeScreen(), const User5rogtyScreen(), const UserFavoriteScreen(), const UserProfileScreen()];
  int currentIndex = 0;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   final extra = GoRouterState.of(context).extra;
  //   if (extra is int) {
  //     setState(() {
  //       currentIndex = extra;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final _ = context.locale;
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
          TabItem(icon: Icons.checklist_rtl_outlined, title: "5rogty".tr()),
          TabItem(icon: Icons.favorite, title: "favorite".tr()),
          TabItem(icon: Icons.person, title: "profile".tr()),
        ],
      ),
    );
  }
}
