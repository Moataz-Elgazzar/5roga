class KhorogaModel {
  final String? id;
  final String? arName;
  final String? enName;
  final String? image;
  double? rating;
  final String? date;
  final String? time;

  KhorogaModel({this.id, this.arName, this.enName, this.image, this.rating, this.date, this.time});

  factory KhorogaModel.fromJson(Map<String, dynamic> json) {
    return KhorogaModel(id: json["id"], arName: json["arName"], enName: json["enName"], image: json["image"], rating: json["rating"] == null ? null : double.tryParse(json["rating"].toString()), date: json["date"], time: json["time"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "arName": arName, "enName": enName, "image": image, "rating": rating, "date": date, "time": time};
  }
}
