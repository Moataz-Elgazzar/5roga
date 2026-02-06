import 'package:app_5roga/core/constants/app_images.dart';
import 'package:app_5roga/core/routes/navigator.dart';
import 'package:app_5roga/core/routes/routes.dart';
import 'package:app_5roga/core/services/local/shered_prefrences.dart';
import 'package:app_5roga/core/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isonBoarding = SharedPref.getisBoardingSeen();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  initState() {
    super.initState();
    _intializesplash();
  }

  Future<void> _intializesplash() async {
    await Future.delayed(const Duration(seconds: 3), () async {
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).get();
        final role = doc['role'];
        if (role == 'admin') {
          if (!mounted) return;
          goToBase(context, Routes.adminMain);
        } else {
          if (!mounted) return;
          goToBase(context, Routes.userMain);
        }
      } else {
        if (isonBoarding) {
          if (!mounted) return;
          pushWithReplacement(context, Routes.login);
        } else {
          if (!mounted) return;
          pushWithReplacement(context, Routes.onboarding);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Image.asset(AppImages.splashPng, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
          Center(
            child: Image.asset(AppImages.logoPng, width: MediaQuery.sizeOf(context).width * 0.8, height: MediaQuery.sizeOf(context).height * 0.8),
          ),
        ],
      ),
    );
  }
}
