import 'dart:developer';

import 'package:app_5roga/components/buttons/main_button_custom.dart';
import 'package:app_5roga/components/inputs/custome_password.dart';
import 'package:app_5roga/components/inputs/custome_text_form_field%20copy.dart';
import 'package:app_5roga/core/constants/app_images.dart';
import 'package:app_5roga/core/functions/dialog.dart';
import 'package:app_5roga/core/functions/validation.dart';
import 'package:app_5roga/core/routes/navigator.dart';
import 'package:app_5roga/core/routes/routes.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:app_5roga/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:app_5roga/features/auth/presentation/cubit/auth_state.dart';
import 'package:app_5roga/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool get isDark => themeNotifier.value == ThemeMode.dark;
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return BlocListener<AuthCubit, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is AuthLoadingState) {
          showLoadingDialog(context);
        } else if (state is AuthSuccessState) {
          pop(context);
          if (state.role == 'admin') {
            goToBase(context, Routes.adminMain);
          } else if (state.role == 'user') {
            goToBase(context, Routes.userMain);
          }
          log('login success');
        } else if (state is AuthErrorState) {
          pop(context);
          showErrorDialog(context, 'حدث خطأ ما');
          log('login failed');
        }
      },
      child: ValueListenableBuilder(
        valueListenable: themeNotifier,
        builder: (context, value, child) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
              child: SafeArea(
                child: Form(
                  key: cubit.formKey,
                  child: SingleChildScrollView(
                    clipBehavior: Clip.none,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("login".tr(), style: TextStyles.size20),
                        const Gap(18),
                        Text('البريد الالكتروني', style: TextStyles.size14.copyWith(color: AppColors.darkColor)),
                        const Gap(12),
                        CustomeTextFormField(
                          inputColor: AppColors.inputColor,
                          hintText: 'example.com@',
                          color: AppColors.inputColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          keyboardType: TextInputType.emailAddress,
                          controller: cubit.emailController,
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'ادخل البريد الالكتروني';
                            } else if (!validationEmail(value)) {
                              return 'ادخل بريد الكتروني صحيح';
                            }
                            return null;
                          },
                        ),
                        const Gap(12),
                        Text('كلمة السر', style: TextStyles.size14.copyWith(color: AppColors.darkColor)),
                        const Gap(12),
                        CustomePassword(
                          keyboardType: TextInputType.multiline,
                          controller: cubit.passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'ادخل كلمة السر';
                            } else if (!validationPassword(value)) {
                              return 'ادخل كلمة سر صحيحة';
                            }
                            return null;
                          },
                        ),
                        const Gap(8),
                        Align(
                          alignment: AlignmentGeometry.centerLeft,
                          child: TextButton(
                            style: TextButton.styleFrom(padding: const EdgeInsets.all(0), overlayColor: Colors.transparent),
                            onPressed: () {
                              pushTo(context, Routes.forgetPassword);
                            },
                            child: const Text('هل نسيت كلمة السر؟', style: TextStyles.size14),
                          ),
                        ),
                        const Gap(50),
                        MainButtonCustom(
                          title: 'تسجيل الدخول',
                          onPressed: () {
                            if (cubit.formKey.currentState!.validate()) {
                              cubit.login();
                            }
                          },
                          backgroundColor: AppColors.primaryColor,
                          textColor: AppColors.wightColor,
                        ),
                        const Gap(50),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            const Gap(8),
                            Text('او', style: TextStyles.size14.copyWith()),
                            const Gap(8),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const Gap(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(flex: 2),
                            Social(
                              image: AppImages.googlePng,
                              width: 50,
                              onTap: () async {
                                final user = await cubit.signInWithGoogle();
                                final doc = await FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).get(const GetOptions(source: Source.server));
                                final role = doc['role'];
                                try {
                                  if (user != null) {
                                    if (role == 'admin') {
                                      goToBase(context, Routes.adminMain);
                                    } else if (role == 'user') {
                                      goToBase(context, Routes.userMain);
                                    }
                                  }
                                } on Exception catch (_) {
                                  showErrorDialog(context, 'فشل تسجيل الدخول');
                                }
                              },
                            ),
                            const Gap(10),
                            Social(image: AppImages.applePng, width: 50, onTap: () {}),
                            const Spacer(flex: 2),
                          ],
                        ),
                        const Gap(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('ليس لديك حساب ؟', style: TextStyles.size14),
                            TextButton(
                              onPressed: () {
                                pushWithReplacement(context, Routes.register);
                              },
                              child: const Text('أنشئ حساب', style: TextStyles.size14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    navigatorKey.currentContext!.read<AuthCubit>().emailController.dispose();
    navigatorKey.currentContext!.read<AuthCubit>().passwordController.dispose();
    super.dispose();
  }
}

class Social extends StatelessWidget {
  const Social({super.key, required this.image, this.onTap, required int width});

  final String image;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.wightColor,
            border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.5)),
          ),
          child: Image.asset(image),
        ),
      ),
    );
  }
}
