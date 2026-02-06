import 'package:app_5roga/core/routes/navigator.dart';
import 'package:app_5roga/core/routes/routes.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/features/userHome/data/models/placemodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key, required this.model});
  final PlaceModel model;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: CachedNetworkImage(imageUrl: model.mainImage ?? "", height: 300, width: double.infinity, fit: BoxFit.cover),
            ),
          ),
          PositionedDirectional(
            top: 40,
            start: 20,
            child: IconButton(
              onPressed: () {
                pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
            ),
          ),
          Positioned(
            top: 270,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.backGroundColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: model.menuImage?.length,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, mainAxisExtent: 200),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          pushTo(context, Routes.fullScreen, extra: model.menuImage![index]);
                        },
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(color: AppColors.wightColor, borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(imageUrl: model.menuImage![index], fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
