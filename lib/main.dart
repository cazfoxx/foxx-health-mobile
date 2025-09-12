import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart'
    show FirebaseCrashlytics;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/core/services/dynamic_links_service.dart';
import 'package:foxxhealth/core/utils/app_storage.dart';
import 'package:foxxhealth/features/presentation/cubits/forgot_password/forgot_password_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/login/login_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/profile/profile_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_search/symptom_search_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/main_navigation/main_navigation_screen.dart';
import 'package:foxxhealth/features/presentation/screens/splash/splash_screen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:get_storage/get_storage.dart';


void main() async {
  // Replace SentryWidgetsFlutterBinding with regular Flutter initialization
  // SentryWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Lock typography scaling
  MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.first)
      .textScaler;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase Analytics
  final analytics = FirebaseAnalytics.instance;
  await analytics.setAnalyticsCollectionEnabled(true);

  await GetStorage.init();

  // Initialize Dynamic Links Service
  await DynamicLinksService().initialize();

  const fatalError = true;
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      // FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      // FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };

  // Remove the entire SentryFlutter.init block
  // await SentryFlutter.init(
  //  (options) { ... },
  //  appRunner: () => runApp(SentryWidget(child: const MyApp())),
  // );

  // Replace with direct app runner
  runApp(const MyApp());

  // Remove this line
  // await Sentry.captureException(StateError('This is a sample exception.'));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DynamicLinksService _dynamicLinksService = DynamicLinksService();
  StreamSubscription? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _setupDynamicLinks();
  }

  void _setupDynamicLinks() {
    _linkSubscription = _dynamicLinksService.linkStream.listen((linkData) {
      log('Deep link received in app: $linkData');
      _handleDeepLink(linkData);
    });
  }

  void _handleDeepLink(Map<String, dynamic> linkData) {
    final String? linkType = linkData['type'] as String?;
    
    switch (linkType) {
      case 'payment_success':
        // Navigate to payment success screen
        log('Handling payment success deep link');
        break;
      case 'premium_feature':
        // Navigate to premium feature screen
        log('Handling premium feature deep link');
        break;
      case 'referral':
        // Navigate to referral screen
        log('Handling referral deep link');
        break;
      case 'app_deep_link':
        // General app deep link
        log('Handling general app deep link');
        break;
      default:
        log('Unknown deep link type: $linkType');
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<bool> _checkAuthToken() async {
    // Load credentials from storage
    await AppStorage.loadCredentials();
    
    if (AppStorage.accessToken != null && AppStorage.accessToken!.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => LoginCubit()),
            BlocProvider(create: (context) => ProfileCubit()),
            BlocProvider(create: (context) => ForgotPasswordCubit()),
            BlocProvider(create: (context) => OnboardingCubit()),
            BlocProvider(create: (context) => SymptomSearchCubit()),
          ],
          child: GetMaterialApp(
            scaffoldMessengerKey: ApiClient.scaffoldKey,
            title: 'FoxxHealth',
            debugShowCheckedModeBanner: false,
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
            ],
            theme: ThemeData(
              colorScheme:
                  ColorScheme.fromSeed(seedColor: const Color(0xFF6B4EFF)),
              useMaterial3: true,
            ),
            builder: (context, child) {
              // Lock typography scaling
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!,
              );
            },
            home: FutureBuilder<bool>(
              future: _checkAuthToken(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SplashScreen();
                }

                if (snapshot.hasData && snapshot.data == true) {
                  return MainNavigationScreen();
                }

                return const SplashScreen();
              },
            ),
          ),
        );
      },
    );
  }
}
