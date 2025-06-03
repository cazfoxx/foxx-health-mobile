import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart'
    show FirebaseCrashlytics;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/core/utils/app_storage.dart';
import 'package:foxxhealth/features/presentation/cubits/appointment/appointment_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/checklist/checklist_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/login/login_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/profile/profile_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_tracker/symptom_tracker_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/symptoms/symptoms_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/home_screen.dart';
import 'package:foxxhealth/features/presentation/screens/splash/splash_screen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  // Initialize storage for API logs
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();

  // Initialize Stripe
  Stripe.publishableKey = 'pk_test_51RUTddCXgPDd1SSItNfmuiSQKJbZA3pehi5kczoxJjlcxyExhyj6BQz0Sdip8Eh6w0JM4iEaeHznFNbiekBwJttD00ZCrqXAzD'; // Replace with your Stripe publishable key
  await Stripe.instance.applySettings();

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final email = prefs.getString('user_email');

    if (token != null && token.isNotEmpty) {
      // Store in global storage
      AppStorage.setCredentials(token: token, email: email);
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
            BlocProvider(create: (context) => AppointmentCubit()),
            BlocProvider(create: (context) => ChecklistCubit()),
            BlocProvider(create: (context) => HealthAssessmentCubit()),
            BlocProvider(create: (context) => ProfileCubit()),
            BlocProvider(create: (context) => SymptomTrackerCubit()),
            BlocProvider(create: (context) => SymptomsCubit()),
          ],
          child: GetMaterialApp(
            scaffoldMessengerKey: ApiClient.scaffoldKey, // Add this line
            title: 'FoxxHealth',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme:
                  ColorScheme.fromSeed(seedColor: const Color(0xFF6B4EFF)),
              useMaterial3: true,
            ),
            home: FutureBuilder<bool>(
              future: _checkAuthToken(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SplashScreen();
                }

                if (snapshot.hasData && snapshot.data == true) {
                  return  HomeScreen();
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
