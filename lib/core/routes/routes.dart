import 'package:app_5roga/features/addPlace/presentation/pages/addPlace_screen.dart';
import 'package:app_5roga/features/adminMain/pages/adminMain_screen.dart';
import 'package:app_5roga/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:app_5roga/features/auth/presentation/forgetpassword/pages/forgetpassword_screen.dart';
import 'package:app_5roga/features/auth/presentation/login/pages/login_screen.dart';
import 'package:app_5roga/features/auth/presentation/register/pages/register_screen.dart';
import 'package:app_5roga/features/categoryDetails/presentation/pages/categorydetails_screen.dart';
import 'package:app_5roga/features/modeDetails/presentation/pages/modedetails_screen.dart';
import 'package:app_5roga/features/onboarding/onboarding_screen.dart';
import 'package:app_5roga/features/placeDetails/presentation/pages/fullMenuImage_screen.dart';
import 'package:app_5roga/features/placeDetails/presentation/pages/menu_screen.dart';
import 'package:app_5roga/features/placeDetails/presentation/pages/placedetails_screen.dart';
import 'package:app_5roga/features/categoryDetails/presentation/pages/search_screen.dart';
import 'package:app_5roga/features/splash/splash_screen.dart';
import 'package:app_5roga/features/user5rogty/presentation/pages/user5rogty_screen.dart';
import 'package:app_5roga/features/userFavorite/presentation/pages/userFavorite_screen.dart';
import 'package:app_5roga/features/userHome/data/models/catogery.dart';
import 'package:app_5roga/features/userHome/data/models/mode.dart';
import 'package:app_5roga/features/userHome/data/models/placemodel.dart';
import 'package:app_5roga/features/userHome/presentation/pages/choosen_screen.dart';
import 'package:app_5roga/features/userHome/presentation/pages/userhome_screen.dart';
import 'package:app_5roga/features/userMain/pages/userMain_screen.dart';
import 'package:app_5roga/features/userProfile/presentation/pages/userProfile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Routes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetPassword = '/forgetPassword';
  static const String userMain = '/userMain';
  static const String adminMain = '/adminMain';
  static const String userHome = '/userHome';
  static const String user5rogty = '/user5rogty';
  static const String userFavorite = '/userFavorite';
  static const String userProfile = '/userProfile';
  static const String userDetails = '/userDetails';
  static const String categoryDetails = '/categoryDetails';
  static const String modeDetails = '/modeDetails';
  static const String addPlace = '/addPlace';
  static const String menu = '/menu';
  static const String fullScreen = '/fullScreen';
  static const String choosen = '/choosen';
  static const String search = '/search';

  static GoRouter route = GoRouter(
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: onboarding, builder: (context, state) => const OnboardingScreen()),

      GoRoute(
        path: login,
        builder: (context, state) => BlocProvider(create: (BuildContext context) => AuthCubit(), child: const LoginScreen()),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => BlocProvider(create: (BuildContext context) => AuthCubit(), child: const RegisterScreen()),
      ),
      GoRoute(
        path: forgetPassword,
        builder: (context, state) => BlocProvider(create: (BuildContext context) => AuthCubit(), child: const ForgetpasswordScreen()),
      ),
      GoRoute(path: userMain, builder: (context, state) => const UserMainScreen()),
      GoRoute(path: adminMain, builder: (context, state) => const AdminMainScreen()),
      GoRoute(path: userHome, builder: (context, state) => const UserHomeScreen()),
      GoRoute(path: user5rogty, builder: (context, state) => const User5rogtyScreen()),
      GoRoute(path: userFavorite, builder: (context, state) => const UserFavoriteScreen()),
      GoRoute(path: userProfile, builder: (context, state) => const UserProfileScreen()),
      GoRoute(
        path: userDetails,
        builder: (context, state) {
          final model = state.extra as PlaceModel;
          return PlacedetailsScreen(model: model);
        },
      ),
      GoRoute(
        path: choosen,
        builder: (context, state) {
          return const ChoosenScreen();
        },
      ),
      GoRoute(
        path: menu,
        builder: (context, state) {
          final model = state.extra as PlaceModel;
          return MenuScreen(model: model);
        },
      ),
      GoRoute(
        path: fullScreen,
        builder: (context, state) {
          final imageUrl = state.extra as String;
          return FullMenuImageScreen(imageUrl: imageUrl);
        },
      ),
      GoRoute(path: addPlace, builder: (context, state) => const AddPlaceScreen()),
      GoRoute(
        path: categoryDetails,
        builder: (context, state) {
          final model = state.extra as CategoryModel;
          return CategoryDetailsScreen(model: model);
        },
      ),
      GoRoute(
        path: modeDetails,
        builder: (context, state) {
          final model = state.extra as ModeModel;
          return ModeDetailsScreen(model: model);
        },
      ),
      GoRoute(
        path: search,
        builder: (context, state) {
          return SearchScreen(searchKey: state.extra as String);
        },
      ),
    ],
  );
}
