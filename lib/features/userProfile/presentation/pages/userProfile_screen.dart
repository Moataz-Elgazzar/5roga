import 'dart:developer';
import 'dart:io';

import 'package:app_5roga/components/buttons/main_button_custom.dart';
import 'package:app_5roga/components/inputs/custome_text_form_field%20copy.dart';
import 'package:app_5roga/core/constants/app_images.dart';
import 'package:app_5roga/core/functions/dialog.dart';
import 'package:app_5roga/core/functions/extension.dart';
import 'package:app_5roga/core/functions/loading.dart';
import 'package:app_5roga/core/routes/navigator.dart';
import 'package:app_5roga/core/routes/routes.dart';
import 'package:app_5roga/core/services/firestoreServices/firestore_services.dart';
import 'package:app_5roga/core/services/local/shered_prefrences.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:app_5roga/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:app_5roga/features/auth/presentation/cubit/auth_state.dart';
import 'package:app_5roga/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File? imagePath;
  late Future<DocumentSnapshot> _userDataFuture;
  bool get isDark => themeNotifier.value == ThemeMode.dark;

  @override
  void initState() {
    super.initState();

    _userDataFuture = FirestoreServices.getUserData();
  }

  void _refreshUserData() {
    setState(() {
      _userDataFuture = FirestoreServices.getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _ = context.locale;
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("profile".tr(), style: TextStyles.size24.copyWith(color: isDark ? AppColors.wightColor : AppColors.primaryColor)),
          ),
          body: BlocListener<AuthCubit, AuthState>(
            listener: (BuildContext context, state) {
              if (state is AuthLoadingState) {
                showLoadingDialog(context);
              } else if (state is AuthSuccessState) {
                pop(context);
                log('updated success');
                _refreshUserData();
              } else if (state is AuthErrorState) {
                pop(context);
                showErrorDialog(context, 'حدث خطأ ما');
                log('updated failed');
              }
            },
            child: FutureBuilder(
              future: _userDataFuture,
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: AppLoadingScreen());
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('لا توجد بيانات للمستخدم'));
                }
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final String? name = userData['name'];
                final String? email = userData['email'];
                final String? imageUrl = userData['image'];
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      profileImage(context, imageUrl, name),
                      const Gap(20),
                      CustomeTextFormField(readOnly: true, hintText: name, color: AppColors.inputColor),

                      const Gap(20),
                      CustomeTextFormField(readOnly: true, hintText: email, color: AppColors.inputColor),

                      const Gap(20),
                      darkMode(context, mode),

                      const Gap(20),
                      language(context),
                    ],
                  ),
                );
              },
            ),
          ),

          bottomNavigationBar: logOut(context),
        );
      },
    );
  }

  Row profileImage(BuildContext context, String? imageUrl, String? name) {
    return Row(
      children: [
        Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                uploadImageFromcameraOrGallery(context);
              },
              child: CircleAvatar(
                radius: 40,
                backgroundImage: imagePath != null
                    ? FileImage(imagePath!) as ImageProvider
                    : (imageUrl != null)
                    ? CachedNetworkImageProvider(imageUrl)
                    : const AssetImage(AppImages.profilePng),
                backgroundColor: AppColors.inputColor.withValues(alpha: 0.8),
              ),
            ),
            Positioned(
              top: 60,
              right: 10,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.backGroundColor),
                child: const Icon(Icons.photo_camera, color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
        const Gap(10),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Hello".tr(),
                  style: TextStyles.size18.copyWith(color: isDark ? AppColors.wightColor : AppColors.primaryColor, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: name?.split(' ').first,
                  style: TextStyles.size18.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> uploadImageFromcameraOrGallery(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(color: AppColors.primaryColor.withValues(alpha: 0.1)),
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              MainButtonCustom(
                title: "camera".tr(),
                onPressed: () {
                  uploadImages(isCamera: true);
                },
                textColor: AppColors.wightColor,
                backgroundColor: AppColors.primaryColor.withValues(alpha: 0.5),
              ),
              const Gap(10),
              MainButtonCustom(
                title: "gallery".tr(),
                onPressed: () {
                  uploadImages(isCamera: false);
                },
                textColor: AppColors.wightColor,
                backgroundColor: AppColors.primaryColor.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row darkMode(BuildContext context, ThemeMode mode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("dark_mode".tr(), style: context.isArabic ? TextStyles.size20 : TextStyles.size18),
        IconButton(
          style: IconButton.styleFrom(overlayColor: Colors.transparent),
          onPressed: () {
            final isDark = themeNotifier.value == ThemeMode.dark;
            themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            SharedPref.isdark(!isDark);
          },
          icon: Icon(mode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode, size: 30, color: AppColors.primaryColor),
        ),
      ],
    );
  }

  Row language(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("language".tr(), style: context.isArabic ? TextStyles.size20 : TextStyles.size18),
        IconButton(
          style: IconButton.styleFrom(overlayColor: Colors.transparent),
          onPressed: () {
            context.setLocale(Locale(context.isArabic ? 'en' : 'ar'));
          },
          icon: const Icon(Icons.language, size: 30, color: AppColors.primaryColor),
        ),
      ],
    );
  }

  Padding logOut(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20, top: 10),
      child: MainButtonCustom(
        title: "logout".tr(),
        onPressed: () {
          context.read<AuthCubit>().signoutUser();
          goToBase(context, Routes.login);
        },
        textColor: AppColors.wightColor,
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  Future<void> uploadImages({required bool isCamera}) async {
    final XFile? file = await ImagePicker().pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
    if (file != null) {
      setState(() {
        imagePath = File(file.path);
        log('image picked');
      });
      pop(context);
      context.read<AuthCubit>().updateData(imagePath);
    }
  }
}
