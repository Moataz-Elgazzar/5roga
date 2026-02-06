import 'package:app_5roga/core/constants/app_images.dart';

class CategoryModel {
  int id;
  String image;
  String title;
  final CategryType type;

  CategoryModel({required this.image, required this.title, required this.id, required this.type});
}

List<CategoryModel> model = [CategoryModel(image: AppImages.locationPng, title: "location", id: 1, type: CategryType.map), CategoryModel(image: AppImages.cinemaPng, title: "cinema", id: 2, type: CategryType.cinema), CategoryModel(image: AppImages.coffePng, title: "coffe_shop", id: 3, type: CategryType.cafes), CategoryModel(image: AppImages.kidsGamesPng, title: "Theme Parks", id: 4, type: CategryType.games), CategoryModel(image: AppImages.sandwitchPng, title: "resturant", id: 5, type: CategryType.resturants)];

enum CategryType { map, cinema, cafes, games, resturants }
