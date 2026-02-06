import 'package:app_5roga/core/constants/app_images.dart';
import 'package:app_5roga/core/routes/navigator.dart';
import 'package:app_5roga/core/routes/routes.dart';
import 'package:app_5roga/core/services/firestoreServices/firestore_services.dart';
import 'package:app_5roga/core/services/notification/local_notification.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:app_5roga/features/userHome/data/models/catogery.dart';
import 'package:app_5roga/features/userHome/data/models/mode.dart';
import 'package:app_5roga/features/userHome/data/models/placemodel.dart';
import 'package:app_5roga/features/userHome/presentation/widgets/category.dart';
import 'package:app_5roga/features/userHome/presentation/widgets/mode.dart';
import 'package:app_5roga/features/userHome/presentation/widgets/picked.dart';
import 'package:app_5roga/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key, this.models});
  final List<PlaceModel>? models;
  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  List<CategoryModel> categories = model;
  List<ModeModel> modes = model2;
  bool get isDark => themeNotifier.value == ThemeMode.dark;

  int activeIndex = 0;
  List<Widget> images = [Image.asset(AppImages.skyPng, width: double.infinity, fit: BoxFit.cover), Image.asset(AppImages.filmPng, width: double.infinity, fit: BoxFit.cover), Image.asset(AppImages.trainDeathPng, width: double.infinity, fit: BoxFit.cover), Image.asset(AppImages.chickenPng, width: double.infinity, fit: BoxFit.cover)];

  @override
  void initState() {
    LocalNotificationService.requestNotificationPermission();
    LocalNotificationService.weeklySchduledNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FutureBuilder(
                      future: FirestoreServices.getUserData(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return CircleAvatar(radius: 40, backgroundImage: const AssetImage(AppImages.profilePng), backgroundColor: AppColors.inputColor.withValues(alpha: 0.8));
                        } else {
                          final userdata = snapshot.data!.data() as Map<String, dynamic>;
                          final String? imageUrl = userdata['image'];
                          return CircleAvatar(radius: 40, backgroundImage: imageUrl == null ? const AssetImage(AppImages.profilePng) : CachedNetworkImageProvider(imageUrl), backgroundColor: AppColors.inputColor.withValues(alpha: 0.8));
                        }
                      },
                    ),
                    const Gap(10),
                    Expanded(
                      child: FutureBuilder(
                        future: FirestoreServices.getUserData(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return const SizedBox();
                          }
                          final userData = snapshot.data!.data() as Map<String, dynamic>;
                          final String? name = userData['name'];
                          return Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Hello".tr(),
                                  style: TextStyles.size18.copyWith(color: isDark ? AppColors.wightColor : AppColors.primaryColor, fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: name?.split(' ').first,
                                  style: TextStyles.size18.copyWith(color: isDark ? AppColors.wightColor : AppColors.darkColor, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const Gap(30),
                CarouselSlider.builder(
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index, int pageViewIndex) {
                    return ClipRRect(borderRadius: BorderRadiusGeometry.circular(10), child: images[index]);
                  },
                  options: CarouselOptions(
                    height: 150,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    onPageChanged: (index, reason) {
                      setState(() {
                        activeIndex = index;
                      });
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                const Gap(10),
                Center(
                  child: AnimatedSmoothIndicator(
                    activeIndex: activeIndex,
                    count: images.length,
                    effect: ExpandingDotsEffect(activeDotColor: AppColors.primaryColor, dotColor: isDark ? AppColors.wightColor : AppColors.inputColor.withValues(alpha: 0.5), dotHeight: 10, dotWidth: 10, spacing: 5),
                  ),
                ),
                const Gap(15),
                Category(models: categories),
                const Gap(20),
                Text("Your Choice".tr(), style: TextStyles.size20),
                const Gap(20),
                Mode(models2: modes),
                const Gap(20),
                Row(
                  children: [
                    Expanded(child: Text("Picked_for_You".tr(), style: TextStyles.size20)),
                    TextButton(
                      style: TextButton.styleFrom(overlayColor: Colors.transparent, padding: const EdgeInsets.all(0)),
                      onPressed: () {
                        pushTo(context, Routes.choosen);
                      },
                      child: Text("see all".tr(), style: TextStyles.size16.copyWith(color: isDark ? AppColors.wightColor : AppColors.primaryColor)),
                    ),
                  ],
                ),
                const Gap(20),
                const Picked(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
