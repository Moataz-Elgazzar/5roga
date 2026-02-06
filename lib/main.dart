import 'package:app_5roga/core/routes/routes.dart';
import 'package:app_5roga/core/services/local/shered_prefrences.dart';
import 'package:app_5roga/core/services/notification/local_notification.dart';
import 'package:app_5roga/core/services/notification/work_manager.dart';
import 'package:app_5roga/core/utils/theme.dart';
import 'package:app_5roga/features/addPlace/presentation/cubit/addplace_cubit.dart';
import 'package:app_5roga/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:app_5roga/firebase_options.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "config.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GoogleSignIn.instance.initialize();
  await SharedPref.init();
  await EasyLocalization.ensureInitialized();
  await Future.wait([LocalNotificationService.init(), WorkManager.init()]);

  themeNotifier.value = SharedPref.getDarkMode() ? ThemeMode.dark : ThemeMode.light;
  runApp(
    EasyLocalization(
      supportedLocales: [const Locale('en'), const Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('ar'),
      child: DevicePreview(
        enabled: kDebugMode,
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AuthCubit()),
            BlocProvider(create: (_) => AddplaceCubit()),
          ],
          child: const MainApp(),
        ),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        return MaterialApp.router(routerConfig: Routes.route, debugShowCheckedModeBanner: false, themeMode: mode, darkTheme: AppTheme.darkTheme, theme: AppTheme.lightTheme, localizationsDelegates: context.localizationDelegates, supportedLocales: context.supportedLocales, locale: context.locale);
      },
    );
  }
}
