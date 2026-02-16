import 'dart:developer';
import 'dart:io';

import 'package:app_5roga/core/functions/update_image.dart';
import 'package:app_5roga/features/auth/data/models/user_model.dart';
import 'package:app_5roga/features/auth/presentation/cubit/auth_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(InitialAuthState());

  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  register() async {
    emit(AuthLoadingState());
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);

      final User? user = credential.user;
      await user?.updateDisplayName(nameController.text);
      final userModel = UserModel(email: emailController.text, name: nameController.text, uid: user?.uid, role: 'user');
      FirebaseFirestore.instance.collection('user').doc(user?.uid).set(userModel.toJson());
      emit(AuthSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthErrorState(error: 'كلمة السر ضعيفه'));
      } else if (e.code == 'email-already-in-use') {
        emit(AuthErrorState(error: 'البريد الالكتروني مستخدم بالفعل'));
      }
    } catch (e) {
      emit(AuthErrorState(error: 'حدث خطأ ما'));
    }
  }

  login() async {
    emit(AuthLoadingState());
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      final doc = await FirebaseFirestore.instance.collection('user').doc(credential.user?.uid).get(const GetOptions(source: Source.server));
      final role = doc['role'];
      emit(AuthSuccessState(role: role));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthErrorState(error: '.لا يوجد مستخدم بهذا البريد الالكتروني'));
      } else if (e.code == 'wrong-password') {
        emit(AuthErrorState(error: 'كلمة السر غير صحيحه'));
      }
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      log('Initializing Google Sign In...');

      // Initialize Google Sign In first
      await GoogleSignIn.instance.initialize(
        // Don't pass serverClientId unless you need server auth codes
      );

      log('Starting authentication...');

      // Authenticate the user
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();

      log('Got Google user: ${googleUser.email}');

      // Get authentication tokens
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      log('Got ID token: ${googleAuth.idToken != null}');

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      log('Signing in to Firebase...');

      // Sign in to Firebase
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      await saveUserToFirestore(userCredential.user!, googleUser);

      log('Firebase sign in successful: ${userCredential.user?.email}');

      return userCredential;
    } on GoogleSignInException catch (e) {
      log('GoogleSignInException: ${e.code} - ${e.description}');
      throw Exception('خطأ في تسجيل الدخول: ${e.description}');
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException: ${e.code} - ${e.message}');
      throw Exception('خطأ في المصادقة: ${e.message}');
    } catch (e) {
      log('General error: $e');
      throw Exception('حدث خطأ ما: $e');
    }
  }

  Future<void> saveUserToFirestore(User user, GoogleSignInAccount googleUser) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('user').doc(user.uid).get();

      if (!doc.exists) {
        final userdata = UserModel(email: user.email, name: user.displayName, uid: user.uid, image: user.photoURL ?? googleUser.photoUrl, role: 'user');
        await FirebaseFirestore.instance.collection('user').doc(user.uid).set(userdata.toJson());
      } else {
        final userdata = UserModel(email: user.email, name: user.displayName, uid: user.uid, role: 'user', image: user.photoURL ?? googleUser.photoUrl);
        await FirebaseFirestore.instance.collection('user').doc(user.uid).update(userdata.toUpdate());
      }
    } on Exception catch (e) {
      log('Error saving to Firestore: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    emit(AuthLoadingState());
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(AuthSuccessState());
    } on Exception catch (_) {
      emit(AuthErrorState(error: 'حدث خطأ ما'));
    }
  }

  updateData(File? imagefile) async {
    try {
      emit(AuthLoadingState());
      if (imagefile == null) {
        emit(AuthErrorState(error: '.يرجى اختيار صوره'));
        return;
      }
      final String? imageUrl = await updateImageToCloudinary(imagefile);
      if (imageUrl == null) {
        emit(AuthErrorState(error: 'فشل رفع الصوره'));
        return;
      }
      final user = UserModel(image: imageUrl, uid: FirebaseAuth.instance.currentUser!.uid);
      FirebaseFirestore.instance.collection('user').doc(user.uid).update(user.toUpdate());
      emit(AuthSuccessState());
    } on Exception catch (_) {
      emit(AuthErrorState(error: 'حدث خطا ما'));
    }
  }

  signoutUser() async {
    try {
      emit(AuthLoadingState());
      await GoogleSignIn.instance.signOut();
      await FirebaseAuth.instance.signOut();
      emit(AuthSuccessState());
    } on Exception catch (_) {
      emit(AuthErrorState(error: 'لم يتم تسجيل الخروج بنجاح'));
    }
  }
}
