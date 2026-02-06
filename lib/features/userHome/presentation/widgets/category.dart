import 'package:app_5roga/features/userHome/data/models/catogery.dart';
import 'package:app_5roga/features/userHome/presentation/widgets/categoryCard.dart';
import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  const Category({super.key, required this.models});

  final List<CategoryModel> models;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        clipBehavior: Clip.none,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: models.length,
        itemBuilder: (context, index) => Categorycard(model: models[index]),
        separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 10),
      ),
    );
  }
}
