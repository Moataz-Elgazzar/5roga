import 'package:app_5roga/core/routes/navigator.dart';
import 'package:app_5roga/core/routes/routes.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:app_5roga/features/userHome/data/models/catogery.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Categorycard extends StatelessWidget {
  const Categorycard({super.key, required this.model});
  final CategoryModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushTo(context, Routes.categoryDetails, extra: model);
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(color: AppColors.wightColor, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Image.asset(model.image, width: 80, fit: BoxFit.contain)),
              const Gap(5),
              Text(
                model.title.tr(),
                style: TextStyles.size16.copyWith(color: AppColors.darkColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
