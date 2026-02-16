import 'package:app_5roga/core/constants/app_images.dart';
import 'package:app_5roga/core/functions/loading.dart';
import 'package:app_5roga/core/routes/navigator.dart';
import 'package:app_5roga/core/routes/routes.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:app_5roga/features/userHome/data/models/placemodel.dart';
import 'package:app_5roga/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UserFavoriteScreen extends StatefulWidget {
  const UserFavoriteScreen({super.key, this.model});
  final List<PlaceModel>? model;
  @override
  State<UserFavoriteScreen> createState() => _UserFavoriteScreenState();
}

class _UserFavoriteScreenState extends State<UserFavoriteScreen> {
  bool get isDark => themeNotifier.value == ThemeMode.dark;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("favorite".tr(), style: TextStyles.size24.copyWith(color: isDark ? AppColors.wightColor : AppColors.primaryColor)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              clipBehavior: Clip.none,
              child: Column(children: [listOfPlaces()]),
            ),
          ),
        );
      },
    );
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> listOfPlaces() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("favoriteList").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: AppLoadingScreen());
        }
        final List<String> favoritesList = List<String>.from(snapshot.data!.data()?['favoriteList'] ?? []);
        if (favoritesList.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: MediaQuery.sizeOf(context).height * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Lottie.asset(AppImages.empty, width: 300, height: 300)),
                Text("noplace".tr()),
              ],
            ),
          );
        }
        return FutureBuilder<List<PlaceModel>>(
          future: Future.wait(
            favoritesList.map((id) async {
              final data = await FirebaseFirestore.instance.collection("places").where("id", isEqualTo: id).get();
              if (data.docs.isNotEmpty) {
                return PlaceModel.fromJson(data.docs.first.data());
              } else {
                return null;
              }
            }),
          ).then((list) => list.whereType<PlaceModel>().toList()),
          builder: (context, snapshot2) {
            if (!snapshot2.hasData) {
              return const Center(child: AppLoadingScreen());
            }
            final List<PlaceModel> favoritePlaces = snapshot2.data!;
            return ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ItemsTile(model: favoritePlaces[index]);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
              itemCount: favoritePlaces.length,
            );
          },
        );
      },
    );
  }
}

class ItemsTile extends StatefulWidget {
  const ItemsTile({super.key, required this.model});

  final PlaceModel? model;

  @override
  State<ItemsTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemsTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushTo(context, Routes.userDetails, extra: widget.model);
      },
      child: Container(
        decoration: BoxDecoration(color: AppColors.primaryColor.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          title: Text(widget.model?.arName ?? '', style: TextStyles.size20.copyWith(color: AppColors.wightColor)),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(imageUrl: widget.model?.mainImage ?? '', width: 80, fit: BoxFit.fill),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${widget.model?.openHour} : ${widget.model?.closeHour}", style: TextStyles.size16.copyWith(color: AppColors.wightColor)),
              Text(widget.model?.address ?? '', style: TextStyles.size16.copyWith(color: AppColors.wightColor)),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text((widget.model?.rating).toString(), style: TextStyles.size18.copyWith(color: AppColors.wightColor)),
              const Icon(Icons.star, color: Colors.amber),
            ],
          ),
        ),
      ),
    );
  }
}
