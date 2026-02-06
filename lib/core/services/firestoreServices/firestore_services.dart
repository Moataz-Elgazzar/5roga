import 'package:app_5roga/features/userHome/data/models/placemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreServices {
  static final CollectionReference _userData = FirebaseFirestore.instance.collection('user');
  static final CollectionReference _placeData = FirebaseFirestore.instance.collection('places');
  late final PlaceModel model;

  static Future<DocumentSnapshot> getUserData() {
    final String? currentUser = FirebaseAuth.instance.currentUser?.uid;
    return _userData.doc(currentUser).get();
  }

  static Future<QuerySnapshot> getPlace(String? category, String? subCategory, String? modeCategory) {
    Query query = _placeData;

    if (category != null) {
      query = query.where('englishPlaceCategories', isEqualTo: category);
    }

    if (subCategory != null) {
      query = query.where('englishSubCategories', isEqualTo: subCategory);
    }

    if (modeCategory != null) {
      query = query.where('enMode', isEqualTo: modeCategory);
    }

    return query.get();
  }

  static Stream<QuerySnapshot<Object?>> filterPlace() {
    return _placeData.where('isChosen', isEqualTo: true).snapshots();
  }

  static Future<QuerySnapshot> searchPlace(String searchKey , bool isArabic) {
    return _placeData.orderBy(isArabic ? 'arname' : 'enname').startAt([searchKey]).endAt(['$searchKey\uf8ff']).get();
  }
}
