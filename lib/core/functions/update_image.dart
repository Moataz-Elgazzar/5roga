import 'dart:io';

import 'package:dio/dio.dart';

Future<String?> updateImageToCloudinary(File imageFile) async {
  final String cloudName = "dvsihnbfm";
  final String presetName = "se7ety";

  final url = "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

  final dio = Dio();

  try {
    final formData = FormData.fromMap({"upload_preset": presetName, "file": await MultipartFile.fromFile(imageFile.path)});
    final response = await dio.post(url, data: formData);

    if (response.statusCode == 200) {
      return response.data['secure_url'];
    } else {
      return null;
    }
  } on Exception catch (_) {
    return null;
  }
}
