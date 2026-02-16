import 'package:app_5roga/core/constants/app_images.dart';
import 'package:app_5roga/core/routes/navigator.dart';
import 'package:app_5roga/core/routes/routes.dart';
import 'package:app_5roga/core/services/firestoreServices/firestore_services.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:app_5roga/features/categoryDetails/presentation/widgets/grid_places.dart';
import 'package:app_5roga/features/userHome/data/models/placemodel.dart';
import 'package:app_5roga/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key, this.models});
  final List<PlaceModel>? models;

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  bool get isDark => themeNotifier.value == ThemeMode.dark;
  final userFuture = FirestoreServices.getUserData();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, value, child) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        profileImage(),
                        const Gap(10),
                        Expanded(child: profileName()),
                      ],
                    ),
                    const Gap(30),
                    addPlace(context),
                    const Gap(20),
                    const GridPlaces(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Row addPlace(BuildContext context) {
    return Row(
      children: [
        Text(
          'كل الاماكن',
          style: TextStyles.size24.copyWith(fontWeight: FontWeight.bold, color: isDark ? AppColors.wightColor : AppColors.darkColor),
        ),
        const Spacer(),
        TextButton(
          style: TextButton.styleFrom(overlayColor: Colors.transparent, padding: EdgeInsets.zero, minimumSize: const Size(50, 30), tapTargetSize: MaterialTapTargetSize.shrinkWrap, alignment: Alignment.centerRight),
          onPressed: () {
            pushTo(context, Routes.addPlace);
          },
          child: Text(
            'اضافة مكان',
            style: TextStyles.size16.copyWith(color: isDark ? AppColors.wightColor : AppColors.primaryColor, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  FutureBuilder<DocumentSnapshot<Object?>> profileImage() {
    return FutureBuilder(
      future: userFuture,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return CircleAvatar(radius: 40, backgroundImage: const AssetImage(AppImages.profilePng), backgroundColor: AppColors.inputColor.withValues(alpha: 0.8));
        } else {
          final userdata = snapshot.data!.data() as Map<String, dynamic>;
          final String? imageUrl = userdata['image'];
          return CircleAvatar(radius: 40, backgroundImage: imageUrl == null ? const AssetImage(AppImages.profilePng) : CachedNetworkImageProvider(imageUrl), backgroundColor: AppColors.inputColor.withValues(alpha: 0.8));
        }
      },
    );
  }

  FutureBuilder<DocumentSnapshot<Object?>> profileName() {
    return FutureBuilder(
      future: userFuture,
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
    );
  }
}
