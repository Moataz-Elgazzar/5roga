class FavoriteModel {
  final List<String>? favoriteList;
  final String? userId;

  FavoriteModel({this.userId, this.favoriteList});

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(userId: json["userId"], favoriteList: List<String>.from(json["favoriteList"] ?? []));
  }

  Map<String, dynamic> toJson() {
    return {"userId": userId, "favoriteList": favoriteList};
  }
}
