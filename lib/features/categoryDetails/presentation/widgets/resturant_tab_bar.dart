import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:app_5roga/features/categoryDetails/presentation/widgets/grid_places.dart';
import 'package:app_5roga/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ResturantTabBar extends StatelessWidget {
  const ResturantTabBar({super.key});
  bool get isDark => themeNotifier.value == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            tabs: [
              Tab(text: "breakfast".tr()),
              Tab(text: "chicken".tr()),
              Tab(text: "burger".tr()),
              Tab(text: "shawarma".tr()),
              Tab(text: "pizza".tr()),
              Tab(text: "asianFood".tr()),
              Tab(text: "easternFood".tr()),
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
                GridPlaces(category: "restaurant", subCategory: "breakfast"),
                GridPlaces(category: "restaurant", subCategory: "chicken"),
                GridPlaces(category: "restaurant", subCategory: "burger"),
                GridPlaces(category: "restaurant", subCategory: "shawarma"),
                GridPlaces(category: "restaurant", subCategory: "pizza & pasta"),
                GridPlaces(category: "restaurant", subCategory: "asianFood"),
                GridPlaces(category: "restaurant", subCategory: "easternFood"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
