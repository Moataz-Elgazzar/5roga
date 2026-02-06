import 'package:app_5roga/core/functions/extension.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:app_5roga/core/utils/text_style.dart';
import 'package:app_5roga/features/placeDetails/data/khorogamodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ItemTile extends StatefulWidget {
  const ItemTile({super.key, required this.kmodel});
  final KhorogaModel kmodel;

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      onDismissed: (direction) {
        showDialog(
          context: context,
          builder: (dialogContext) {
            return AlertDialog.adaptive(
              title: Text("deletefroga".tr(), style: TextStyles.size20.copyWith(color: AppColors.darkColor)),
              content: Text("sure".tr(), style: TextStyles.size18.copyWith(color: AppColors.darkColor)),
              actions: [
                TextButton(
                  onPressed: () async {
                    await removekhoroga();
                    Navigator.pop(dialogContext);
                  },
                  child: Text('Delete', style: TextStyles.size16.copyWith(color: AppColors.darkColor)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    setState(() {});
                  },
                  child: Text('Cancel', style: TextStyles.size16.copyWith(color: AppColors.darkColor)),
                ),
              ],
            );
          },
        );
      },
      background: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.redColor, borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.delete, color: AppColors.wightColor),
            Text("delete".tr(), style: TextStyles.size20.copyWith(color: AppColors.wightColor)),
          ],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(color: AppColors.primaryColor.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          title: Text(
            context.isArabic ? widget.kmodel.arName ?? "" : widget.kmodel.enName ?? "",
            style: TextStyles.size20.copyWith(color: AppColors.wightColor),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(imageUrl: widget.kmodel.image ?? "", width: 80, fit: BoxFit.fill),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.kmodel.date ?? "", style: TextStyles.size16.copyWith(color: AppColors.wightColor)),
              Text(widget.kmodel.time ?? "", style: TextStyles.size16.copyWith(color: AppColors.wightColor)),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text((widget.kmodel.rating).toString(), style: TextStyles.size18.copyWith(color: AppColors.wightColor)),
              const Icon(Icons.star, color: Colors.amber),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> removekhoroga() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final doc = FirebaseFirestore.instance.collection("khoroga").doc(userId);
    await doc.update({
      "list": FieldValue.arrayRemove([widget.kmodel.toJson()]),
    });
  }
}
