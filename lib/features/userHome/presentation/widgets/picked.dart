import 'package:app_5roga/core/functions/loading.dart';
import 'package:app_5roga/core/services/firestoreServices/firestore_services.dart';
import 'package:app_5roga/features/userHome/data/models/placemodel.dart';
import 'package:app_5roga/features/userHome/presentation/widgets/picked_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Picked extends StatefulWidget {
  const Picked({super.key});

  @override
  State<Picked> createState() => _PickedState();
}

class _PickedState extends State<Picked> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: StreamBuilder(
        stream: FirestoreServices.filterPlace(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: AppLoadingScreen());
          }
          return ListView.separated(
            clipBehavior: Clip.none,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final PlaceModel model = PlaceModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
              return PickedCard(model: model);
            },
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemCount: snapshot.data!.docs.length,
          );
        },
      ),
    );
  }
}
