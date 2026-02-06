import 'package:app_5roga/core/functions/loading.dart';
import 'package:app_5roga/core/services/firestoreServices/firestore_services.dart';
import 'package:app_5roga/features/userHome/data/models/placemodel.dart';
import 'package:app_5roga/features/userHome/presentation/widgets/picked_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GridPlaces extends StatelessWidget {
  const GridPlaces({super.key, this.category, this.subCategory, this.modeCategory});

  final String? category;
  final String? subCategory;
  final String? modeCategory;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestoreServices.getPlace(category, subCategory, modeCategory),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: AppLoadingScreen());
        }
        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: snapshot.data?.docs.length,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, mainAxisExtent: 320),
          itemBuilder: (BuildContext context, int index) {
            final PlaceModel model = PlaceModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
            return PickedCard(model: model);
          },
        );
      },
    );
  }
}
