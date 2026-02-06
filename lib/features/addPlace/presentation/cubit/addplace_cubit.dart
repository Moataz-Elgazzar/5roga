import 'dart:io';

import 'package:app_5roga/core/functions/update_image.dart';
import 'package:app_5roga/features/addPlace/presentation/cubit/addPlace_state.dart';
import 'package:app_5roga/features/userHome/data/models/placemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddplaceCubit extends Cubit<AddPlaceState> {
  AddplaceCubit() : super(AddPlaceInitial());

  String? arabicPlaceCategory;
  String? englishPlaceCategory;
  String? arabicSubCategory;
  String? englishSubCategory;
  String? arabicMode;
  String? englishMode;
  bool isChosenForYou = false;
  double? rate = 0;
  final arabicNameController = TextEditingController();
  final englishNameController = TextEditingController();
  final arabicDescribtionController = TextEditingController();
  final englishDescribtionController = TextEditingController();
  final openingHourController = TextEditingController();
  final closingHourController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final locationController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  addplace(File? mainImage, List<String>? menuImage) async {
    emit(AddPlaceLoading());
    try {
      if (mainImage == null) {
        emit(AddPlaceError("الرجاء اختيار الصورة الرئيسية للمكان"));
        return;
      }
      final String? mainImageUrl = await updateImageToCloudinary(mainImage);
      if (mainImageUrl == null) {
        emit(AddPlaceError("فشل في رفع الصورة الرئيسية، الرجاء المحاولة لاحقاً"));
        return;
      }
      final List<String> updatedMenuImages = [];
      for (var imagePath in menuImage!) {
        if (imagePath.isNotEmpty) {
          final File imageFile = File(imagePath);
          final String? imageUrl = await updateImageToCloudinary(imageFile);
          if (imageUrl != null) {
            updatedMenuImages.add(imageUrl);
          } else {
            emit(AddPlaceError("فشل في رفع احد صور القائمة، الرجاء المحاولة لاحقاً"));
            return;
          }
        }
      }

      final place = PlaceModel(id: openingHourController.text + closingHourController.text + englishNameController.text, arName: arabicNameController.text, enName: englishNameController.text, arDescription: arabicDescribtionController.text, enDescription: englishDescribtionController.text, mainImage: mainImageUrl, location: locationController.text, address: addressController.text, arabicPlaceCategories: arabicPlaceCategory, englishPlaceCategories: englishPlaceCategory, arabicSubCategories: arabicSubCategory, englishSubCategories: englishSubCategory, arMode: arabicMode, enMode: englishMode, isChosen: isChosenForYou, openHour: openingHourController.text, closeHour: closingHourController.text, phoneNumber: phoneController.text, menuImage: updatedMenuImages, rating: rate);
      FirebaseFirestore.instance.collection('places').doc().set(place.toJson());

      emit(AddPlaceSuccess());
    } on Exception catch (_) {
      emit(AddPlaceError("حدث خطأ ما الرجاء المحاولة لاحقاً"));
    }
  }

  updatePlace(File? mainImage, List<String>? menuImage) async {
    emit(AddPlaceLoading());
    try {
      if (mainImage == null) {
        emit(AddPlaceError("الرجاء اختيار الصورة الرئيسية للمكان"));
        return;
      }
      final String? mainImageUrl = await updateImageToCloudinary(mainImage);
      if (mainImageUrl == null) {
        emit(AddPlaceError("فشل في رفع الصورة الرئيسية، الرجاء المحاولة لاحقاً"));
        return;
      }
      final List<String> updatedMenuImages = [];
      for (var imagePath in menuImage!) {
        if (imagePath.isNotEmpty) {
          final File imageFile = File(imagePath);
          final String? imageUrl = await updateImageToCloudinary(imageFile);
          if (imageUrl != null && imageUrl.isNotEmpty) {
            updatedMenuImages.add(imageUrl);
          } else {
            emit(AddPlaceError("فشل في رفع احد صور القائمة، الرجاء المحاولة لاحقاً"));
            return;
          }
        }
      }

      final place = PlaceModel(id: openingHourController.text + closingHourController.text + englishNameController.text, arName: arabicNameController.text, enName: englishNameController.text, arDescription: arabicDescribtionController.text, enDescription: englishDescribtionController.text, mainImage: mainImageUrl, location: locationController.text, address: addressController.text, arabicPlaceCategories: arabicPlaceCategory, englishPlaceCategories: englishPlaceCategory, arabicSubCategories: arabicSubCategory, englishSubCategories: englishSubCategory, arMode: arabicMode, enMode: englishMode, isChosen: isChosenForYou, openHour: openingHourController.text, closeHour: closingHourController.text, phoneNumber: phoneController.text, menuImage: updatedMenuImages);
      FirebaseFirestore.instance.collection('places').doc(place.id).update(place.update());
      emit(AddPlaceSuccess());
    } on Exception catch (_) {
      emit(AddPlaceError("حدث خطأ ما الرجاء المحاولة لاحقاً"));
    }
  }
}
