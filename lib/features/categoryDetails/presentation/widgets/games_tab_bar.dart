import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:app_5roga/features/categoryDetails/presentation/widgets/grid_places.dart';
import 'package:app_5roga/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GamesTabBar extends StatelessWidget {
  const GamesTabBar({super.key});
  bool get isDark => themeNotifier.value == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            tabs: [
              Tab(text: "snowGames".tr()),
              Tab(text: "trampoline".tr()),
              Tab(text: "bowling".tr()),
              Tab(text: "escapeRoom".tr()),
              Tab(text: "kidsGames".tr()),
              Tab(text: "paintball".tr()),
              Tab(text: "skating".tr()),
              Tab(text: "waterSports".tr()),
            ],
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelStyle: TextStyles.size20,
            labelColor: AppColors.primaryColor,
            unselectedLabelStyle: TextStyles.size16,
            unselectedLabelColor: isDark ? AppColors.wightColor : AppColors.darkColor,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(width: 2, color: AppColors.primaryColor),
              insets: EdgeInsets.only(right: 20),
            ),
            dividerColor: Colors.transparent,
          ),
          const Gap(10),
          const Expanded(
            child: TabBarView(
              children: [
                GridPlaces(category: "themeParks", subCategory: "SnowGames"),
                GridPlaces(category: "themeParks", subCategory: "trampoline"),
                GridPlaces(category: "themeParks", subCategory: "bowling"),
                GridPlaces(category: "themeParks", subCategory: "escapeRoom"),
                GridPlaces(category: "themeParks", subCategory: "kidsGames"),
                GridPlaces(category: "themeParks", subCategory: "paintball"),
                GridPlaces(category: "themeParks", subCategory: "skating"),
                GridPlaces(category: "themeParks", subCategory: "waterSports"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
