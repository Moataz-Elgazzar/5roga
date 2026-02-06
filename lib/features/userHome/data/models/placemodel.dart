class PlaceModel {
  final String? id;
  final String? arName;
  final String? enName;
  final String? arDescription;
  final String? enDescription;
  final String? mainImage;
  double? rating;
  final String? location;
  final String? address;
  final String? arabicPlaceCategories;
  final String? englishPlaceCategories;
  final String? arabicSubCategories;
  final String? englishSubCategories;
  final String? arMode;
  final String? enMode;
  final bool? isChosen;
  final String? openHour;
  final String? closeHour;
  final String? phoneNumber;
  final List<String>? menuImage;
  final List<double>? ratings;
  final int? ratingCount;

  PlaceModel({this.id, this.arName, this.enName, this.arDescription, this.enDescription, this.mainImage, this.rating, this.location, this.address, this.arabicPlaceCategories, this.englishPlaceCategories, this.arabicSubCategories, this.englishSubCategories, this.arMode, this.enMode, this.isChosen, this.openHour, this.closeHour, this.phoneNumber, this.menuImage, this.ratings, this.ratingCount});

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json["id"],
      arName: json["arname"],
      enName: json["enname"],
      arDescription: json["ardescription"],
      enDescription: json["endescription"],
      mainImage: json["mainImage"],
      rating: json["rating"] == null ? 0 : double.tryParse(json["rating"].toString()),
      location: json["location"],
      address: json["address"],
      arabicPlaceCategories: json["arabicPlaceCategories"],
      englishPlaceCategories: json["englishPlaceCategories"],
      arabicSubCategories: json["arabicSubCategories"],
      englishSubCategories: json["englishSubCategories"],
      arMode: json["arMode"],
      enMode: json["enMode"],
      isChosen: json["isChosen"],
      openHour: json["openHour"],
      closeHour: json["closeHour"],
      phoneNumber: json["phoneNumber"].toString(),
      menuImage: List<String>.from(json["menuImage"] ?? []),
      ratingCount: json["ratingCount"] ?? 0,
      ratings: json["ratings"] != null ? List<double>.from(json["ratings"].map((x) => double.tryParse(x.toString()) ?? 0.0)) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "arname": arName, "enname": enName, "ardescription": arDescription, "endescription": enDescription, "mainImage": mainImage, "rating": rating, "location": location, "address": address, "arabicPlaceCategories": arabicPlaceCategories, "englishPlaceCategories": englishPlaceCategories, "arabicSubCategories": arabicSubCategories, "englishSubCategories": englishSubCategories, "arMode": arMode, "enMode": enMode, "isChosen": isChosen, "openHour": openHour, "closeHour": closeHour, "phoneNumber": phoneNumber, "menuImage": menuImage, 'ratings': ratings, 'ratingCount': ratingCount};
  }

  Map<String, dynamic> update() => {
    if (arName != null) "arname": arName,
    if (enName != null) "enname": enName,
    if (arDescription != null) "ardescription": arDescription,
    if (enDescription != null) "endescription": enDescription,
    if (mainImage != null) "mainimage": mainImage,
    if (rating != null) "rating": rating,
    if (location != null) "location": location,
    if (address != null) "address": address,
    if (arabicPlaceCategories != null) "arabicPlaceCategories": arabicPlaceCategories,
    if (englishPlaceCategories != null) "englishPlaceCategories": englishPlaceCategories,
    if (arabicSubCategories != null) "arabicSubCategories": arabicSubCategories,
    if (englishSubCategories != null) "englishSubCategories": englishSubCategories,
    if (arMode != null) "arMode": arMode,
    if (enMode != null) "enMode": enMode,
    if (isChosen != null) "isChosen": isChosen,
    if (openHour != null) "openHour": openHour,
    if (closeHour != null) "closeHour": closeHour,
    if (phoneNumber != null) "phoneNumber": phoneNumber,
    if (menuImage != null) "menuImage": menuImage,
  };
}
