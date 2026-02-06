import 'package:app_5roga/core/constants/app_images.dart';
import 'package:easy_localization/easy_localization.dart';

class Onboarding {
  final String title;
  final String subTitle;
  final String image;

  Onboarding({
    required this.title,
    required this.subTitle,
    required this.image,
  });
}

List<Onboarding> onboardingList = [
  Onboarding(
    title: "onboardtitle1".tr(),
    subTitle: "onboarddes1".tr(),
    image: AppImages.boarding1Png,
  ),
  Onboarding(
    title: "onboardtitle2".tr(),
    subTitle: "onboarddes2".tr(),
    image: AppImages.boarding2Png,
  ),
  Onboarding(
    title: "onboardtitle3".tr(),
    subTitle: "onboarddes3".tr(),
    image: AppImages.boarding3Png,
  ),
];
