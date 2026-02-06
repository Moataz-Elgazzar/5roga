import 'package:app_5roga/core/constants/app_images.dart';

class ModeModel {
  int id;
  String image;
  String title;
  final ModeType type;

  ModeModel({required this.image, required this.title, required this.id, required this.type});
}

List<ModeModel> model2 = [ModeModel(type: ModeType.friends, image: AppImages.friendsPng, title: "Friends_Mood", id: 1), ModeModel(type: ModeType.romantic, image: AppImages.romancePng, title: "Romantic_Mood", id: 2), ModeModel(type: ModeType.sea, image: AppImages.seaPng, title: "Chill_Mood", id: 3)];

enum ModeType { friends, romantic, sea }
