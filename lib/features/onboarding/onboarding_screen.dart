import 'package:app_5roga/core/functions/onboarding.dart';
import 'package:app_5roga/core/routes/navigator.dart';
import 'package:app_5roga/core/routes/routes.dart';
import 'package:app_5roga/core/services/local/shered_prefrences.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });

                if (currentIndex == onboardingList.length - 1) {
                  Future.delayed(const Duration(seconds: 3), () {
                    SharedPref.isonBoardigSeen();
                    pushWithReplacement(context, Routes.login);
                  });
                }
              },

              itemCount: onboardingList.length,
              itemBuilder: (context, index) {
                return SizedBox.expand(
                  child: Stack(
                    children: [
                      Image.asset(onboardingList[index].image, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 3),
                        child: SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                onboardingList[index].title,
                                style: TextStyles.size24.copyWith(fontWeight: FontWeight.w600, color: AppColors.wightColor),
                              ),
                              const Gap(15),
                              Text(onboardingList[index].subTitle, style: TextStyles.size14.copyWith(color: AppColors.wightColor)),
                              const Gap(20),
                              SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    AnimatedSmoothIndicator(
                                      activeIndex: index,
                                      count: onboardingList.length,
                                      effect: const ExpandingDotsEffect(activeDotColor: AppColors.primaryColor, dotColor: AppColors.wightColor, dotHeight: 7),
                                    ),
                                    if (currentIndex != onboardingList.length - 1)
                                      TextButton(
                                        onPressed: () {
                                          SharedPref.isonBoardigSeen();
                                          pushWithReplacement(context, Routes.login);
                                        },
                                        child: Text(
                                          "skip".tr(),
                                          style: TextStyles.size20.copyWith(color: AppColors.wightColor, fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
