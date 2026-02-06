import 'package:app_5roga/components/buttons/main_button_custom.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ForgetpasswordScreen extends StatelessWidget {
  const ForgetpasswordScreen({super.key});
  bool get isDark => themeNotifier.value == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return BlocListener<AuthCubit, AuthState>(
      listener: (BuildContext context, state) async {
        if (state is AuthLoadingState) {
          showLoadingDialog(context);
        } else if (state is AuthSuccessState) {
          pop(context);
          successDialog(context);
          await Future.delayed(const Duration(seconds: 3), () {
            pushTo(context, Routes.login);
          });
        } else if (state is AuthErrorState) {
          pop(context);
          showErrorDialog(context, 'حدث خطا ما');
        }
      },
      child: ValueListenableBuilder(
        valueListenable: themeNotifier,
        builder: (context, value, child) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: isDark ? AppColors.wightColor : AppColors.darkColor),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('هل نسيت كلمة السر؟', style: TextStyles.size20),
                  const Gap(10),
                  const Text('يرجي ادخال البريد الالكتروني المرتبط بحسابك', style: TextStyles.size14),
                  const Gap(16),
                  const Text('البريد الالكتروني', style: TextStyles.size14),
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
                  const Gap(40),
                  MainButtonCustom(
                    title: 'ارسل الكود',
                    onPressed: () {
                      cubit.resetPassword(cubit.emailController.text);
                    },
                    textColor: AppColors.wightColor,
                    backgroundColor: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> successDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppColors.wightColor,
          children: [
            Image.asset(AppImages.successPng),
            const Center(child: Text('تم إرسال رابط إعادة التعيين إلى بريدك', style: TextStyles.size18)),
          ],
        );
      },
    );
  }
}
