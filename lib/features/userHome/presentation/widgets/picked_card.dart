import 'package:app_5roga/core/functions/extension.dart';
import 'package:app_5roga/core/routes/navigator.dart';
import 'package:app_5roga/core/routes/routes.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:app_5roga/features/userHome/data/models/placemodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PickedCard extends StatelessWidget {
  const PickedCard({super.key, required this.model});
  final PlaceModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushTo(context, Routes.userDetails, extra: model);
      },
      child: Container(
        width: 180,
        decoration: BoxDecoration(color: AppColors.wightColor, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Hero(
                tag: model.id ?? "",
                child: CachedNetworkImage(imageUrl: model.mainImage ?? '', height: 150, width: double.infinity, fit: BoxFit.cover),
              ),
            ),
            const Gap(5),
            Text(
              context.isArabic ? model.arName ?? '' : model.enName ?? '',
              style: context.isArabic ? TextStyles.size20.copyWith(color: AppColors.darkColor) : TextStyles.size18.copyWith(color: AppColors.darkColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(5),
            Padding(
              padding: EdgeInsets.only(right: context.isArabic ? 10 : 0, left: context.isArabic ? 0 : 10),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const Gap(5),
                  Text(model.rating.toString(), style: TextStyles.size16.copyWith(color: AppColors.darkColor)),
                ],
              ),
            ),
            const Gap(5),
            Padding(
              padding: EdgeInsets.only(right: context.isArabic ? 10 : 0, left: context.isArabic ? 0 : 10),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: AppColors.primaryColor),
                  const Gap(5),
                  Expanded(
                    child: Text("${model.openHour} : ${model.closeHour}", style: TextStyles.size16.copyWith(color: AppColors.darkColor)),
                  ),
                ],
              ),
            ),
            const Gap(5),
            Padding(
              padding: EdgeInsets.only(right: context.isArabic ? 10 : 0, left: context.isArabic ? 0 : 10),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: AppColors.primaryColor),
                  const Gap(5),
                  Expanded(
                    child: Text(
                      model.address ?? '',
                      style: TextStyles.size16.copyWith(color: AppColors.darkColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
