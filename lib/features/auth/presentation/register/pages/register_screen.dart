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
import 'package:app_5roga/features/auth/presentation/login/pages/login_screen.dart';
import 'package:app_5roga/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool get isDark => themeNotifier.value == ThemeMode.dark;
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return BlocListener<AuthCubit, AuthState>(
      listener: (BuildContext context, state) {
        if (state is AuthLoadingState) {
          showLoadingDialog(context);
        } else if (state is AuthSuccessState) {
          pop(context);
          goToBase(context, Routes.login);
          log('register success');
        } else if (state is AuthErrorState) {
          pop(context);
          showErrorDialog(context, 'حدث خطأ ما');
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
                        const Text('أنشئ حسابك', style: TextStyles.size20),
                        const Gap(18),
                        Text('الأسم', style: TextStyles.size14.copyWith(color: AppColors.darkColor)),
                        const Gap(10),
                        CustomeTextFormField(
                          inputColor: isDark ? AppColors.inputColor : AppColors.wightColor,
                          hintText: 'الاسم',
                          color: AppColors.inputColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          keyboardType: TextInputType.multiline,
                          controller: cubit.nameController,
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'ادخل الاسم';
                            } else if (!validationUserName(value)) {
                              return 'ادخل الأسم صحيح';
                            }
                            return null;
                          },
                        ),
                        const Gap(10),
                        Text('البريد الالكتروني', style: TextStyles.size14.copyWith(color: AppColors.darkColor)),
                        const Gap(12),
                        CustomeTextFormField(
                          inputColor: isDark ? AppColors.inputColor : AppColors.wightColor,
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
                        const Gap(10),
                        Text('كلمة السر', style: TextStyles.size14.copyWith(color: AppColors.darkColor)),
                        const Gap(10),
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

                        const Gap(20),
                        MainButtonCustom(
                          title: 'إنشاء حساب',
                          onPressed: () {
                            if (cubit.formKey.currentState!.validate()) {
                              cubit.register();
                            }
                          },
                          backgroundColor: AppColors.primaryColor,
                          textColor: AppColors.wightColor,
                        ),
                        const Gap(10),
                        const Row(
                          children: [
                            Expanded(child: Divider()),
                            Gap(8),
                            Text('او', style: TextStyles.size14),
                            Gap(8),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const Gap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(flex: 2),
                            Social(image: AppImages.googlePng, width: 50, onTap: () {}),
                            const Gap(10),
                            Social(image: AppImages.applePng, width: 50, onTap: () {}),
                            const Spacer(flex: 2),
                          ],
                        ),
                        const Gap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('هل لديك حساب بالفعل؟', style: TextStyles.size14),
                            TextButton(
                              onPressed: () {
                                pushWithReplacement(context, Routes.login);
                              },
                              child: const Text('سجل الان', style: TextStyles.size14),
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
}
