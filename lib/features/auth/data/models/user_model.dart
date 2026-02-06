class UserModel {
  String? uid;
  String? name;
  String? email;
  String? image;
  String? role;

  UserModel({this.name, this.email, this.image, this.role, this.uid});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(name: json['name'] as String?, email: json['email'] as String?, image: json['image'] as String?, role: json['role'] as String?, uid: json['uid'] as String);

  Map<String, dynamic> toJson() => {'name': name, 'email': email, 'image': image, 'role': role, 'uid': uid};
  Map<String, dynamic> toUpdate() => {if (name != null) 'name': name, if (email != null) 'email': email, if (image != null) 'image': image, if (role != null) 'role': role, if (uid != null) 'uid': uid};
}
