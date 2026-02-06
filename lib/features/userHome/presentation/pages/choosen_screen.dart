import 'package:app_5roga/core/functions/loading.dart';
import 'package:app_5roga/core/routes/navigator.dart';
import 'package:app_5roga/core/services/firestoreServices/firestore_services.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:app_5roga/features/userHome/data/models/placemodel.dart';
import 'package:app_5roga/features/userHome/presentation/widgets/picked_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChoosenScreen extends StatelessWidget {
  const ChoosenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _ = context.locale;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text("Picked_for_You".tr(), style: TextStyles.size20),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                StreamBuilder(
                  stream: FirestoreServices.filterPlace(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: AppLoadingScreen());
                    }
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data?.docs.length,
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, mainAxisExtent: 320),
                      itemBuilder: (context, index) {
                        final PlaceModel model = PlaceModel.fromJson(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                        return PickedCard(model: model);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
