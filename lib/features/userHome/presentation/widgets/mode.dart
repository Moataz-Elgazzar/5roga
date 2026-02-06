import 'package:app_5roga/features/userHome/data/models/mode.dart';
import 'package:app_5roga/features/userHome/presentation/widgets/modeCard.dart';
import 'package:flutter/material.dart';

class Mode extends StatelessWidget {
  const Mode({super.key, required this.models2});

  final List<ModeModel> models2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        clipBehavior: Clip.none,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: models2.length,
        itemBuilder: (context, index) => Modecard(model2: models2[index]),
        separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 10),
      ),
    );
  }
}
