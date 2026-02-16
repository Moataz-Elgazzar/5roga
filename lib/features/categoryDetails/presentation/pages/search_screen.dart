import 'package:app_5roga/core/routes/navigator.dart';
import 'package:app_5roga/core/services/firestoreServices/firestore_services.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:app_5roga/features/userHome/data/models/placemodel.dart';
import 'package:app_5roga/features/userHome/presentation/widgets/picked_card.dart';
import 'package:app_5roga/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key, required this.searchKey});
  final String searchKey;
  bool get isDark => themeNotifier.value == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new, color: isDark ? AppColors.wightColor : AppColors.primaryColor),
            ),
            title: Text("search".tr(), style: TextStyles.size20.copyWith(color: isDark ? AppColors.wightColor : AppColors.primaryColor)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder(
              future: FirestoreServices.searchPlace(searchKey, context.locale.languageCode == 'ar' ? true : false),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('${"error".tr()} ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("noResult".tr(), style: TextStyles.size18));
                } else {
                  final places = snapshot.data!.docs;
                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: places.length,
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, mainAxisExtent: 320),
                    itemBuilder: (BuildContext context, int index) {
                      final PlaceModel model = PlaceModel.fromJson(places[index].data() as Map<String, dynamic>);
                      return PickedCard(model: model);
                    },
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
